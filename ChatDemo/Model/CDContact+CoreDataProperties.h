//
//  CDContact+CoreDataProperties.h
//  
//
//  Created by Neo on 5/19/17.
//
//

#import "CDContact+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDContact (CoreDataProperties)

+ (NSFetchRequest<CDContact *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *appContactId;
@property (nullable, nonatomic, copy) NSString *contactUserId;
@property (nullable, nonatomic, copy) NSString *firstName;
@property (nullable, nonatomic, copy) NSString *lastName;
@property (nullable, nonatomic, retain) NSSet<CDChat *> *chats;

@end

@interface CDContact (CoreDataGeneratedAccessors)

- (void)addChatsObject:(CDChat *)value;
- (void)removeChatsObject:(CDChat *)value;
- (void)addChats:(NSSet<CDChat *> *)values;
- (void)removeChats:(NSSet<CDChat *> *)values;

@end

NS_ASSUME_NONNULL_END
