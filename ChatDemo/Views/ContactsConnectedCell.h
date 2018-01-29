//
//  ContactsConnectedCell.h
//  ChatDemo
//
//  Created by Neo on 6/5/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsConnectedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIView *onlineContainerView;
@property (weak, nonatomic) IBOutlet UIView *onlineIndicator;
@property (weak, nonatomic) IBOutlet UILabel *mainTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTextLabel;
@end
