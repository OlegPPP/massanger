//
//  TicketsSearchNumberCell.m
//  ChatDemo
//
//  Created by Neo on 5/31/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "TicketsNumberCell.h"
#import "UIView+Border.h"

@implementation TicketsNumberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIColor *separatorColor = [UITableView new].separatorColor;
    
    [self addTopBorderWithColor:separatorColor andWidth:1 / [UIScreen mainScreen].scale];
    [self addBottomBorderWithColor:separatorColor andWidth:1 / [UIScreen mainScreen].scale];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)pressMinus:(id)sender {
    if ([_delegate respondsToSelector:@selector(pressMinus:)] ) {
        [_delegate pressMinus:sender];
    }
}

- (IBAction)pressPlus:(id)sender {
    if ([_delegate respondsToSelector:@selector(pressPlus:)] ) {
        [_delegate pressPlus:sender];
    }
}
@end
