//
//  CDTicketsOffer+CoreDataProperties.m
//  
//
//  Created by Neo on 6/6/17.
//
//

#import "CDTicketsOffer+CoreDataProperties.h"

@implementation CDTicketsOffer (CoreDataProperties)

+ (NSFetchRequest<CDTicketsOffer *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDTicketsOffer"];
}

@dynamic buyer;
@dynamic buyerLocation;
@dynamic buyerLocationText;
@dynamic buyerName;
@dynamic buyerRating;
@dynamic buyerReportedAsTout;
@dynamic buyerReviewScore;
@dynamic offerAcceptedDateTime;
@dynamic offerDateTime;
@dynamic offerId;
@dynamic offerStatus;
@dynamic offerTimeOutMinutes;
@dynamic chosenTicket;
@dynamic ticket;

@end
