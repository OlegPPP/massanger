//
//  CDChatMessage+CoreDataProperties.m
//  
//
//  Created by Neo on 5/19/17.
//
//

#import "CDChatMessage+CoreDataProperties.h"

@implementation CDChatMessage (CoreDataProperties)

+ (NSFetchRequest<CDChatMessage *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDChatMessage"];
}

@dynamic alertMessage;
@dynamic chatMessageId;
@dynamic message;
@dynamic messageDeliveryStatus;
@dynamic myMessage;
@dynamic postedBy;
@dynamic postedDateTime;
@dynamic chat;

@end
