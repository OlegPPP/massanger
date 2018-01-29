//
//  ProfileSetupLocationCell.m
//  ChatDemo
//
//  Created by Neo on 5/20/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "ProfileSetupLocationCell.h"

@implementation ProfileSetupLocationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)tapAddressButton:(id)sender {
    if ([_delegate respondsToSelector:@selector(tapAddressButton)])
        [_delegate tapAddressButton];
}
@end
