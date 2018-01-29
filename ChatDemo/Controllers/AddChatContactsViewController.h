//
//  AddChatContactsViewController.h
//  ChatDemo
//
//  Created by Neo on 5/17/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddChatContactsViewControllerDelegate <NSObject>

- (void)addContacts:(NSArray *)contacts;

@end

@interface AddChatContactsViewController : UITableViewController
@property (weak, nonatomic) id<AddChatContactsViewControllerDelegate> delegate;
@property (strong, nonatomic) NSSet *selectedContacts;
- (IBAction)close:(id)sender;
- (IBAction)add:(id)sender;
@end
