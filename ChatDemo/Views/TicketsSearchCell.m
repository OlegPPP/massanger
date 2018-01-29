//
//  TicketsSearchCell.m
//  ChatDemo
//
//  Created by Neo on 5/31/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "TicketsSearchCell.h"
#import "UIView+Border.h"

@implementation TicketsSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIColor *separatorColor = [UITableView new].separatorColor;
    
    [_fixtureContainerView addTopBorderWithColor:separatorColor andWidth:1 / [UIScreen mainScreen].scale];
    [_fixtureContainerView addBottomBorderWithColor:separatorColor andWidth:1 / [UIScreen mainScreen].scale];
    
    [self addTopBorderWithColor:separatorColor andWidth:1 / [UIScreen mainScreen].scale];
    [_descContainerView addBottomBorderWithColor:separatorColor andWidth:1 / [UIScreen mainScreen].scale];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)pressOffer:(id)sender {
    if ([_delegate respondsToSelector:@selector(showOfferInput:)])
        [_delegate showOfferInput:self];
}
@end
