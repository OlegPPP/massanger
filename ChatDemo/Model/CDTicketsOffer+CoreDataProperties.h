//
//  CDTicketsOffer+CoreDataProperties.h
//  
//
//  Created by Neo on 6/6/17.
//
//

#import "CDTicketsOffer+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDTicketsOffer (CoreDataProperties)

+ (NSFetchRequest<CDTicketsOffer *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *buyer;
@property (nullable, nonatomic, retain) NSObject *buyerLocation;
@property (nullable, nonatomic, copy) NSString *buyerLocationText;
@property (nullable, nonatomic, copy) NSString *buyerName;
@property (nullable, nonatomic, retain) NSObject *buyerRating;
@property (nonatomic) int32_t buyerReportedAsTout;
@property (nonatomic) int32_t buyerReviewScore;
@property (nullable, nonatomic, copy) NSDate *offerAcceptedDateTime;
@property (nullable, nonatomic, copy) NSDate *offerDateTime;
@property (nullable, nonatomic, copy) NSString *offerId;
@property (nullable, nonatomic, copy) NSString *offerStatus;
@property (nonatomic) int32_t offerTimeOutMinutes;
@property (nullable, nonatomic, retain) CDPostedTicket *chosenTicket;
@property (nullable, nonatomic, retain) CDPostedTicket *ticket;

@end

NS_ASSUME_NONNULL_END
