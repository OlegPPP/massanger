//
//  ContactsViewController.m
//  ChatDemo
//
//  Created by Neo on 6/5/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactsAddContactCell.h"
#import "ContactsConnectedCell.h"
#import <UIBarButtonItem+Badge.h>

@interface ContactsViewController () <ContactsAddContactCellDelegate> {
    NSArray *contacts;
}

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    contacts = @[@{@"name": @"Albert Crane", @"message": @"Hey Sport Buddies!", @"image": @"demo_avatar_cook", @"online": @YES},
                 @{@"name": @"Ben Good", @"message": @"Sports is like a war without a killing.", @"image": @"demo_avatar_cook", @"online": @YES},
                 @{@"name": @"Fred Konstantinopolsky", @"message": @"Hey Sport Buddies!", @"image": @"demo_avatar_cook", @"online": @NO}];
    
    // Customize badge
    // TODO: Fetch badge here
    self.navigationItem.rightBarButtonItem.badgeValue = @"1";
    self.navigationItem.rightBarButtonItem.badgeBGColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.badgeTextColor = [UIColor redColor];
    self.navigationItem.rightBarButtonItem.badgeOriginX = -2;
    
    // Auto height
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 100;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (section == 0) ? @"ADD CONTACTS" : @"CONNECTED CONTACTS";
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = [UIFont systemFontOfSize:18];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? 1 : contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ContactsAddContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactsAddContactCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
    
    ContactsConnectedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactsConnectedCell" forIndexPath:indexPath];
    NSDictionary *data = contacts[indexPath.row];
    
    cell.mainImageView.image = [UIImage imageNamed:data[@"image"]];
    cell.mainTextLabel.text = data[@"name"];
    cell.subTextLabel.text = data[@"message"];
    cell.onlineIndicator.backgroundColor = [data[@"online"] boolValue] ? self.navigationController.navigationBar.barTintColor : [UIColor lightGrayColor];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// MARK: - ContactsAddContactCellDelegate
- (void)addFacebook {
    
}

- (void)addPhone {
    
}

- (void)addInvite {
    
}

@end
