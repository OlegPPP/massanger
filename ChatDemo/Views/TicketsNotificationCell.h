//
//  TicketsNotificationCell.h
//  ChatDemo
//
//  Created by Neo on 6/1/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketsNotificationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;

@end
