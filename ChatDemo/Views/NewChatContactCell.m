//
//  NewChatContactCell.m
//  ChatDemo
//
//  Created by Neo on 5/17/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "NewChatContactCell.h"

@implementation NewChatContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _dummyImageView.layer.cornerRadius = CGRectGetWidth(_dummyImageView.bounds) / 2;
    _profileImageView.layer.cornerRadius = CGRectGetWidth(_profileImageView.bounds) / 2;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)tapRemove:(id)sender {
    if ([_delegate respondsToSelector:@selector(didRemoveContact:)]) {
        [_delegate didRemoveContact:self];
    }
}

- (void)setProfileName:(NSString *)name {
    _contactName.text = name;
    _firstLetterLabel.text = [[name substringToIndex:1] uppercaseString];
}

@end
