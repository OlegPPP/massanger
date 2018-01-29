//
//  API_SearchForTickets.h
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface API_SearchForTickets : NSObject

@property (nonatomic, strong) NSString* fixture; //fixture id
@property (nonatomic, assign) BOOL useCurrentLocation;
@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;
@property (nonatomic, assign) BOOL swap; //true if swap otherwise false for sell

@end
