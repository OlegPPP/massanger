//
//  NewChatContactCell.h
//  ChatDemo
//
//  Created by Neo on 5/17/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewChatContactCellDelegate <NSObject>
- (void)didRemoveContact:(id)sender;
@end

@interface NewChatContactCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIView *dummyImageView;
@property (weak, nonatomic) IBOutlet UILabel *firstLetterLabel;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;

@property (weak, nonatomic) IBOutlet UILabel *contactName;
- (IBAction)tapRemove:(id)sender;

// Public setters
@property (weak, nonatomic) id<NewChatContactCellDelegate> delegate;
- (void)setProfileName:(NSString *)name;

@end
