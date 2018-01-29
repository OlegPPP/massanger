//
//  TicketsSearchCell.h
//  ChatDemo
//
//  Created by Neo on 5/31/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TicketsSearchCellDelegate <NSObject>

- (void)showOfferInput:(id)sender;

@end

@interface TicketsSearchCell : UITableViewCell

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
@property (weak, nonatomic) IBOutlet UIButton *ticketsButton;
@property (weak, nonatomic) IBOutlet UILabel *ticketsDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *offerButton;
@property (weak, nonatomic) IBOutlet UIView *fixtureContainerView;
@property (weak, nonatomic) IBOutlet UIView *descContainerView;
@property (weak, nonatomic) IBOutlet UILabel *distanceTypeLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *starImageViews;

@property (weak, nonatomic) id<TicketsSearchCellDelegate> delegate;

- (IBAction)pressOffer:(id)sender;

@end
