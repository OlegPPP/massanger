//
//  APTicketManager.m
//

#import "APTicketManager.h"
#import "AppDelegate.h"
#import "API_SellTickets.h"
#import "CDPostedTicket+CoreDataClass.h"
#import <FCUUID.h>

@implementation APTicketManager

+ (instancetype)sharedManager {
    static APTicketManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (void)sellTickets:(API_SellTickets *)ticketsToSell success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure {
    NSManagedObjectContext *managedContext = [(AppDelegate *)[UIApplication sharedApplication].delegate persistentContainer].viewContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDPostedTicket" inManagedObjectContext:managedContext];
    
    CDPostedTicket *ticket = [[CDPostedTicket alloc] initWithEntity:entity insertIntoManagedObjectContext:managedContext];
    
    ticket.postedTicketsId = [FCUUID uuid];
    ticket.fixtureInfo = ticketsToSell.fixture;
    ticket.myPost = YES;
    ticket.numberOfTickets = ticketsToSell.numberOfTickets;
    ticket.postedDate = [NSDate date];
    ticket.postStatus = @"OPEN";
    ticket.postType = ticketsToSell.postType;
    ticket.ticketDetail = ticketsToSell.ticketDetail;
    ticket.sellerLocation = @{@"latitude": @(ticketsToSell.latitude), @"longitude": @(ticketsToSell.longitude)};
    ticket.sellerLocationText = ticketsToSell.sellerLocationText;
    ticket.postedTicketClosedOut = NO;
    
    NSError *error;
    [managedContext save:&error];
    if (!error) {
        success(@"success");
        return;
    }
    failure(error.localizedDescription);
}

- (void)searchForTicketsToBuy:(API_SearchForTickets *)ticketsSearch success:(void (^)(NSArray<API_TicketSearchResults *> *))success failure:(void (^)(NSString *))failure {
    API_TicketSearchResults *sample1 = [API_TicketSearchResults new];
    sample1.postedTicketsId = @"1";
    sample1.postedDate = [NSDate distantPast];
    sample1.postStatus = @"OPEN";
    sample1.postType = ticketsSearch.swap ? @"SWAP" : @"SELL";
    sample1.numberOfTickets = @2;
    sample1.ticketDetail = @"I have 2 tickets";
    sample1.sellerLocationText = @"Vladivostok, Russia";
    sample1.sellerLocation = @{@"latitude": @43.173706, @"longitude": @132.0358371};
    // - totalBought
    // - totalSold
    // - totalBoughtAndSold
    // - averageUserRating
    sample1.sellerRating = @{@"totalBought": @3, @"totalSold": @3, @"totlaBoughtAndSold": @6, @"averageUserRating": @4};
    sample1.fixtureInfo = @{@"id": @"1",
                            @"competitionName": @"GAA Football All Ireland",
                            @"venueName": @"Landsdown Load",
                            @"awayTeamImage": @"dublin",
                            @"awayTeamName": @"Dublin",
                            @"homeTeamImage": @"galway",
                            @"homeTeamName": @"Galway",
                            @"fixtureDate": @"Jan 15 at 6:20 pm"};
    
    API_TicketSearchResults *sample2 = [API_TicketSearchResults new];
    sample2.postedTicketsId = @"2";
    sample2.postedDate = [NSDate distantPast];
    sample2.postStatus = @"OPEN";
    sample2.postType = ticketsSearch.swap ? @"SWAP" : @"SELL";
    sample2.numberOfTickets = @3;
    sample2.ticketDetail = @"I have 3 tickets";
    sample2.sellerLocationText = @"Vladivostok, Russia";
    sample2.sellerLocation = @{@"latitude": @43.173706, @"longitude": @132.0358371};
    sample2.sellerRating = @{@"totalBought": @3, @"totalSold": @3, @"totlaBoughtAndSold": @6, @"averageUserRating": @3};
    sample2.fixtureInfo = @{@"id": @"2",
                            @"competitionName": @"Football Russia",
                            @"venueName": @"Davidova",
                            @"awayTeamImage": @"dublin",
                            @"awayTeamName": @"AAAA",
                            @"homeTeamImage": @"galway",
                            @"homeTeamName": @"BBBB",
                            @"fixtureDate": @"Jan 15 at 6:20 pm"};
    
    success(@[sample1, sample2]);
}

- (void)offerToBuyTickets:(NSString *)postedTicketsId success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure {
    
}

- (void)cancelTicketsForSale:(NSString *)postedTicketsId success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure {
    NSManagedObjectContext *managedContext = [(AppDelegate *)[UIApplication sharedApplication].delegate persistentContainer].viewContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDPostedTicket" inManagedObjectContext:managedContext];
    
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"postedTicketsId == %@", postedTicketsId]];
    
    NSError *error = nil;
    NSArray *results = [managedContext executeFetchRequest:request error:&error];
    assert(error == nil);
    assert(results.count > 0);
    
    CDPostedTicket *ticket = results[0];
    ticket.postStatus = @"CANCELLED";
    ticket.postedTicketClosedOut = YES;
    
    [managedContext save:&error];
    if (!error) {
        success(@"success");
        return;
    }
    
    failure(error.localizedDescription);
}

