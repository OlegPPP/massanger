//
//  TicketsSearchCurrentLocationCell.h
//  ChatDemo
//
//  Created by Neo on 5/31/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TicketsCurrentLocationCellDelegate <NSObject>

- (void)didSwitchLocation:(BOOL)isCurrentLocation;

@end

@interface TicketsCurrentLocationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *currentLocationSwitch;
@property (weak, nonatomic) id<TicketsCurrentLocationCellDelegate> delegate;
- (IBAction)didSwitchLocation:(id)sender;

@end
