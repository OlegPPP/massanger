

#import <Foundation/Foundation.h>

#import "API_SellTickets.h"
#import "API_SearchForTickets.h"
#import "API_TicketsOfferAccepted.h"
#import "API_BuyerRating.h"
#import "API_SellerRating.h"
#import "API_TicketSearchResults.h"


@interface APTicketManager: NSObject



//*************************************************************************
// Server API
//*************************************************************************
- (void) sellTickets:(API_SellTickets*)ticketsToSell success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;
- (void) cancelTicketsForSale:(NSString*)postedTicketsId success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;
- (void) searchForTicketsToBuy:(API_SearchForTickets *) ticketsSearch success:(void (^)(NSArray<API_TicketSearchResults *> *))success failure:(void (^)(NSString *))failure;
- (void) offerToBuyTickets:(NSString*)postedTicketsId success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;
- (void) sellerTicketOfferAccepted:(API_TicketsOfferAccepted*)acceptedOfferDetails success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;
- (void) buyerTicketOfferAccepted:(NSString*)postedTicketsId success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;
- (void) buyerTicketOfferDeclined:(NSString*)postedTicketsId success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;
- (void) buyerRating:(API_BuyerRating*)buyerRating success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;
- (void) sellerRating:(API_SellerRating*)sellerRating success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;
+ (instancetype)sharedManager;

@end
