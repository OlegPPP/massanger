//
//  NewChatSubjectOtherCell.h
//  ChatDemo
//
//  Created by Neo on 5/17/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewChatSubjectOtherCellDelegate <NSObject>

- (void)willPresentCamera;

@end

@interface NewChatSubjectOtherCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointerConstraint;
- (IBAction)cameraTapped:(id)sender;

@property (weak, nonatomic) id<NewChatSubjectOtherCellDelegate> delegate;
@end
