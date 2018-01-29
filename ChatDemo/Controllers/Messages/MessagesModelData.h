//
//  MessagesModelData.h
//  ChatDemo
//
//  Created by Neo on 5/18/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSQMessages.h>
#import "CDChat+CoreDataClass.h"

@interface MessagesModelData : NSObject

@property (strong, nonatomic) NSMutableArray *messages;

@property (strong, nonatomic) NSDictionary *avatars;

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;

@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

@property (strong, nonatomic) NSDictionary *users;

@property (strong, nonatomic) NSManagedObjectContext *managedContext;

@property (strong, nonatomic) CDChat *chat;

- (instancetype)initWithChat:(CDChat *)chat;

- (void)addMessage:(JSQMessage *)message;
- (void)loadMoreMessages;
- (void)forceRefresh;   // currently call this when delete the chat

@end
