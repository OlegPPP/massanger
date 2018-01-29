//
//  PopOverSelectionSellerCell.m
//  ChatDemo
//
//  Created by Neo on 6/1/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "PopoverSelectionSellerCell.h"

@implementation PopoverSelectionSellerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _onlineIndicator.layer.cornerRadius = 4;
    _mainImageView.layer.cornerRadius = 17;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
