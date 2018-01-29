//
//  API_SellerRating.h
//

#import <Foundation/Foundation.h>

@interface API_SellerRating : NSObject


@property (nonatomic, retain) NSNumber * sellerReviewScore;
@property (nonatomic, assign) BOOL sellerReportedAsTout;
@property (nonatomic, retain) NSString * postedTicketsId;

@end
