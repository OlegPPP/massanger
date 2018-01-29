//
//  API_PhoneContact.h
//

#import <Foundation/Foundation.h>

@interface API_PhoneContact : NSObject

@property (assign, nonatomic) NSNumber * phoneContactId;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSMutableArray *phoneNumbers;
@property (strong, nonatomic) NSMutableArray *emailAddresses;
@property (strong, nonatomic) NSString *contactImageName;

@end
