//
//  ProfileSetupLocationCell.h
//  ChatDemo
//
//  Created by Neo on 5/20/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfileSetupLocationCellDelegate <NSObject>

- (void)tapAddressButton;

@end

@interface ProfileSetupLocationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;
- (IBAction)tapAddressButton:(id)sender;

@property (weak, nonatomic) id<ProfileSetupLocationCellDelegate> delegate;

@end
