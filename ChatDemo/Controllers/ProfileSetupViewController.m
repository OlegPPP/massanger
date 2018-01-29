//
//  ProfileSetupViewController.m
//  ChatDemo
//
//  Created by Neo on 5/16/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "ProfileSetupViewController.h"
#import "ProfileSetupNameCell.h"
#import "ProfileSetupCollapseCell.h"
#import "ProfileSetupLocationCell.h"
#import <PickerCells.h>
#import <GooglePlaces/GooglePlaces.h>

@interface ProfileSetupViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, PickerCellsDelegate, ProfileSetupLocationCellDelegate, GMSAutocompleteViewControllerDelegate> {
    NSString *firstName;
    NSString *lastName;
    NSString *gender;
    NSString *birthday;
    NSString *location;
    
    CGFloat originY;
    
    PickerCellsController *pickersController;
}

@end

@implementation ProfileSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set Title
    self.navigationItem.title = @"Profile Setup";
    
    // Set bar button items
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cancel"] style:UIBarButtonItemStyleDone target:self action:@selector(cancelProfileEdit:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"SAVE" style:UIBarButtonItemStyleDone target:self action:@selector(saveProfile:)];
    
    // Add tap gesture recognizer to profile view
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProfileImageView:)];
    [_profileImageContainerView addGestureRecognizer:tapGR];
    
    // Auto table height
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 10;
    
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self setupTableWithPickers];
}

- (void)setupTableWithPickers {
    pickersController = [PickerCellsController new];
    [pickersController attachToTableView:self.tableView tableViewsPriorDelegate:self withDelegate:self];
    
    // Gender picker
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    
    NSIndexPath *pickerIP = [NSIndexPath indexPathForRow:0 inSection:1];
    [pickersController addPickerView:pickerView forIndexPath:pickerIP];
    
    // Birthdate picker
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.date = [NSDate date];
    [pickersController addDatePicker:datePicker forIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    [datePicker addTarget:self action:@selector(dateSelected:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    originY = self.view.frame.origin.y;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)note {
    CGRect keyboardSize = [[note.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    if (self.view.frame.origin.y == originY) {
        self.view.frame = CGRectMake(0, originY - keyboardSize.size.height / 3 * 2, self.view.frame.size.width, self.view.frame.size.height);
    }
}

- (void)keyboardWillHide:(NSNotification *)note {
    if (self.view.frame.origin.y != originY) {
        self.view.frame = CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height);
    }
}

- (void)viewDidLayoutSubviews {
    // Apply round radius to profile image
    _profileImageView.layer.cornerRadius = 40;
    _profileImageView.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


// MARK: - Image Picker actions
- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePicker.sourceType = sourceType;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

// MARK: - Bar button item actions
- (void)cancelProfileEdit:(id)sender {
    [self.view endEditing:NO];
}

- (void)saveProfile:(id)sender {
    
}

// MARK: - Tap Gesture Recognizer action
- (void)tapProfileImageView:(UITapGestureRecognizer *)sender {
    
}

// MARK: - UITableViewDataSource
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return @"personal details";
    return @"";
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = [UIFont systemFontOfSize:18];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return 50;
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 2;
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
        return 44;
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ProfileSetupNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileSetupNameCell" forIndexPath:indexPath];
        cell.textField.text = (indexPath.row == 0) ? firstName : lastName;
        cell.textField.placeholder = (indexPath.row == 0) ? @"First Name" : @"Last Name";
        cell.textField.tag = (indexPath.row == 0) ? 0 : 1;
        cell.textField.delegate = self;
        return cell;
    } else if (indexPath.section == 1) {
        ProfileSetupCollapseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileSetupCollapseCell" forIndexPath:indexPath];
        cell.titleLabel.text = @"Gender";
        cell.subtitleLabel.text = (gender.length == 0) ? @"tap to set gender" : gender;
        return cell;
    } else if (indexPath.section == 2) {
        ProfileSetupCollapseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileSetupCollapseCell" forIndexPath:indexPath];
        cell.titleLabel.text = @"Birthdate";
        cell.subtitleLabel.text = (birthday.length == 0) ? @"tap to set birthdate" : birthday;
        return cell;
    } else {
        ProfileSetupLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileSetupLocationCell" forIndexPath:indexPath];
        cell.titleLabel.text = @"Current Location";
        if (location.length == 0) {
            [cell.addressButton setTitle:@"enter your current location" forState:UIControlStateNormal];
        } else {
            [cell.addressButton setTitle:location forState:UIControlStateNormal];
        }
        cell.delegate = self;
        return cell;
    }
}

// MARK: - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField.tag == 0)
        firstName = text;
    else if (textField.tag == 1)
        lastName = text;
    else
        location = text;
    
    return YES;
}

// MARK: - Actions
- (void)dateSelected:(UIDatePicker *)sender {
    NSIndexPath *ip = [pickersController indexPathForPicker:sender];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy/MM/dd";
    birthday = [dateFormatter stringFromDate:sender.date];
    if (ip)
        [self.tableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationAutomatic];
}

// MARK: - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (row) {
        case 0:
            return @"Not Specified";
        case 1:
            return @"Female";
        default:
            return @"Male";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSIndexPath *ip = [pickersController indexPathForPicker:pickerView];
    gender = [self pickerView:pickerView titleForRow:row forComponent:0];
    if (ip) {
        [self.tableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

// MARK: - ProfileSetupLocationCellDelegate
- (void)tapAddressButton {
    GMSAutocompleteViewController *vc = [GMSAutocompleteViewController new];
    vc.delegate = self;
    
    GMSAutocompleteFilter *filter = [GMSAutocompleteFilter new];
    filter.type = kGMSPlacesAutocompleteTypeFilterAddress;
    vc.autocompleteFilter = filter;
    [self presentViewController:vc animated:YES completion:nil];
}

// MARK: - GMSAutocompleteViewControllerDelegate
- (void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place {
    location = place.formattedAddress;
    [viewController dismissViewControllerAnimated:YES completion:^{
        [self.tableView reloadData];
    }];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController didFailAutocompleteWithError:(NSError *)error {
    NSLog(@"%@", error.localizedDescription);
}

- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
