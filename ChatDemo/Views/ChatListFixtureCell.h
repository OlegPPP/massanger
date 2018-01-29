//
//  ChatListFixtureCell.h
//  ChatDemo
//
//  Created by Neo on 5/19/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NRLabel.h"

@protocol ChatListFixtureCellDelegate <NSObject>

- (void)showMembers:(id)sender;

@end

@interface ChatListFixtureCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *border1Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *border2Height;
@property (weak, nonatomic) IBOutlet UIImageView *subjectImageView;
@property (weak, nonatomic) IBOutlet UILabel *subjectTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *fixtureNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *team1ImageView;
@property (weak, nonatomic) IBOutlet UILabel *team1Label;
@property (weak, nonatomic) IBOutlet UIImageView *team2ImageView;
@property (weak, nonatomic) IBOutlet UILabel *team2Label;
@property (weak, nonatomic) IBOutlet UILabel *fixtureDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *membersButton;
@property (weak, nonatomic) IBOutlet UILabel *membersDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet NRLabel *unreadCountLabel;
@property (weak, nonatomic) IBOutlet UIView *fixtureContainerView;
- (IBAction)showMembers:(id)sender;

@property (weak, nonatomic) id<ChatListFixtureCellDelegate> delegate;

@end
