//
//  PopoverSelectionOfferCell.h
//  ChatDemo
//
//  Created by Neo on 6/1/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopoverSelectionOfferCellDelegate <NSObject>

- (void)openChat:(id)sender;
- (void)declineOffer:(id)sender;
- (void)dealOffer:(id)sender;

@end

@interface PopoverSelectionOfferCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *mainTextLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *starImageViews;
@property (weak, nonatomic) IBOutlet UIView *chatContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *bubbleImageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)decline:(id)sender;
- (IBAction)deal:(id)sender;
- (IBAction)chat:(id)sender;

@property (weak, nonatomic) id<PopoverSelectionOfferCellDelegate> delegate;

@end
