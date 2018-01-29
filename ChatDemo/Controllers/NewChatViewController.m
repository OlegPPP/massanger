//
//  NewChatViewController.m
//  ChatDemo
//
//  Created by Neo on 5/17/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "NewChatViewController.h"
#import "NewChatSubjectCell.h"
#import "NewChatContactCell.h"
#import "NewChatHeaderSubjectCell.h"
#import "NewChatHeaderContactsCell.h"
#import "NewChatSubjectTeamSportCell.h"
#import "NewChatSubjectFixtureCell.h"
#import "NewChatSubjectOtherCell.h"
#import "NSLayoutConstraint+Multiplier.h"
#import "PopoverSelectionViewController.h"
#import "AddChatContactsViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CDChat+CoreDataClass.h"
#import "CDContact+CoreDataClass.h"
#import "AppDelegate.h"
#import <FCUUID.h>
#import "APChatManager.h"

@interface NewChatViewController () <NewChatSubjectCellDelegate, UITextViewDelegate, UIPopoverPresentationControllerDelegate, PopoverSelectionViewControllerDelegate, NewChatHeaderContactsCellDelegate, NewChatHeaderSubjectCellDelegate, NewChatSubjectOtherCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AddChatContactsViewControllerDelegate, NewChatContactCellDelegate> {
    // Contacts currently added
    NSArray *contacts;
    
    // subjectIndex: after selecting team or sport, it will be consolidated
    NSInteger subjectIndex;
    
    // Team, sport or fixture id
    NSString *subjectId;
    
    // Subject description text
    NSString *subjectDesc;
    
    // Other image
    UIImage *otherImage;
    
    // Subject type strings
    NSArray *subjectTypes;
    
    // Demo Team data
    NSArray *teams;
    
    // Demo Sports data
    NSArray *sports;
    
    // Demo Fixture data
    NSArray *fixtures;
    
    // PopoverType
    NSInteger popoverType;  //0: Team selection, 1: Sport selection, 2: Delete or Exit chat
}
@end

