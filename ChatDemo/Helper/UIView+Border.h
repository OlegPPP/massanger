//
//  UIView+Border.h
//  ChatDemo
//
//  Created by Neo on 5/16/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(Border)
- (void)addBottomBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;

- (void)addLeftBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;

- (void)addRightBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;

- (void)addTopBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;
@end
