//
//  GiveFeedbackViewController.m
//  ChatDemo
//
//  Created by Neo on 6/2/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "GiveFeedbackViewController.h"
#import "UIView+Border.h"
#import "CDTicketsOffer+CoreDataProperties.h"
#import "APTicketManager.h"

@interface GiveFeedbackViewController () {
    NSInteger score;
}

@end

@implementation GiveFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_ticket.myPost == 1) {
        _descLabel.text = [NSString stringWithFormat:@"Did you like the experience selling tickets from %@? Did he follow the Rules? Please assign stars for this transaction to help the community.", _ticket.chosenBuyerOffer.buyerName];
    } else {
        _descLabel.text = [NSString stringWithFormat:@"Did you like the experience buying tickets from %@? Did he follow the Rules? Please assign stars for this transaction to help other buyers.", _ticket.chosenBuyerOffer.buyerName];
    }
    _submitButton.enabled = NO;
    [_submitButton addTopBorderWithColor:[UIColor colorWithWhite:215.f/255 alpha:1] andWidth:1 / [UIScreen mainScreen].scale];
    [_toutSwitch setOnTintColor:[UIColor colorWithRed:239.f/255 green:67.f/255 blue:49.f/255 alpha:1]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeSwitch:(id)sender {
    _toutLabel.textColor = _toutSwitch.on ? _toutSwitch.onTintColor : [UIColor colorWithWhite:155.f/255 alpha:1];
}

- (IBAction)tapStar:(id)sender {
    score = [sender tag];
    for (UIButton *button in _starButtons) {
        if (button.tag <= [sender tag]) {
            [button setImage:[UIImage imageNamed:@"tickets_star_yellow_big"] forState:UIControlStateNormal];
        } else {
            [button setImage:[UIImage imageNamed:@"tickets_star_grey_big"] forState:UIControlStateNormal];
        }
    }
    
    _submitButton.enabled = YES;
}

- (IBAction)submit:(id)sender {
    if (_ticket.myPost == 1) {
        API_BuyerRating *rating = [API_BuyerRating new];
        rating.buyerReviewScore = @(score);
        rating.buyerReportedAsTout = _toutSwitch.on;
        rating.postedTicketsId = _ticket.postedTicketsId;
        
        [[APTicketManager sharedManager] buyerRating:rating success:^(NSString *success) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } failure:^(NSString *failure) {
            // error
        }];
    } else {
        API_SellerRating *rating = [API_SellerRating new];
        
        rating.sellerReviewScore = @(score);
        rating.sellerReportedAsTout = _toutSwitch.on;
        rating.postedTicketsId = _ticket.postedTicketsId;
        
        [[APTicketManager sharedManager] sellerRating:rating success:^(NSString *success) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } failure:^(NSString *failure) {
            // error
        }];
    }
}
@end