- (void)buyerRating:(API_BuyerRating *)buyerRating success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure {
    NSManagedObjectContext *managedContext = [(AppDelegate *)[UIApplication sharedApplication].delegate persistentContainer].viewContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDPostedTicket" inManagedObjectContext:managedContext];
    
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"postedTicketsId == %@", buyerRating.postedTicketsId]];
    
    NSError *error = nil;
    NSArray *results = [managedContext executeFetchRequest:request error:&error];
    assert(error == nil);
    assert(results.count > 0);
    
    CDPostedTicket *ticket = results[0];
    ticket.sellerReviewScore = [buyerRating.buyerReviewScore intValue];
    ticket.postedTicketClosedOut = YES;
    
    [managedContext save:&error];
    if (!error) {
        success(@"success");
        return;
    }
    
    failure(error.localizedDescription);
}

- (void)sellerRating:(API_SellerRating *)sellerRating success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure {
    NSManagedObjectContext *managedContext = [(AppDelegate *)[UIApplication sharedApplication].delegate persistentContainer].viewContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDPostedTicket" inManagedObjectContext:managedContext];
    
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"postedTicketsId == %@", sellerRating.postedTicketsId]];
    
    NSError *error = nil;
    NSArray *results = [managedContext executeFetchRequest:request error:&error];
    assert(error == nil);
    assert(results.count > 0);
    
    CDPostedTicket *ticket = results[0];
    ticket.sellerReviewScore = [sellerRating.sellerReviewScore intValue];
    ticket.postedTicketClosedOut = YES;
    
    [managedContext save:&error];
    if (!error) {
        success(@"success");
        return;
    }
    
    failure(error.localizedDescription);
}

- (void)buyerTicketOfferDeclined:(NSString *)postedTicketsId success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure {
    NSManagedObjectContext *managedContext = [(AppDelegate *)[UIApplication sharedApplication].delegate persistentContainer].viewContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDPostedTicket" inManagedObjectContext:managedContext];
    
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"postedTicketsId == %@", postedTicketsId]];
    
    NSError *error = nil;
    NSArray *results = [managedContext executeFetchRequest:request error:&error];
    assert(error == nil);
    assert(results.count > 0);
    
    CDPostedTicket *ticket = results[0];
    // Set offerStatus to "DECLINED"
    
    [managedContext save:&error];
    if (!error) {
        success(@"success");
        return;
    }
    
    failure(error.localizedDescription);
}

- (void)sellerTicketOfferAccepted:(API_TicketsOfferAccepted *)acceptedOfferDetails success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure {
    NSManagedObjectContext *managedContext = [(AppDelegate *)[UIApplication sharedApplication].delegate persistentContainer].viewContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDPostedTicket" inManagedObjectContext:managedContext];
    
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"postedTicketsId == %@", acceptedOfferDetails.postedTicketsId]];
    
    NSError *error = nil;
    NSArray *results = [managedContext executeFetchRequest:request error:&error];
    assert(error == nil);
    assert(results.count > 0);
    
    CDPostedTicket *ticket = results[0];
    ticket.postStatus = @"OFFERED";
//    Set chosen buyer offer
//    ticket.chosenBuyerOffer
    // Set offerStatus to "OFFERED"
    // Set offerTimeOutMinutes to time selected
    // Set offerAcceptedDateTime to current time
    
    [managedContext save:&error];
    if (!error) {
        success(@"success");
        return;
    }
    
    failure(error.localizedDescription);
}

@end
