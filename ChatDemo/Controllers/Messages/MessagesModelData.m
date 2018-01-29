//
//  MessagesModelData.m
//  ChatDemo
//
//  Created by Neo on 5/18/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "MessagesModelData.h"
#import "AppDelegate.h"
#import "CDChatMessage+CoreDataClass.h"
#import "CDContact+CoreDataClass.h"
#import "APChatManager.h"
#import "CDChatMessage+CoreDataClass.h"
#import <FCUUID.h>
#import "MyPhotoMediaItem.h"

@implementation MessagesModelData
{
    NSFetchRequest *request;
    APChatManager *chatManager;
}

#define MESSAGES_PER_PAGE 10

- (instancetype)initWithChat:(CDChat *)chat
{
    self = [super init];
    if (self) {
        _chat = chat;
        
        /**
         *  Create message bubble images objects.
         *
         *  Be sure to create your bubble images one time and reuse them for good performance.
         *
         */
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] initWithBubbleImage:[UIImage imageNamed:@"chat_bubble"] capInsets:UIEdgeInsetsMake(19, 14, 12, 20) layoutDirection:[UIApplication sharedApplication].userInterfaceLayoutDirection];
        
        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor colorWithWhite:0 alpha:0.2]];
        self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor colorWithWhite:0 alpha:0.2]];
        
        
        
        _managedContext = [(AppDelegate *)[UIApplication sharedApplication].delegate persistentContainer].viewContext;
        
        request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"CDChatMessage"
                                       inManagedObjectContext:_managedContext]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"chat == %@ AND messageDeliveryStatus != 'DELETED'", _chat]];
        [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"postedDateTime" ascending:NO]]];

        request.fetchLimit = MESSAGES_PER_PAGE;
        
        // Init
        _messages = [NSMutableArray new];
        
        [self loadMoreMessages];
        
        /**
         *  Create avatar images once.
         *
         *  Be sure to create your avatars one time and reuse them for good performance.
         *
         *  If you are not using avatars, ignore this.
         */
        JSQMessagesAvatarImageFactory *avatarFactory = [[JSQMessagesAvatarImageFactory alloc] initWithDiameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        // TODO: Set to real avatar
        chatManager = [APChatManager sharedManager];
        NSMutableDictionary *chatAvatars = [NSMutableDictionary dictionaryWithObject:[avatarFactory avatarImageWithUserInitials:[[chatManager.firstName substringToIndex:1] uppercaseString]
                                                                                                                backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f]
                                                                                                                      textColor:[UIColor colorWithWhite:0.60f alpha:1.0f]
                                                                                                                           font:[UIFont systemFontOfSize:14.0f]] forKey:chatManager.currentUserId];
        NSMutableDictionary *chatUsers = [NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ %@", chatManager.firstName, chatManager.lastName] forKey:chatManager.currentUserId];
        for (CDContact *contact in _chat.chatWithContacts) {
            JSQMessagesAvatarImage *jsqImage = [avatarFactory avatarImageWithUserInitials:[[contact.firstName substringToIndex:1] uppercaseString]
                                                                          backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f]
                                                                                textColor:[UIColor colorWithWhite:0.60f alpha:1.0f]
                                                                                     font:[UIFont systemFontOfSize:14.0f]];
            chatAvatars[contact.appContactId] = jsqImage;
            chatUsers[contact.appContactId] = [NSString stringWithFormat:@"%@ %@", contact.firstName, contact.lastName];
        }
        self.avatars = [chatAvatars copy];
        self.users = [chatUsers copy];
    }
    
    return self;
}

- (void)addMessage:(JSQMessage *)message {
    [_messages addObject:message];
    
    CDChatMessage *messageModel = [NSEntityDescription insertNewObjectForEntityForName:@"CDChatMessage"
                                                           inManagedObjectContext:_managedContext];
    messageModel.chat = _chat;
    messageModel.chatMessageId = [FCUUID uuid];
    messageModel.messageDeliveryStatus = @"READ";

    messageModel.myMessage = [message.senderId isEqualToString:chatManager.currentUserId] ? @"true" : @"false";
    
    if ([messageModel.myMessage isEqualToString:@"true"]) {
        messageModel.postedBy = @{@"contactId": message.senderId, @"contactFirstName": chatManager.firstName, @"contactLastName": chatManager.lastName};
    } else {
        // search from contacts
        for (CDContact *contact in _chat.chatWithContacts) {
            if ([contact.appContactId isEqualToString:message.senderId]) {
                messageModel.postedBy = @{@"contactId": message.senderId, @"contactFirstName": contact.firstName, @"contactLastName": contact.lastName};
            }
        }
    }
    
    if (!message.isMediaMessage) {
        messageModel.message = @{@"messageText": message.text};
    } else {
        // Save image to docs directory
        NSString *photoId = [FCUUID uuid];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", photoId];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
        NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName]; //Add the file name
        [UIImageJPEGRepresentation(((MyPhotoMediaItem *)message.media).image, 0.5) writeToFile:filePath atomically:YES];
        
        messageModel.message = @{@"messageImageId": photoId};
    }
    messageModel.postedDateTime = message.date;
    
    NSError *error;
    [_managedContext save:&error];
    assert(error == nil);
}

- (void)loadMoreMessages {
    NSError *error;
    request.fetchOffset = [_messages count];
    NSArray* messages = [_managedContext executeFetchRequest:request error:&error];
    assert(error == nil);
    
    for (CDChatMessage *message in messages) {
        NSDictionary *messageDic = (NSDictionary *)message.message;
        NSDictionary *postedByDic = (NSDictionary *)message.postedBy;
        
        if (messageDic[@"messageImageId"]) {
            // Load image to docs directory
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", messageDic[@"messageImageId"]];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
            NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName]; //Add the file name
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:filePath];
            
            MyPhotoMediaItem *item = [[MyPhotoMediaItem alloc] initWithImage:image withBubbleImage:[postedByDic[@"contactId"] isEqualToString:[[APChatManager sharedManager] currentUserId]] ? self.outgoingBubbleImageData.messageBubbleImage : self.incomingBubbleImageData.messageBubbleImage];
            item.appliesMediaViewMaskAsOutgoing = [postedByDic[@"contactId"] isEqualToString:[[APChatManager sharedManager] currentUserId]];
            [_messages insertObject:[[JSQMessage alloc] initWithSenderId:postedByDic[@"contactId"]
                                                       senderDisplayName:[NSString stringWithFormat:@"%@ %@", postedByDic[@"contactFirstName"], postedByDic[@"contactLastName"]]
                                                                    date:message.postedDateTime
                                                                    media:item] atIndex:0];
        } else {
            [_messages insertObject:[[JSQMessage alloc] initWithSenderId:postedByDic[@"contactId"]
                                                       senderDisplayName:[NSString stringWithFormat:@"%@ %@", postedByDic[@"contactFirstName"], postedByDic[@"contactLastName"]]
                                                                    date:message.postedDateTime
                                                                    text:messageDic[@"messageText"]] atIndex:0];
        }
    }
}

- (void)forceRefresh {
    _messages = [NSMutableArray new];
    [self loadMoreMessages];
}

@end
