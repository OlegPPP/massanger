//
//  PostTicketViewController.h
//  ChatDemo
//
//  Created by Neo on 5/31/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostTicketViewController : UITableViewController

- (IBAction)post:(id)sender;
- (IBAction)close:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *postButton;
@end
