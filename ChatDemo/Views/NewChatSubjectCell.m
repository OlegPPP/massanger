//
//  NewChatSubjectCell.m
//  ChatDemo
//
//  Created by Neo on 5/17/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "NewChatSubjectCell.h"

@implementation NewChatSubjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickSubjectButton:(id)sender {
    if ([_delegate respondsToSelector:@selector(didSelectSubject:sender:)]) {
        // Return superview, not button, this is for popover
        [_delegate didSelectSubject:[sender tag] sender:[sender superview]];
    }
}

- (void)selectSubject:(NSInteger)index {
    for (UIButton *button in _subjectButtons) {
        [button setSelected:(button.tag == index)];
    }
}

@end
