//
//  ContactsAddContactCell.h
//  ChatDemo
//
//  Created by Neo on 6/5/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContactsAddContactCellDelegate <NSObject>

- (void)addFacebook;
- (void)addPhone;
- (void)addInvite;

@end

@interface ContactsAddContactCell : UITableViewCell

- (IBAction)addFacebook:(id)sender;
- (IBAction)addPhone:(id)sender;
- (IBAction)addInvite:(id)sender;

@property (weak, nonatomic) id<ContactsAddContactCellDelegate> delegate;
@end
