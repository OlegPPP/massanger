//
//  TicketsSearchTypeCell.m
//  ChatDemo
//
//  Created by Neo on 5/31/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "TicketsTypeCell.h"
#import "UIView+Border.h"

@implementation TicketsTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIColor *separatorColor = [UITableView new].separatorColor;
    
    [self addBottomBorderWithColor:separatorColor andWidth:1 / [UIScreen mainScreen].scale];
    
    UIFont *font = [UIFont systemFontOfSize:18.0f];
    [_segmentedControl setTitleTextAttributes:@{NSFontAttributeName: font}
                                    forState:UIControlStateNormal];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didChangeSegment:(id)sender {
    if ([_delegate respondsToSelector:@selector(didChangeTicketsType:)]) {
        [_delegate didChangeTicketsType:_segmentedControl.selectedSegmentIndex];
    }
}
@end
