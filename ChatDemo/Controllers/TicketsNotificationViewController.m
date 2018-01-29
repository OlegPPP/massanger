//
//  TicketsNotificationViewController.m
//  ChatDemo
//
//  Created by Neo on 6/1/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "TicketsNotificationViewController.h"
#import "TicketsNotificationCell.h"

@interface TicketsNotificationViewController ()
{
    NSArray *titles, *subtitles;
}
@end

@implementation TicketsNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Auto table height
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    // Back button title is empty
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    titles = @[@"Posted Tickets for Sale - Expired",
               @"Sold Tickets Awaiting Review",
               @"Open Ticket Offers to Buy",
               @"Bought Tickets Awaiting Review"];
    
    NSMutableArray *temp = [NSMutableArray new];
    for (int i = 0; i < 4; i++) {
        NSString *suffix;
        switch (i) {
            case 0:
                suffix = @"Confirm if tickets were sold";
                break;
            case 1:
                suffix = @"Provide buyer feedback";
                break;
            case 2:
                suffix = @"Decline or accept offers";
                break;
            default:
                suffix = @"Provide seller feedback";
                break;
        }
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[@"Action required! " stringByAppendingString:suffix]];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, attributedString.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:247.f/255 green:140.f/255 blue:46.f/255 alpha:1] range:NSMakeRange(0, 16)];
        [temp addObject:attributedString];
    }
    subtitles = [temp copy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TicketsNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TicketsNotificationCell" forIndexPath:indexPath];
    
    cell.titleLabel.text = titles[indexPath.section * 2 + indexPath.row];
    cell.subtitleLabel.attributedText = subtitles[indexPath.section * 2 + indexPath.row];
    cell.badgeLabel.text = @"2";
    
    return cell;
}

@end
