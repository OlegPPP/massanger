//
//  TicketsSendOfferViewController.h
//  ChatDemo
//
//  Created by Neo on 5/31/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API_TicketSearchResults.h"

@protocol TicketsSendOfferViewControllerDelegate <NSObject>

- (void)sendOffer:(NSString *)offerText;

@end

@interface TicketsSendOfferViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *buyerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *competitionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fixtureDate;
@property (weak, nonatomic) IBOutlet UIImageView *awayTeamImageView;
@property (weak, nonatomic) IBOutlet UILabel *awayTeamNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *homeTeamImageView;
@property (weak, nonatomic) IBOutlet UILabel *homeTeamNameLabel;

@property (weak, nonatomic) IBOutlet UIView *fixtureContainerView;
@property (weak, nonatomic) IBOutlet UIView *descContainerView;
@property (weak, nonatomic) IBOutlet UILabel *distanceTypeLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *starImageViews;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) id<TicketsSendOfferViewControllerDelegate> delegate;

@property (strong, nonatomic) API_TicketSearchResults *ticket;

- (IBAction)cancel:(id)sender;
- (IBAction)send:(id)sender;

@end