@implementation NewChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    contacts = [@[] mutableCopy];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0; // set to whatever your "average" cell height is
    
    subjectIndex = -1;
    
    // Set title
    if (_isEditChat) {
        NSDictionary *subject = (NSDictionary *)_chat.subject;
        NSString *subjectType = subject[@"subjectType"];
        if ([subjectType isEqualToString:@"Team"]) {
            subjectIndex = 0;
            subjectId = subject[@"subjectTeamID"];
        } else if ([subjectType isEqualToString:@"Sport"]) {
            subjectIndex = 1;
            subjectId = subject[@"subjectSportID"];
        } else if ([subjectType isEqualToString:@"Fixture"]) {
            subjectIndex = 2;
            subjectId = subject[@"subjectFixtureID"];
        } else {
            subjectIndex = 3;
        }
        
        contacts = [_chat.chatWithContacts sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES]]];
        
        subjectDesc = subject[@"subjectTitle"];
        
        if (_isChatOwner) {
            self.title = @"Edit My Chat";
            [self.navigationItem.rightBarButtonItem setTitle:@"UPDATE"];
        } else {
            self.title = @"Chat Details";
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"chats_more_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(showMore:)];
        }
        
    }
    
    // Remove separator left insets
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
    if (!_isEditChat) {
        // On new chat, the create button is disabled at first
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    subjectTypes = @[@"Team", @"Sport", @"Fixture", @"Other"];
    
    // Demo
    teams = @[@{@"id": @"1", @"image": @"dublin", @"title": @"Dublin", @"subimage": @"soccer18", @"subtitle": @"Soccer"},
              @{@"id": @"2", @"image": @"connaght", @"title": @"Connacht", @"subimage": @"rugby18", @"subtitle": @"Rugby"}];
    sports = @[@{@"id": @"1", @"image": @"soccer36", @"title": @"GAA", @"subimage": @"ireland", @"subtitle": @"Ireland"},
               @{@"id": @"2", @"image": @"rugby36", @"title": @"Rugby", @"subimage": @"scotland", @"subtitle": @"Scotland"}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: - actions
- (void)showMore:(id)sender {
    UIView *v = [sender view];
    [self willShowMore:v];
}

- (IBAction)createNewChat:(id)sender {
    [self.view endEditing:NO];
    
    if (subjectDesc.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter subject text." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if (contacts.count == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please add at least one contact." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    API_Chat *chatModel = [API_Chat new];
    chatModel.chatID = [FCUUID uuid];
    chatModel.subjectTitle = subjectDesc;
    chatModel.subjectType = subjectTypes[subjectIndex];
    switch (subjectIndex) {
        case 0:
            chatModel.subjectTeamID = subjectId;
            break;
        case 1:
            chatModel.subjectSportID = subjectId;
            break;
        case 2:
            chatModel.subjectFixtureID = subjectId;
        default: {
            chatModel.subjectImageAvailable = (otherImage != nil) ? @"true" : @"false";
            
            if (otherImage != nil) {
                chatModel.subjectImageLastUpdateDate = [NSDate date];
                chatModel.subjectImageID = [FCUUID uuid];
                
                // Save image to docs directory
                NSString *fileName = [NSString stringWithFormat:@"%@.jpg", chatModel.subjectImageID];
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
                NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName]; //Add the file name
                [UIImageJPEGRepresentation(otherImage, 0.5) writeToFile:filePath atomically:YES]; //Write the file
            }
        }
            break;
    }
    chatModel.chatMemberContactId = [NSMutableArray new];
    for (CDContact *contact in contacts) {
        [chatModel.chatMemberContactId addObject:contact.appContactId];
    }
    
    if (_isEditChat) {
        chatModel.chatID = _chat.chatId;
        [[APChatManager sharedManager] updateChat:chatModel success:^(NSString *success) {
            [self.navigationController popViewControllerAnimated:YES];
        } failure:nil];
    } else {
        [[APChatManager sharedManager] createChat:chatModel success:^(NSString *success) {
            [self.navigationController popViewControllerAnimated:YES];
        } failure:nil];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowCount = 0;
    
    if (_isEditChat && !_isChatOwner)
        rowCount += 1;  // +2, -1 for subject selection
    
    if (subjectIndex >= 0)
        rowCount++;
    
    return rowCount + 3 + contacts.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[NewChatSubjectTeamSportCell class]] || [cell isKindOfClass:[NewChatSubjectFixtureCell class]] || [cell isKindOfClass:[NewChatSubjectOtherCell class]]) {
        // Hide separator
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
    }
    
    if (_isEditChat && !_isChatOwner && [cell isKindOfClass:[NewChatHeaderSubjectCell class]]) {
        // Hide separator
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    
    if (_isEditChat && !_isChatOwner) {
        if (row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewChatHeaderOwnerCell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        if (row == 1) {
            NewChatContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewChatContactCell" forIndexPath:indexPath];
            
            // Set owner name here
            NSSet *filtered = [_chat.chatWithContacts filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"appContactId == %@", _chat.chatOwner]];
            
            if (filtered.count > 0) {
                CDContact *owner = filtered.anyObject;
                [cell setProfileName:[NSString stringWithFormat:@"%@ %@", owner.firstName, owner.lastName]];
            }
            
            cell.removeButton.hidden = YES;
            
            return cell;
        }
        
        row -= 2;
    }
    
    // Subject header cell
    if (row == 0) {
        NewChatHeaderSubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewChatHeaderSubjectCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.moreButton.hidden = !_isEditChat;
        return cell;
    }
    
    row--;
    
    if (!_isEditChat || _isChatOwner) {
        if (row == 0) {
            NewChatSubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewChatSubjectCell" forIndexPath:indexPath];
            cell.delegate = self;
            [cell selectSubject:subjectIndex];
            return cell;
        }
        
        row--;
    }
    
    // Subject details cell
    if (subjectIndex >= 0) {
        if (row == 0) {
            switch (subjectIndex) {
                case 0:
                {
                    NewChatSubjectTeamSportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewChatSubjectTeamSportCell" forIndexPath:indexPath];
                    
                    cell.subjectImageView.image = [UIImage imageNamed:@"dublin"];
                    
                    NSDictionary *team = [teams filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"id == %@", subjectId]][0];
                    
                    cell.titleLabel.text = team[@"title"];
                    cell.subtitleLabel.text = team[@"subtitle"];
                    cell.subjectImageView.image = [UIImage imageNamed:team[@"image"]];
                    cell.descTextView.delegate = self;
                    cell.descTextView.text = subjectDesc;
                    cell.descTextView.delegate = self;
                    cell.pointerConstraint = [cell.pointerConstraint updateMultiplier:0.25];
                    cell.clipsToBounds = !(_isEditChat && !_isChatOwner);
                    return cell;
                }
                    break;
                case 1:
                {
                    NewChatSubjectTeamSportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewChatSubjectTeamSportCell" forIndexPath:indexPath];
                    
                    NSDictionary *sport = [sports filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"id == %@", subjectId]][0];
                    
                    cell.titleLabel.text = sport[@"title"];
                    cell.subtitleLabel.text = sport[@"subtitle"];
                    cell.subjectImageView.image = [UIImage imageNamed:sport[@"image"]];
                    cell.descTextView.delegate = self;
                    cell.descTextView.text = subjectDesc;
                    cell.pointerConstraint = [cell.pointerConstraint updateMultiplier:0.75];
                    cell.clipsToBounds = !(_isEditChat && !_isChatOwner);
                    return cell;
                }
                    break;
                case 2:
                {
                    NewChatSubjectFixtureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewChatSubjectFixtureCell" forIndexPath:indexPath];
                    cell.descTextView.delegate = self;
                    cell.descTextView.text = subjectDesc;
                    cell.descTextView.delegate = self;
                    cell.pointerConstraint = [cell.pointerConstraint updateMultiplier:1.25];
                    cell.clipsToBounds = !(_isEditChat && !_isChatOwner);
                    return cell;
                }
                    break;
                default:
                    break;
            }
            
            // Other subject
            NewChatSubjectOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewChatSubjectOtherCell" forIndexPath:indexPath];
            
            cell.delegate = self;
            cell.descTextView.delegate = self;
            cell.descTextView.text = subjectDesc;
            cell.descTextView.delegate = self;
            cell.pointerConstraint = [cell.pointerConstraint updateMultiplier:1.75];
            cell.clipsToBounds = !(_isEditChat && !_isChatOwner);
            if (otherImage == nil)
                [cell.imageButton setImage:[UIImage imageNamed:@"chats_camera"] forState:UIControlStateNormal];
            else
                [cell.imageButton setImage:otherImage forState:UIControlStateNormal];
            
            return cell;
        }
        
        row--;
    }
    
    // Contacts header cell
    if (row == 0) {
        NewChatHeaderContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewChatHeaderContactsCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
    
    row--;
    
    NewChatContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewChatContactCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.tag = row;
    CDContact *contact = contacts[row];
    [cell setProfileName:[NSString stringWithFormat:@"%@ %@", contact.firstName, contact.lastName]];
    
    return cell;
}

// MARK: - NewChatSubjectCellDelegate
- (void)didSelectSubject:(NSInteger)index sender:(UIView *)sender {
    if (index == 0 || index == 1) {
        
        NSMutableArray *arrayData = [NSMutableArray new];
        NSArray *sampleDic;
        
        if (index == 0) { // Team
            sampleDic = teams;
            popoverType = 0;
        } else { // Sports
            sampleDic = sports;
            popoverType = 1;
        }
        
        for (NSDictionary *dic in sampleDic) {
            PopoverSelectionModel *model = [PopoverSelectionModel new];
            model.image = dic[@"image"];
            model.subimage = dic[@"subimage"];
            model.title = dic[@"title"];
            model.subtitle = dic[@"subtitle"];
            [arrayData addObject:model];
        }
        
        // Show popover for selecting sports or team
        [self showPopoverWithData:arrayData sender:sender];
        return;
    }
    
    // Enable create
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    // If same, return
    if (subjectIndex == index) {
        return;
    }
    
    subjectIndex = index;
    
    // Reset description string
//    subjectDesc = @"";
    
    // Reset selected image on other
    otherImage = nil;
    
    [self.tableView reloadData];
}

// MARK: - show popover
- (void)showPopoverWithData:(NSArray *)arrayData sender:(UIView *)sender {
    PopoverSelectionViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PopoverSelectionViewController"];
    vc.delegate = self;
    vc.modalPresentationStyle = UIModalPresentationPopover;
    vc.cellType = PopoverCellTypeSubtitle;
    
    vc.arrayData = arrayData;
    
    UIPopoverPresentationController *popoverVC = vc.popoverPresentationController;
    popoverVC.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popoverVC.delegate = self;
    popoverVC.sourceView = sender;
    popoverVC.sourceRect = [sender bounds];
    
    [self presentViewController:vc animated:YES completion:nil];
}

// MARK: - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    [self.tableView beginUpdates];
    subjectDesc = textView.text;
    [self.tableView endUpdates];
}

