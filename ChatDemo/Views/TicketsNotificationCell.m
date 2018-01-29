//
//  TicketsNotificationCell.m
//  ChatDemo
//
//  Created by Neo on 6/1/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "TicketsNotificationCell.h"

@implementation TicketsNotificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _badgeLabel.layer.cornerRadius = 10;
    _badgeLabel.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
