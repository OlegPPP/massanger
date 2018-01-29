//
//  TicketsPostInputCell.m
//  ChatDemo
//
//  Created by Neo on 5/31/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "TicketsPostInputCell.h"
#import <UITextView+Placeholder.h>
#import "UIView+Border.h"

@implementation TicketsPostInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIColor *separatorColor = [UITableView new].separatorColor;
    
    [self addTopBorderWithColor:separatorColor andWidth:1 / [UIScreen mainScreen].scale];
    
    _borderHeight.constant = 1 / [UIScreen mainScreen].scale;
    _borderView.backgroundColor = separatorColor;
    
    _textView.textContainerInset = UIEdgeInsetsMake(8, 12, 8, 12);
    _textView.placeholder = @"Enter Description";
    _textView.scrollEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
