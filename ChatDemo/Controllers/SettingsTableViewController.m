//
//  SettingsTableViewController.m
//  ChatDemo
//
//  Created by Neo on 5/16/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "UIView+Border.h"
#import "SettingsDetailCell.h"
#import "SettingsSwitchCell.h"

@interface SettingsTableViewController () {
    NSArray *menuTitles;
    NSArray *imageNames;
    NSArray *cellTypes; // 0 : SettingsDetailCell, 1: SettingsSwitchCell
}
@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Settings";
    
    menuTitles = @[@[@"Chat Storage", @"Manage Contacts", @"Location Services"], @[@"My Contacts", @"My Teams", @"My Sports", @"New Matching Offers"]];
    imageNames = @[@[@"settings_chat", @"settings_contact", @"settings_location"], @[@"settings_contact", @"settings_teams", @"settings_sports", @"settings_offers"]];
    cellTypes = @[@[@0, @0, @1], @[@0, @0, @0, @1]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(didFinishAutoLayout) object:nil];
    
    [self performSelector:@selector(didFinishAutoLayout) withObject:nil afterDelay:0];
}

- (void)didFinishAutoLayout {
    // Add border to header view
    UIColor *borderColor = [[UITableView new] separatorColor];
    CGFloat borderWidth = 1 / [UIScreen mainScreen].scale;
    [_headerView addBottomBorderWithColor:borderColor andWidth:borderWidth];
    [_privacyButton addRightBorderWithColor:borderColor andWidth:borderWidth];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return menuTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [menuTitles[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = menuTitles[indexPath.section][indexPath.row];
    NSString *imageName = imageNames[indexPath.section][indexPath.row];
    if ([cellTypes[indexPath.section][indexPath.row] integerValue] == 0) {
        SettingsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsDetailCell" forIndexPath:indexPath];
        cell.cellTextLabel.text = text;
        cell.cellImageView.image = [UIImage imageNamed:imageName];
        
        return cell;
    } else {
        SettingsSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsSwitchCell" forIndexPath:indexPath];
        cell.cellTextLabel.text = text;
        cell.cellImageView.image = [UIImage imageNamed:imageName];
        
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        // Without space, the header will not be shown
        return @" ";
    } else {
        return @"Notifications";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 0) ? 20 : 56;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    // Disable all-caps
    if ([view isKindOfClass:[UITableViewHeaderFooterView class] ]) {
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *)view;
        tableViewHeaderFooterView.textLabel.text = [tableViewHeaderFooterView.textLabel.text capitalizedString];
        tableViewHeaderFooterView.textLabel.font = [UIFont systemFontOfSize:18];
    }
}

// MARK: - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
