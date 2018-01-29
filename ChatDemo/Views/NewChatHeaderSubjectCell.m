//
//  NewChatHeaderCell.m
//  ChatDemo
//
//  Created by Neo on 5/17/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "NewChatHeaderSubjectCell.h"

@implementation NewChatHeaderSubjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)tapMore:(id)sender {
    if ([_delegate respondsToSelector:@selector(willShowMore:)]) {
        [_delegate willShowMore:sender];
    }
}
@end
