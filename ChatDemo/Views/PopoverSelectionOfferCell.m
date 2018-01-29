//
//  PopoverSelectionOfferCell.m
//  ChatDemo
//
//  Created by Neo on 6/1/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "PopoverSelectionOfferCell.h"

@implementation PopoverSelectionOfferCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _bubbleImageView.image = [[UIImage imageNamed:@"tickets_offers_chat_bubble"] resizableImageWithCapInsets:UIEdgeInsetsMake(29, 21, 13, 13)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)decline:(id)sender {
    if ([_delegate respondsToSelector:@selector(declineOffer:)]) {
        [_delegate declineOffer:self];
    }
}

- (IBAction)deal:(id)sender {
    if ([_delegate respondsToSelector:@selector(declineOffer:)]) {
        [_delegate dealOffer:self];
    }
}

- (IBAction)chat:(id)sender {
    if ([_delegate respondsToSelector:@selector(declineOffer:)]) {
        [_delegate openChat:self];
    }
}
@end
