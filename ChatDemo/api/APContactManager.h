//
//  APChatManager.h
//

#import <Foundation/Foundation.h>
#import "API_PhoneContact.h"

@interface APContactManager : NSObject


//***************************************************************************************************************
// Synch Phone contacts with Server API (i.e. Call to getUpdatedPhoneContacts and map array of API_PhoneContact objects 
// into data store entity CDContact for each entry in the array)
//***************************************************************************************************************
- (void) synchPhoneContacts;


//*********************************************************************************************
// Load new/updated phone contacts from users contacts list (check against CDContact core data)
// ????
//Check to see if we already have this contact loaded!
// I believe the recommended way to keep a long-term reference to a particular record is to store the first and last name, or a hash of the
//first and last name, in addition to the identifier. When you look up a record by ID, compare the record’s name to your stored name.
//If they don’t match, use the stored name to find the record, and store the new ID for the record.
//???
//
// Array of API_PhoneContact.h
//*********************************************************************************************
- (NSArray *) getUpdatedPhoneContacts:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;


@end
