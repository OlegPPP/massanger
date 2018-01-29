//
//  ChatListTeamCell.h
//  ChatDemo
//
//  Created by Neo on 5/19/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NRLabel.h"

@protocol ChatListTeamCellDelegate <NSObject>

- (void)showMembers:(id)sender;

@end

@interface ChatListTeamCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *border1Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *border2Height;
@property (weak, nonatomic) IBOutlet UIImageView *subjectImageView;
@property (weak, nonatomic) IBOutlet UILabel *subjectTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *membersButton;
@property (weak, nonatomic) IBOutlet UILabel *membersDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet NRLabel *unreadCountLabel;
- (IBAction)showMembers:(id)sender;

@property (weak, nonatomic) id<ChatListTeamCellDelegate> delegate;

@end
