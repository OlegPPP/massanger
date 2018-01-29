//
//  CDChat+CoreDataProperties.m
//  
//
//  Created by Neo on 5/19/17.
//
//

#import "CDChat+CoreDataProperties.h"

@implementation CDChat (CoreDataProperties)

+ (NSFetchRequest<CDChat *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDChat"];
}

@dynamic chatId;
@dynamic chatOwner;
@dynamic exitedChat;
@dynamic isChatOwner;
@dynamic subject;
@dynamic chatWithContacts;
@dynamic messages;

@end