// MARK: - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addChatContacts"]) {
        AddChatContactsViewController *vc = ((UINavigationController *)segue.destinationViewController).viewControllers[0];
        vc.selectedContacts = [NSSet setWithArray:contacts];
        vc.delegate = self;
    }
}

// MARK: - UIPopoverPresentationControllerDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

// MARK: - PopoverSelectionViewControllerDelegate
- (void)didSelectItem:(NSInteger)index withAction:(NSInteger)action {
    if (popoverType == 2) {
        if (index == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure you want to clear all messages?" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // Clear chat
                [[APChatManager sharedManager] deleteChatMessage:_chat.chatId success:^(NSString *success) {
                    if ([_delegate respondsToSelector:@selector(shouldRefreshChat)]) {
                        [_delegate shouldRefreshChat];
                    }
                } failure:nil];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            // Exit chat
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure you want to exit current chat?" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // Clear chat
                [[APChatManager sharedManager] exitChat:_chat.chatId success:^(NSString *success) {
                    [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
                } failure:nil];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
        return;
    }
    
    if (popoverType == 0) { // 0: Team
        subjectId = teams[index][@"id"];
        subjectIndex = 0;
    } else if (popoverType == 1) {
        subjectId = teams[index][@"id"];
        subjectIndex = 1;
    }
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
// Reset description string
//    subjectDesc = @"";
    
    // Reset selected image on other
    otherImage = nil;
    
    [self.tableView reloadData];
}

// MARK: - NewChatHeaderSubjectCellDelegate
- (void)willShowMore:(id)sender {
    NSMutableArray *arrayData = [NSMutableArray new];
    NSArray *sampleDic = @[@{@"image": @"chats_clear", @"title": @"Clear Chat", @"subtitle": @"remove all chat content"},
                      @{@"image": @"chats_exit", @"title": @"Exit Chat", @"subtitle": @"leave chat"}];
    
    for (NSDictionary *dic in sampleDic) {
        PopoverSelectionModel *model = [PopoverSelectionModel new];
        model.image = dic[@"image"];
        model.title = dic[@"title"];
        model.subtitle = dic[@"subtitle"];
        [arrayData addObject:model];
    }
    
    popoverType = 2;
    
    // Show popover for more
    [self showPopoverWithData:arrayData sender:sender];
}

// MARK: - NewChatHeaderContactsCellDelegate
- (void)willAddNewContact {
    // Present add new contact view controller
    [self performSegueWithIdentifier:@"addChatContacts" sender:self];
}

// MARK: - NewChatSubjectOtherCellDelegate
- (void)willPresentCamera {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Choose" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusDenied: {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Unable to access the Camera" message:@"To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app." preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            }
                break;
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
                    }
                }];
            }
            default:
                [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
                break;
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Select photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

// MARK: - Camera and image picker related
- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePicker.sourceType = sourceType;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    otherImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self.tableView reloadData];
}

// MARK: - AddChatContactsViewControllerDelegate
- (void)addContacts:(NSArray *)newContacts {
    contacts = newContacts;
    
    [self.tableView reloadData];
}

// MARK: - NewChatContactCellDelegate
- (void)didRemoveContact:(id)sender {
    NSMutableArray *tempContacts = [contacts mutableCopy];
    [tempContacts removeObjectAtIndex:[sender tag]];
    contacts = [tempContacts copy];
    
    [self.tableView reloadData];
}

@end
