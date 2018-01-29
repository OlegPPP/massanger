//
//  NewChatHeaderCell.h
//  ChatDemo
//
//  Created by Neo on 5/17/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewChatHeaderSubjectCellDelegate <NSObject>

- (void)willShowMore:(id)sender;

@end

@interface NewChatHeaderSubjectCell : UITableViewCell

@property (weak, nonatomic) id<NewChatHeaderSubjectCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *moreButton;
- (IBAction)tapMore:(id)sender;

@end
