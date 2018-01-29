//
//  NewChatHeaderCell.h
//  ChatDemo
//
//  Created by Neo on 5/17/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewChatHeaderContactsCellDelegate <NSObject>

- (void)willAddNewContact;

@end

@interface NewChatHeaderContactsCell : UITableViewCell

@property (weak, nonatomic) id<NewChatHeaderContactsCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *addButton;
- (IBAction)tapAdd:(id)sender;

@end
