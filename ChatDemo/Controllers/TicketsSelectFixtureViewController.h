//
//  SearchTicketsSelectFixtureViewController.h
//  ChatDemo
//
//  Created by Neo on 5/31/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TicketsSelectFixtureDelegate <NSObject>

- (void)selectFixture:(NSDictionary *)fixture;

@end

@interface TicketsSelectFixtureViewController : UITableViewController
@property (weak, nonatomic) id<TicketsSelectFixtureDelegate> delegate;
@end
