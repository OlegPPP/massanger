//
//  API_TicketSearchResults.h
//

#import <Foundation/Foundation.h>

@interface API_TicketSearchResults : NSObject

//internal id to identify posted tickets
@property (nonatomic, retain) NSString * postedTicketsId;

//Tickets Post Date
@property (nonatomic, retain) NSDate * postedDate; 

//Post Status: OPEN/CANCELLED/SOLD
@property (nonatomic, retain) NSString * postStatus;

//Ticket Post Type: Either: SELL/SWAP
@property (nonatomic, retain) NSString * postType;

//Number of tickets for sale or swap
@property (nonatomic, retain) NSNumber * numberOfTickets;

// Text outlining details of tickets i.e how many tickets etc.
@property (nonatomic, retain) NSString * ticketDetail;

//Location text name (i.e. returned from Google API)
@property (nonatomic, retain) NSString * sellerLocationText;

//GPS coordinates - NSDictionary made up of the following:
// - longitude
// - latitude
@property (nonatomic, retain) NSDictionary *sellerLocation;

//Sellers Rating - NSDictionary made up of the following:
// - totalBought
// - totalSold
// - totalBoughtAndSold
// - averageUserRating
@property (nonatomic, retain) NSDictionary *sellerRating;

//Fixture details: NSDictionary made up of the following:
// - fixtureId
// - venueName
// - awayTeamName
// - homeTeamName
// - fixtureDate
// - competitionName
@property (nonatomic, retain) NSDictionary *fixtureInfo;


@end
