//
//  API_UserProfile.h
//  AnPeilRugby
//
//  Created by Stephen N on 19/08/2016.
//  Copyright © 2016 AnPeil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface API_UserProfile : NSObject


@property (nonatomic, assign) NSString * firstName;
@property (nonatomic, assign) NSString * lastName;
@property (nonatomic, assign) NSString * profileImageId;
@property (nonatomic, assign) NSString * profileImageAvailable;
@property (nonatomic, assign) NSString * profileImageLastUpdateDate;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, assign) NSString * location;
@property (nonatomic, assign) NSString * profileStatus;
@property (nonatomic, retain) NSDate * dateOfBirth;
@property (nonatomic, retain) NSMutableArray * clubs;
@property (nonatomic, retain) NSMutableArray * sports;

@property (nonatomic, retain) NSDate * updated_at;

@end
