//
//  CDContact+CoreDataProperties.m
//  
//
//  Created by Neo on 5/19/17.
//
//

#import "CDContact+CoreDataProperties.h"

@implementation CDContact (CoreDataProperties)

+ (NSFetchRequest<CDContact *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDContact"];
}

@dynamic appContactId;
@dynamic contactUserId;
@dynamic firstName;
@dynamic lastName;
@dynamic chats;

@end
