//
//  NewChatSubjectTeamSportCell.m
//  ChatDemo
//
//  Created by Neo on 5/17/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "NewChatSubjectTeamSportCell.h"
#import <UITextView+Placeholder.h>

@implementation NewChatSubjectTeamSportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _containerView.layer.cornerRadius = 7;
    _containerView.backgroundColor = [UIColor whiteColor];
    _containerView.layer.borderColor = [UITableView new].separatorColor.CGColor;
    _containerView.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
    
    _descTextView.scrollEnabled = NO;
    _descTextView.placeholder = @"Enter subject text here";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
