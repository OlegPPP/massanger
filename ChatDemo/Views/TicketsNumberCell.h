//
//  TicketsSearchNumberCell.h
//  ChatDemo
//
//  Created by Neo on 5/31/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TicketsNumberCellDelegate <NSObject>

- (void)pressMinus:(id)sender;
- (void)pressPlus:(id)sender;

@end

@interface TicketsNumberCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) id<TicketsNumberCellDelegate> delegate;
- (IBAction)pressMinus:(id)sender;
- (IBAction)pressPlus:(id)sender;

@end
