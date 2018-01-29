//
//  ContactsConnectedCell.m
//  ChatDemo
//
//  Created by Neo on 6/5/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "ContactsConnectedCell.h"

@implementation ContactsConnectedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _onlineIndicator.layer.cornerRadius = 4;
    _onlineContainerView.layer.cornerRadius = 6;
    _mainImageView.layer.cornerRadius = 17;
    _mainImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
