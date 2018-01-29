//
//  TicketsListCell.h
//  ChatDemo
//
//  Created by Neo on 6/1/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TicketsListCellDelegate<NSObject>

- (void)tapProfileImage:(id)sender;
- (void)pressOffers:(id)sender;
- (void)giveFeedback:(id)sender;
- (void)pressDeals:(id)sender;
- (void)pressDecline:(id)sender;
- (void)pressCancel:(id)sender;
- (void)pressShare:(id)sender;
- (void)pressChat:(id)sender;
@end

@interface TicketsListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

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
@property (weak, nonatomic) IBOutlet UIView *fixtureContainerView;
@property (weak, nonatomic) IBOutlet UIView *descContainerView;

@property (weak, nonatomic) IBOutlet UIView *feedbackContainerView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *starImageView;
@property (weak, nonatomic) IBOutlet UIButton *offersButton;
@property (weak, nonatomic) IBOutlet UIButton *giveFeedbackButton;
@property (weak, nonatomic) IBOutlet UIView *dealsContainerView;
@property (weak, nonatomic) IBOutlet UIButton *dealsButton;
@property (weak, nonatomic) IBOutlet UIButton *declineButton;
@property (weak, nonatomic) IBOutlet UIButton *declineOnlyButton;

@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;

- (IBAction)pressOffers:(id)sender;
- (IBAction)giveFeedback:(id)sender;
- (IBAction)pressDeals:(id)sender;
- (IBAction)pressDecline:(id)sender;
- (IBAction)pressCancel:(id)sender;
- (IBAction)pressOnlyDecline:(id)sender;
- (IBAction)share:(id)sender;
- (IBAction)chat:(id)sender;



@property (weak, nonatomic) id<TicketsListCellDelegate> delegate;

@end
