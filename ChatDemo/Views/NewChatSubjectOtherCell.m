//
//  NewChatSubjectOtherCell.m
//  ChatDemo
//
//  Created by Neo on 5/17/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "NewChatSubjectOtherCell.h"
#import <UITextView+Placeholder.h>

@implementation NewChatSubjectOtherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _containerView.layer.cornerRadius = 7;
    _containerView.backgroundColor = [UIColor whiteColor];
    _containerView.layer.borderColor = [UITableView new].separatorColor.CGColor;
    _containerView.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
    
    _descTextView.scrollEnabled = NO;
    _descTextView.placeholder = @"Enter subject text here";
    
    _imageButton.layer.cornerRadius = CGRectGetWidth(_imageButton.frame) / 2;
    _imageButton.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)cameraTapped:(id)sender {
    if ([_delegate respondsToSelector:@selector(willPresentCamera)]) {
        [_delegate willPresentCamera];
    }
}
@end
