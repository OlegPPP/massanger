//
//  CDChatMessage+CoreDataProperties.h
//  
//
//  Created by Neo on 5/19/17.
//
//

#import "CDChatMessage+CoreDataClass.h"

@class CDChat;

NS_ASSUME_NONNULL_BEGIN

@interface CDChatMessage (CoreDataProperties)

+ (NSFetchRequest<CDChatMessage *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSObject *alertMessage;
@property (nullable, nonatomic, copy) NSString *chatMessageId;
@property (nullable, nonatomic, retain) NSObject *message;
@property (nullable, nonatomic, copy) NSString *messageDeliveryStatus;
@property (nullable, nonatomic, copy) NSString *myMessage;
@property (nullable, nonatomic, retain) NSObject *postedBy;
@property (nullable, nonatomic, copy) NSDate *postedDateTime;
@property (nullable, nonatomic, retain) CDChat *chat;

@end

NS_ASSUME_NONNULL_END
