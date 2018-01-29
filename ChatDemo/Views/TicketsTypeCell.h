//
//  TicketsSearchTypeCell.h
//  ChatDemo
//
//  Created by Neo on 5/31/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TicketsTypeCellDelegate <NSObject>

- (void)didChangeTicketsType:(NSInteger)type;

@end

@interface TicketsTypeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) id<TicketsTypeCellDelegate> delegate;
- (IBAction)didChangeSegment:(id)sender;
@end
