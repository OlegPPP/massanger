//
//  API_SellTickets.h
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface API_SellTickets : NSObject

@property (nonatomic, retain) NSDictionary * fixture;
@property (nonatomic, retain) NSString * sellerLocationText;
@property (nonatomic, assign) CLLocationDegrees longitude;
@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, retain) NSString * ticketDetail;
@property (nonatomic, assign) int numberOfTickets;
@property (nonatomic, retain) NSString * postType;
@property (nonatomic, retain) NSString * together;


@end
