//
//  API_BuyerRating.h
//

#import <Foundation/Foundation.h>

@interface API_BuyerRating : NSObject

@property (nonatomic, retain) NSNumber * buyerReviewScore;
@property (nonatomic, assign) BOOL buyerReportedAsTout;
@property (nonatomic, retain) NSString * postedTicketsId;


@end
