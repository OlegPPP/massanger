//
//  SettingsSwitchCell.h
//  ChatDemo
//
//  Created by Neo on 5/16/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsSwitchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellTextLabel;
@property (weak, nonatomic) IBOutlet UISwitch *cellSwitch;

@end
