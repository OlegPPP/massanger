//
//  CDPostedTicket+CoreDataProperties.m
//  
//
//  Created by Neo on 5/30/17.
//
//

#import "CDPostedTicket+CoreDataProperties.h"

@implementation CDPostedTicket (CoreDataProperties)

+ (NSFetchRequest<CDPostedTicket *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDPostedTicket"];
}

@dynamic postedTicketsId;
@dynamic fixtureInfo;
@dynamic postedDate;
@dynamic postStatus;
@dynamic postType;
@dynamic ticketDetail;
@dynamic sellerLocation;
@dynamic myPost;
@dynamic numberOfTickets;
@dynamic sellerLocationText;
@dynamic postedTicketClosedOut;
@dynamic sellerReviewScore;
@dynamic sellerRating;
@dynamic offers;
@dynamic chosenBuyerOffer;

@end
