//
//  NewChatViewController.h
//  ChatDemo
//
//  Created by Neo on 5/17/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDChat+CoreDataClass.h"

@protocol NewChatViewControllerDelegate <NSObject>

- (void)shouldRefreshChat;

@end

@interface NewChatViewController : UITableViewController

@property (nonatomic, assign) BOOL isEditChat;
@property (nonatomic, assign) BOOL isChatOwner;
@property (nonatomic, strong) CDChat *chat;
@property (nonatomic, weak) id<NewChatViewControllerDelegate> delegate;

- (IBAction)createNewChat:(id)sender;


@end
