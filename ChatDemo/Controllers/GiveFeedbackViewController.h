//
//  GiveFeedbackViewController.h
//  ChatDemo
//
//  Created by Neo on 6/2/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDPostedTicket+CoreDataClass.h"

@interface GiveFeedbackViewController : UIViewController

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *starButtons;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UISwitch *toutSwitch;
@property (weak, nonatomic) IBOutlet UILabel *toutLabel;
- (IBAction)changeSwitch:(id)sender;
- (IBAction)tapStar:(id)sender;
- (IBAction)submit:(id)sender;

@property (strong, nonatomic) CDPostedTicket *ticket;

@end
