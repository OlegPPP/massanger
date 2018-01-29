//
//  ChatsViewController.m
//  ChatDemo
//
//  Created by Neo on 5/16/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "ChatsViewController.h"
#import "ChatListFixtureCell.h"
#import "ChatListTeamCell.h"
#import "PopoverSelectionViewController.h"
#import <CoreData/CoreData.h>
#import "CDChat+CoreDataClass.h"
#import "CDContact+CoreDataClass.h"
#import "AppDelegate.h"
#import "JSQMessagesAvatarImageFactory.h"
#import "MessageViewController.h"

@interface ChatsViewController () <ChatListFixtureCellDelegate, ChatListTeamCellDelegate, UIPopoverPresentationControllerDelegate, PopoverSelectionViewControllerDelegate, NSFetchedResultsControllerDelegate> {
    NSIndexPath* selectedIndexPath;  // Opening chat
}
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation ChatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithWhite:242.f/255 alpha:1];
    // Remove dummy separators
    self.tableView.tableFooterView = [UIView new];
    
    // Back button title is empty
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // Separator
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    // Auto height
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    
    // Core data
    _managedObjectContext = ((AppDelegate *)[UIApplication sharedApplication].delegate).persistentContainer.viewContext;
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)dealloc {
    _fetchedResultsController = nil;
}

// MARK: - Core data
- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDChat" inManagedObjectContext:_managedObjectContext];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"exitedChat = 'false'"]];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"chatId" ascending:YES];
    [fetchRequest setSortDescriptors:@[sort]];
    
    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    if ([sectionInfo numberOfObjects] == 0) {
        tableView.scrollEnabled = NO;
        return 112;
    }
    
    tableView.scrollEnabled = YES;
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 112)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chats_popup_bubble"]];
    [view addSubview:imgView];
    imgView.frame = CGRectMake(CGRectGetWidth(view.bounds) - 8 - CGRectGetWidth(imgView.bounds), 13, CGRectGetWidth(imgView.bounds), CGRectGetHeight(imgView.bounds));
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 18, CGRectGetWidth(imgView.frame) - 16, CGRectGetHeight(imgView.frame) - 18 - 8)];
    label.font = [UIFont systemFontOfSize:17];
    label.text = @"Tap the plus icon to start a new chat";
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    [imgView addSubview:label];
    
    return view;
}

