//
//  TicketsSearchCurrentLocationCell.m
//  ChatDemo
//
//  Created by Neo on 5/31/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "TicketsCurrentLocationCell.h"
#import "UIView+Border.h"

@implementation TicketsCurrentLocationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIColor *separatorColor = [UITableView new].separatorColor;
    
    [self addTopBorderWithColor:separatorColor andWidth:1 / [UIScreen mainScreen].scale];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didSwitchLocation:(id)sender {
    if ([_delegate respondsToSelector:@selector(didSwitchLocation:)]) {
        [_delegate didSwitchLocation:_currentLocationSwitch.on];
    }
}
@end
