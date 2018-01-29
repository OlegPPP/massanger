//
//  API_Chat.h
//

#import <Foundation/Foundation.h>

@interface API_Chat : NSObject
@property (nonatomic, assign) NSString * chatID;
@property (nonatomic, assign) NSString * subjectTitle;
@property (nonatomic, assign) NSString * subjectType;//Team, Sport, Fixture, Other
@property (nonatomic, assign) NSString * subjectTeamID;//If Chat type is Team
@property (nonatomic, assign) NSString * subjectSportID;//If Chat type is Sport
@property (nonatomic, assign) NSString * subjectFixtureID;//If Chat type is Fixture
@property (nonatomic, retain) NSString * subjectImageAvailable;//If Image has been set (Other Chat!)
@property (nonatomic, assign) NSString * subjectImageID;//UID for uploaded Image
@property (nonatomic, retain) NSDate * subjectImageLastUpdateDate;//Date Image uploaded
@property (nonatomic, retain) NSMutableArray * chatMemberContactId;//List of contacts in chat


@end
