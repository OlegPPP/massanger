//
//  AddChatContactsCell.m
//  ChatDemo
//
//  Created by Neo on 5/17/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "AddChatContactsCell.h"
#import "UIView+Border.h"

@implementation AddChatContactsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _nameContainerView.layer.cornerRadius = CGRectGetWidth(_nameContainerView.bounds) / 2;
    _nameContainerView.layer.masksToBounds = YES;
    
    _borderHeight.constant = 1 / [UIScreen mainScreen].scale;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    _checkmarkImageView.hidden = !selected;
    
    self.contentView.backgroundColor = selected ? [UIColor colorWithWhite:244.f/255 alpha:1] : [UIColor whiteColor];
    
    // UITableViewCell changes the background color of all subviews when cell is selected or highlighted
    _nameContainerView.backgroundColor = [UIColor colorWithWhite:239.f/255 alpha:1];
    
    _borderView.backgroundColor = (selected || _bottomCellSelected) ? [UINavigationBar.appearance barTintColor] : [UIColor lightGrayColor];
}

@end
