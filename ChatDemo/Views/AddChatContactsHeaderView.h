//
//  AddChatContactsHeaderView.h
//  ChatDemo
//
//  Created by Neo on 5/17/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddChatContactsHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UIView *searchContainerView;
@property (weak, nonatomic) IBOutlet UILabel *contactsCountLabel;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
