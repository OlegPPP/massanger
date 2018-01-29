//
//  CDPostedTicket+CoreDataProperties.h
//  
//
//  Created by Neo on 5/30/17.
//
//

#import "CDPostedTicket+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDPostedTicket (CoreDataProperties)

+ (NSFetchRequest<CDPostedTicket *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *postedTicketsId;
@property (nullable, nonatomic, retain) NSObject *fixtureInfo;
@property (nullable, nonatomic, copy) NSDate *postedDate;
@property (nullable, nonatomic, copy) NSString *postStatus;
@property (nullable, nonatomic, copy) NSString *postType;
@property (nullable, nonatomic, copy) NSString *ticketDetail;
@property (nullable, nonatomic, retain) NSObject *sellerLocation;
@property (nonatomic) int32_t myPost;
@property (nonatomic) int32_t numberOfTickets;
@property (nullable, nonatomic, copy) NSString *sellerLocationText;
@property (nonatomic) BOOL postedTicketClosedOut;
@property (nonatomic) int32_t sellerReviewScore;
@property (nullable, nonatomic, retain) NSObject *sellerRating;
@property (nullable, nonatomic, retain) NSSet<CDTicketsOffer *> *offers;
@property (nullable, nonatomic, retain) CDTicketsOffer *chosenBuyerOffer;

@end

@interface CDPostedTicket (CoreDataGeneratedAccessors)

- (void)addOffersObject:(CDTicketsOffer *)value;
- (void)removeOffersObject:(CDTicketsOffer *)value;
- (void)addOffers:(NSSet<CDTicketsOffer *> *)values;
- (void)removeOffers:(NSSet<CDTicketsOffer *> *)values;

@end

NS_ASSUME_NONNULL_END