- (void)configureCell:(UITableViewCell *)acell atIndexPath:(NSIndexPath *)indexPath {
    CDChat *chat = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    NSDictionary *subject = (NSDictionary *)chat.subject;
    NSString *subjectType = subject[@"subjectType"];
    if ([subjectType isEqualToString:@"Fixture"]) {
        ChatListFixtureCell *cell = (ChatListFixtureCell *)acell;
        cell.delegate = self;
        cell.subjectTitleLabel.text = subject[@"subjectTitle"];
        // TODO: Set fixture info
        
        NSArray *contacts = [chat.chatWithContacts sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES]]];
        if (contacts.count == 1) {
            CDContact *contact = contacts[0];
            cell.membersDescLabel.text = [NSString stringWithFormat:@"%@ %@", contact.firstName, contact.lastName];
            
            // TODO: Set profile pic
            [cell.membersButton setImage:[[[[JSQMessagesAvatarImageFactory alloc] initWithDiameter:34] avatarImageWithUserInitials:[[contact.firstName substringToIndex:1] uppercaseString]
                                                                     backgroundColor:[UIColor colorWithWhite:0.88f alpha:1.0f]
                                                                           textColor:[UIColor colorWithWhite:0.59f alpha:1.0f]
                                                                                font:[UIFont systemFontOfSize:17.0f]] avatarImage] forState:UIControlStateNormal];
        } else {
            CDContact *contact = contacts[0];
            cell.membersDescLabel.text = [NSString stringWithFormat:@"%@ %@ & %ld others", contact.firstName, contact.lastName, (long)contacts.count - 1];
            [cell.membersButton setImage:[UIImage imageNamed:@"chats_group_members"] forState:UIControlStateNormal];
        }
        
        // TODO: Set unread count and last message date
    } else {
        ChatListTeamCell *cell = (ChatListTeamCell *)acell;
        cell.delegate = self;
        cell.subjectTitleLabel.text = subject[@"subjectTitle"];
        
        // TODO: Set team, sports or other info
        NSArray *contacts = [chat.chatWithContacts sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES]]];
        if (contacts.count == 1) {
            CDContact *contact = contacts[0];
            cell.membersDescLabel.text = [NSString stringWithFormat:@"%@ %@", contact.firstName, contact.lastName];
            
            // TODO: Set profile pic
            [cell.membersButton setImage:[[[[JSQMessagesAvatarImageFactory alloc] initWithDiameter:34] avatarImageWithUserInitials:[[contact.firstName substringToIndex:1] uppercaseString]
                                                                                                                   backgroundColor:[UIColor colorWithWhite:0.88f alpha:1.0f]
                                                                                                                         textColor:[UIColor colorWithWhite:0.59f alpha:1.0f]
                                                                                                                              font:[UIFont systemFontOfSize:17.0f]] avatarImage] forState:UIControlStateNormal];
        } else {
            CDContact *contact = contacts[0];
            cell.membersDescLabel.text = [NSString stringWithFormat:@"%@ %@ & %ld others", contact.firstName, contact.lastName, (long)contacts.count - 1];
            [cell.membersButton setImage:[UIImage imageNamed:@"chats_group_members"] forState:UIControlStateNormal];
        }
        
        // TODO: Set unread count and last message date
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CDChat *chat = [_fetchedResultsController objectAtIndexPath:indexPath];
    NSString *subjectType = [(NSDictionary *)chat.subject objectForKey:@"subjectType"];
    NSString *cellReuseIdentifier;
    if ([subjectType isEqualToString:@"Fixture"]) {
        cellReuseIdentifier = @"ChatListFixtureCell";
    } else {
        cellReuseIdentifier = @"ChatListTeamCell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"openChat" sender:self];
}

// MARK: - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"openChat"]) {
        MessageViewController *vc = segue.destinationViewController;
        vc.chat = [_fetchedResultsController objectAtIndexPath:selectedIndexPath];
        
    }
}

// MARK: - ChatListFixtureCellDelegate
- (void)showMembers:(id)sender {
    UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (indexPath == nil)
        return;
    
    CDChat *chat = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    PopoverSelectionViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PopoverSelectionViewController"];
    vc.delegate = self;
    vc.modalPresentationStyle = UIModalPresentationPopover;
    vc.cellType = PopoverCellTypeDefault;
    
    NSMutableArray *arrayData = [NSMutableArray new];
    for (CDContact *contact in chat.chatWithContacts) {
        PopoverSelectionModel *model = [PopoverSelectionModel new];
        // TODO: Set contact image here
//        model.image = contact[@"image"];
        model.title = [NSString stringWithFormat:@"%@ %@", contact.firstName, contact.lastName];
        [arrayData addObject:model];
    }
    // Fill demo data
    vc.arrayData = [arrayData copy];
    
    UIPopoverPresentationController *popoverVC = vc.popoverPresentationController;
    popoverVC.permittedArrowDirections = UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown;
    popoverVC.delegate = self;
    popoverVC.sourceView = sender;
    popoverVC.sourceRect = [sender bounds];
    
    [self presentViewController:vc animated:YES completion:nil];
}

// MARK: - UIPopoverPresentationControllerDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

// MARK: - PopoverSelectionViewControllerDelegate
- (void)didSelectItem:(NSInteger)index withAction:(NSInteger)action {
    // selected specific member
    NSLog(@"Selected contact %d", (long)index);
}

// MARK: - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

@end
