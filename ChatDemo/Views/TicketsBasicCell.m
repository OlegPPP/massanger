//
//  TicketsBasicCell.m
//  ChatDemo
//
//  Created by Neo on 5/31/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "TicketsBasicCell.h"
#import "UIView+Border.h"

@implementation TicketsBasicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIColor *separatorColor = [UITableView new].separatorColor;
    
    [self addTopBorderWithColor:separatorColor andWidth:1 / [UIScreen mainScreen].scale];
    [self addBottomBorderWithColor:separatorColor andWidth:1 / [UIScreen mainScreen].scale];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
