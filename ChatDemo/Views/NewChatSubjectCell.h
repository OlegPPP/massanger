//
//  NewChatSubjectCell.h
//  ChatDemo
//
//  Created by Neo on 5/17/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewChatSubjectCellDelegate <NSObject>

- (void)didSelectSubject:(NSInteger)index sender:(UIView *)sender;

@end

@interface NewChatSubjectCell : UITableViewCell

// Public method
- (void)selectSubject:(NSInteger)index;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *subjectButtons;
- (IBAction)clickSubjectButton:(id)sender;


@property (nonatomic, weak) id<NewChatSubjectCellDelegate> delegate;

@end
