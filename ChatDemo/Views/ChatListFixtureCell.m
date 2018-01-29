//
//  ChatListFixtureCell.m
//  ChatDemo
//
//  Created by Neo on 5/19/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "ChatListFixtureCell.h"

@implementation ChatListFixtureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _fixtureContainerView.layer.cornerRadius = 7;
    _fixtureContainerView.layer.borderColor = [UITableView new].separatorColor.CGColor;
    _fixtureContainerView.layer.borderWidth = 2;
    
    _unreadCountLabel.layer.cornerRadius = 4;
    _unreadCountLabel.clipsToBounds = YES;
    _unreadCountLabel.textInsets = UIEdgeInsetsMake(0, 6, 0, 6);
    
    _border1Height.constant = _border2Height.constant = 1 / [UIScreen mainScreen].scale;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)showMembers:(id)sender {
    if ([_delegate respondsToSelector:@selector(showMembers:)])
        [_delegate showMembers:sender];
}
@end
