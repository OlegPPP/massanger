//
//  AddChatContactsNewCell.m
//  ChatDemo
//
//  Created by Neo on 5/17/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "AddChatContactsNewCell.h"

@implementation AddChatContactsNewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _nameContainerView.layer.cornerRadius = CGRectGetWidth(_nameContainerView.bounds) / 2;
    _nameContainerView.layer.masksToBounds = YES;
    
    _borderHeight.constant = 1 / [UIScreen mainScreen].scale;
    
    _borderView.backgroundColor = [UIColor lightGrayColor];
}

- (IBAction)sendInvite:(id)sender {
}
@end
