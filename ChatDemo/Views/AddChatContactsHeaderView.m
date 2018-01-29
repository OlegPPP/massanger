//
//  AddChatContactsHeaderView.m
//  ChatDemo
//
//  Created by Neo on 5/17/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "AddChatContactsHeaderView.h"
#import "UIView+Border.h"
@implementation AddChatContactsHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addBottomBorderWithColor:[UIColor lightGrayColor] andWidth:1 / [UIScreen mainScreen].scale];
    [_searchContainerView addTopBorderWithColor:[UIColor lightGrayColor] andWidth:1 / [UIScreen mainScreen].scale];
}

@end
