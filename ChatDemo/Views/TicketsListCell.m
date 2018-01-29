//
//  TicketsListCell.m
//  ChatDemo
//
//  Created by Neo on 6/1/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "TicketsListCell.h"
#import "UIView+Border.h"

@implementation TicketsListCell

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

- (IBAction)pressOffers:(id)sender {
    if ([_delegate respondsToSelector:@selector(pressOffers:)])
        [_delegate pressOffers:self];
}

- (IBAction)giveFeedback:(id)sender {
    if ([_delegate respondsToSelector:@selector(giveFeedback:)])
        [_delegate giveFeedback:self];
}

- (IBAction)pressDeals:(id)sender {
    if ([_delegate respondsToSelector:@selector(pressDeals:)])
        [_delegate pressDeals:self];
}

- (IBAction)pressDecline:(id)sender {
    if ([_delegate respondsToSelector:@selector(pressDecline:)])
        [_delegate pressDecline:self];
}

- (IBAction)pressOnlyCancel:(id)sender {
    if ([_delegate respondsToSelector:@selector(pressCancel:)])
        [_delegate pressCancel:self];
}

- (IBAction)share:(id)sender {
    if ([_delegate respondsToSelector:@selector(pressShare:)])
        [_delegate pressShare:self];
}

- (IBAction)chat:(id)sender {
    if ([_delegate respondsToSelector:@selector(pressChat:)])
        [_delegate pressChat:self];
}

@end
