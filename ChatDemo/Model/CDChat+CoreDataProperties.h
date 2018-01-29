//
//  CDChat+CoreDataProperties.h
//  
//
//  Created by Neo on 5/19/17.
//
//

#import "CDChat+CoreDataClass.h"

@class CDChatMessage;

NS_ASSUME_NONNULL_BEGIN

@interface CDChat (CoreDataProperties)

+ (NSFetchRequest<CDChat *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *chatId;
@property (nullable, nonatomic, copy) NSString *chatOwner;
@property (nullable, nonatomic, copy) NSString *exitedChat;
@property (nullable, nonatomic, copy) NSString *isChatOwner;
@property (nullable, nonatomic, retain) NSObject *subject;
@property (nullable, nonatomic, retain) NSSet<CDContact *> *chatWithContacts;
@property (nullable, nonatomic, retain) NSSet<CDChatMessage *> *messages;

@end

@interface CDChat (CoreDataGeneratedAccessors)

- (void)addChatWithContactsObject:(CDContact *)value;
- (void)removeChatWithContactsObject:(CDContact *)value;
- (void)addChatWithContacts:(NSSet<CDContact *> *)values;
- (void)removeChatWithContacts:(NSSet<CDContact *> *)values;

- (void)addMessagesObject:(CDChatMessage *)value;
- (void)removeMessagesObject:(CDChatMessage *)value;
- (void)addMessages:(NSSet<CDChatMessage *> *)values;
- (void)removeMessages:(NSSet<CDChatMessage *> *)values;

@end

NS_ASSUME_NONNULL_END
