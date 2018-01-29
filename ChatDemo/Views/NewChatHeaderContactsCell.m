//
//  NewChatHeaderCell.m
//  ChatDemo
//
//  Created by Neo on 5/17/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "NewChatHeaderContactsCell.h"

@implementation NewChatHeaderContactsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)tapAdd:(id)sender {
    if ([_delegate respondsToSelector:@selector(willAddNewContact)]) {
        [_delegate willAddNewContact];
    }
}
@end
