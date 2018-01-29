//
//  NewChatSubjectFixtureCell.m
//  ChatDemo
//
//  Created by Neo on 5/17/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "NewChatSubjectFixtureCell.h"
#import <UITextView+Placeholder.h>

@implementation NewChatSubjectFixtureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _containerView.layer.cornerRadius = 7;
    _containerView.backgroundColor = [UIColor whiteColor];
    _containerView.layer.borderColor = [UITableView new].separatorColor.CGColor;
    _containerView.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
    
    _fixtureContainerView.layer.cornerRadius = 7;
    _fixtureContainerView.layer.borderColor = [UITableView new].separatorColor.CGColor;
    _fixtureContainerView.layer.borderWidth = 2;
    
    _descTextView.scrollEnabled = NO;
    _descTextView.placeholder = @"Enter subject text here";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
