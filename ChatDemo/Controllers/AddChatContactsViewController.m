//
//  AddChatContactsViewController.m
//  ChatDemo
//
//  Created by Neo on 5/17/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "AddChatContactsViewController.h"
#import "AddChatContactsCell.h"
#import "AddChatContactsNewCell.h"
#import "AddChatContactsHeaderView.h"
#import <Contacts/Contacts.h>
#import "CDContact+CoreDataClass.h"
#import "AppDelegate.h"

@interface AddChatContactsViewController () <UISearchBarDelegate> {
    NSArray *contacts;
    NSArray *filtered;
    NSMutableArray *selectedContacts;  // Stored an array of id of selected contacts
    UISearchController *searchController;
    BOOL searchActive;
}
@end

@implementation AddChatContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    selectedContacts = [@[] mutableCopy];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    // Register header view
    [self.tableView registerNib:[UINib nibWithNibName:@"AddChatContactsHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"TableSectionHeader"];
    
    // Load contacts
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            //keys with fetching properties
            NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey];
            NSString *containerId = store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSError *error;
            NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            if (error) {
                NSLog(@"error fetching contacts %@", error);
            } else {
                // Fetch contacts
                NSManagedObjectContext *managedContext = [(AppDelegate *)[UIApplication sharedApplication].delegate persistentContainer].viewContext;
                NSEntityDescription *contactsEntity = [NSEntityDescription entityForName:@"CDContact" inManagedObjectContext:managedContext];
                NSFetchRequest *request = [NSFetchRequest new];
                [request setEntity:contactsEntity];
                [request setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES]]];
                NSError *error;
                NSArray *fetchedContacts = [managedContext executeFetchRequest:request error:&error];
                
                for (CNContact *contact in cnContacts) {
                    if ([fetchedContacts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"appContactId == %@", contact.identifier]].count == 0) {
                        // copy data to my custom Contacts class.
                        CDContact *newContact = [[CDContact alloc] initWithEntity:contactsEntity insertIntoManagedObjectContext:managedContext];
                        newContact.firstName = contact.givenName;
                        newContact.lastName = contact.familyName;
                        //                    UIImage *image = [UIImage imageWithData:contact.imageData];
                        //                    newContact.image = image;
                        newContact.appContactId = contact.identifier;
                        // TODO: This should be fetched from server
                        newContact.contactUserId = contact.identifier;
                    }
                }
                
                [managedContext save:nil];
                
                contacts = [managedContext executeFetchRequest:request error:&error];
                
                if (_selectedContacts) {
                    // Select existing contacts
                    for (int i = 0; i < contacts.count; i++) {
                        NSString *contactId = [contacts[i] appContactId];
                        
                        if ([_selectedContacts filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"appContactId == %@", contactId]].count > 0) {
                            [selectedContacts addObject:contacts[i]];
                        }
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    
                    for (int i = 0; i < contacts.count; i++) {
                        if ([selectedContacts containsObject:contacts[i]])
                            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                    }
                });
            }
        }        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (IBAction)close:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)add:(id)sender {
    if ([_delegate respondsToSelector:@selector(addContacts:)])
        [_delegate addContacts:[selectedContacts copy]];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    AddChatContactsHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TableSectionHeader"];
    view.contactsCountLabel.text = [@([selectedContacts count]) stringValue];
    view.searchBar.delegate = self;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 104;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (searchActive)
        return filtered.count;
    return contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CDContact *contact = searchActive ? filtered[indexPath.row] : contacts[indexPath.row];
    
    if (contact.appContactId != nil) {
        AddChatContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddChatContactsCell" forIndexPath:indexPath];
        cell.nameLabel.text = [[contact.firstName stringByAppendingString:@" "] stringByAppendingString:contact.lastName];
        cell.titleLabel.text = @"";
        cell.firstLetterLabel.text = [[cell.nameLabel.text substringToIndex:1] uppercaseString];
        cell.bottomCellSelected = NO;
        
        // if below cell is selected, set cell border to selected
        if (indexPath.row < [tableView numberOfRowsInSection:0] - 1) {
            // if below cell is selected, set the border of above cell to selected
            if ([selectedContacts containsObject:(searchActive ? filtered : contacts)[indexPath.row + 1]])
                cell.bottomCellSelected = YES;
        }
        
        return cell;
    } else {
        AddChatContactsNewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddChatContactsNewCell" forIndexPath:indexPath];
        cell.nameLabel.text = [[contact.firstName stringByAppendingString:@" "] stringByAppendingString:contact.lastName];
        cell.firstLetterLabel.text = [[cell.nameLabel.text substringToIndex:1] uppercaseString];
        
        // if below cell is selected, set cell border to selected
        if (indexPath.row < [tableView numberOfRowsInSection:0] - 1) {
            // if below cell is selected, set the border of above cell to selected
            if ([selectedContacts containsObject:(searchActive ? filtered : contacts)[indexPath.row + 1]])
                [cell.borderView setBackgroundColor:[UINavigationBar.appearance barTintColor]];
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CDContact *contact = (searchActive ? filtered : contacts)[indexPath.row];
    
    if (contact.appContactId == nil) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }
    
    [selectedContacts addObject:contact];
    
    // Enable Add button
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    // Refresh header
    AddChatContactsHeaderView *headerView = (AddChatContactsHeaderView *)[tableView headerViewForSection:0];
    headerView.contactsCountLabel.text = [@([selectedContacts count]) stringValue];
    
    if (indexPath.row > 0) {
        // set border of above cell to selected color
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0]];
        
        if ([cell isKindOfClass:[AddChatContactsCell class]]) {
            [[(AddChatContactsCell *)cell borderView] setBackgroundColor:[UINavigationBar.appearance barTintColor]];
        } else {
            [[(AddChatContactsNewCell *)cell borderView] setBackgroundColor:[UINavigationBar.appearance barTintColor]];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    CDContact *contact = (searchActive ? filtered : contacts)[indexPath.row];
    
    [selectedContacts removeObject:contact];
    
    if (selectedContacts.count == 0) {
        // Disable Add button
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    // Refresh header
    AddChatContactsHeaderView *headerView = (AddChatContactsHeaderView *)[tableView headerViewForSection:0];
    headerView.contactsCountLabel.text = [@([selectedContacts count]) stringValue];
    
    if (indexPath.row > 0) {
        // if above cell is not selected, set the border of above cell to original
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0]];
        
        if ([cell isSelected])
            return;
        
        if ([cell isKindOfClass:[AddChatContactsCell class]]) {
            [[(AddChatContactsCell *)cell borderView] setBackgroundColor:[UIColor lightGrayColor]];
        } else {
            [[(AddChatContactsNewCell *)cell borderView] setBackgroundColor:[UIColor lightGrayColor]];
        }
    }
    
    if (indexPath.row < [tableView numberOfRowsInSection:0] - 1) {
        // if below cell is selected, set the border of above cell to selected
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
        
        if (![cell isSelected])
            return;
        
        cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if ([cell isKindOfClass:[AddChatContactsCell class]]) {
            [[(AddChatContactsCell *)cell borderView] setBackgroundColor:[UINavigationBar.appearance barTintColor]];
        } else {
            [[(AddChatContactsNewCell *)cell borderView] setBackgroundColor:[UINavigationBar.appearance barTintColor]];
        }
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:NO];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        filtered = @[];
        searchActive = NO;
    } else {
        NSString *searchString = searchText;
        NSArray *words = [searchString componentsSeparatedByString:@" "];
        NSMutableArray *predicateList = [NSMutableArray array];
        for (NSString *word in words) {
            if ([word length] > 0) {
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"firstName CONTAINS[c] %@ OR lastName CONTAINS[c] %@", word, word];
                [predicateList addObject:pred];
            }
        }
        
        filtered = [contacts filteredArrayUsingPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:predicateList]];
        searchActive = YES;
    }
   
    [self.tableView reloadData];
    
    if (searchActive) {
        for (int i = 0; i < filtered.count; i++) {
            if ([selectedContacts containsObject:filtered[i]])
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    } else {
        for (int i = 0; i < contacts.count; i++) {
            if ([selectedContacts containsObject:contacts[i]])
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
}

@end
