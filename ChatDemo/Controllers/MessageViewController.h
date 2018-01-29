//
//  MessageViewController.h
//  ChatDemo
//
//  Created by Neo on 5/18/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>
#import "MessagesModelData.h"
#import "CDChat+CoreDataClass.h"

@interface MessageViewController : JSQMessagesViewController <JSQMessagesComposerTextViewPasteDelegate>

@property (strong, nonatomic) MessagesModelData *modelData;
@property (strong, nonatomic) CDChat *chat;

- (IBAction)showMembersPopover:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

// Tickets deal
@property (weak, nonatomic) IBOutlet UIView *dealView;
@property (weak, nonatomic) IBOutlet UIButton *declineTicketButton;
@property (weak, nonatomic) IBOutlet UIButton *offerTicketButton;
- (IBAction)declineTickets:(id)sender;
- (IBAction)offerTickets:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *confirmOfferView;
@property (weak, nonatomic) IBOutlet UIView *confirmOfferInnerView;
@property (weak, nonatomic) IBOutlet UIView *minutesContainerView;
@property (weak, nonatomic) IBOutlet UIButton *minutesButton;
@property (weak, nonatomic) IBOutlet UIView *textFieldContainerView;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmOfferButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelOfferButton;
- (IBAction)selectMinutes:(id)sender;
- (IBAction)confirmOffer:(id)sender;
- (IBAction)cancelOffer:(id)sender;

@end
