//
//  TicketsListViewController.m
//  ChatDemo
//
//  Created by Neo on 5/30/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "TicketsListViewController.h"
#import <UIBarBUttonItem+Badge.h>
#import <UIButton+Badge.h>
#import "PopoverSelectionViewController.h"
#import "AllTicketsHeaderCell.h"
#import "TicketsListCell.h"
#import <CCMPopupSegue.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "CDPostedTicket+CoreDataClass.h"
#import "TicketsListCell.h"
#import "CDTicketsOffer+CoreDataClass.h"
#import "APTicketManager.h"
#import "MessageViewController.h"
#import "GiveFeedbackViewController.h"
#import <FCUUID.h>
#import "APChatManager.h"

@interface TicketsListViewController () <UIPopoverPresentationControllerDelegate, PopoverSelectionViewControllerDelegate, TicketsListCellDelegate, NSFetchedResultsControllerDelegate> {
    int popoverCategory; // 0: Ticket types, 1: Profile, 2: Offers
    int ticketsType;    // 0: Posted Tickets, 1: Offers, 2: All Tickets
    
    CDPostedTicket *currentTicket;
    NSArray *shownOffers;
}
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation TicketsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ticketsType = 2;
    
    // Customize table
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
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 100;

    // Register header xib
    [self.tableView registerNib:[UINib nibWithNibName:@"AllTicketsHeaderCell" bundle:nil] forCellReuseIdentifier:@"Header"];
    
    // Customize badge
    // TODO: Fetch badge here
    self.navigationItem.leftBarButtonItem.badgeValue = @"1";
    self.navigationItem.leftBarButtonItem.badgeBGColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem.badgeTextColor = [UIColor redColor];
    
    // Right bar button items
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tickets_search"] style:UIBarButtonItemStyleDone target:self action:@selector(searchTickets:)];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"chats_plus"] style:UIBarButtonItemStyleDone target:self action:@selector(addNewTicket:)];
    self.navigationItem.rightBarButtonItems = @[addButton, searchButton];
    
    // Tap gesture recognizer on Title View
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPopover:)];
    [tapGR setNumberOfTapsRequired:1];
    [self.navigationItem.titleView addGestureRecognizer:tapGR];
    
    // Core data
    _managedObjectContext = ((AppDelegate *)[UIApplication sharedApplication].delegate).persistentContainer.viewContext;
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDPostedTicket" inManagedObjectContext:_managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    if (ticketsType == 0) {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"myPost = 1"]];
    } else if (ticketsType == 1) {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"myPost = 0"]];
    }
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"postedDate" ascending:YES];
    [fetchRequest setSortDescriptors:@[sort]];
    
    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

// MARK: - Actions
- (void)searchTickets:(id)sender {
    [self performSegueWithIdentifier:@"search" sender:self];
}

- (void)addNewTicket:(id)sender {
    [self performSegueWithIdentifier:@"post" sender:self];
}

- (void)showPopover:(UITapGestureRecognizer *)tapGR {
    // Fill model
    NSMutableArray *arrayData = [NSMutableArray new];
    
    PopoverSelectionModel *model = [PopoverSelectionModel new];
    model.image = @"tickets_posted";
    model.title = @"My Posted Tickets";
    model.subtitle = @"my posted tickets to sell / swap";
    
    [arrayData addObject:model];
    
    model = [PopoverSelectionModel new];
    model.image = @"tickets_offers";
    model.title = @"My Ticket Offers";
    model.subtitle = @"my offers for tickets to buy / swap";
    
    [arrayData addObject:model];
    
    model = [PopoverSelectionModel new];
    model.image = @"tickets_both";
    model.title = @"All Tickets";
    model.subtitle = @"all my posted and offered tickets";
    
    [arrayData addObject:model];

    popoverCategory = 0;
    [self showPopoverWithArrayData:arrayData cellType:PopoverCellTypeSubtitle];
}

- (void)showPopoverWithArrayData:(NSArray *)arrayData cellType:(PopoverCellType)type {
    PopoverSelectionViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PopoverSelectionViewController"];
    vc.delegate = self;
    vc.modalPresentationStyle = UIModalPresentationPopover;
    vc.cellType = type;
    vc.arrayData = [arrayData copy];
    
    // Show popover
    UIPopoverPresentationController *popoverVC = vc.popoverPresentationController;
    popoverVC.permittedArrowDirections = UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown;
    popoverVC.delegate = self;
    popoverVC.sourceView = self.navigationItem.titleView;
    popoverVC.sourceRect = [self.navigationItem.titleView bounds];
    
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    
    if ([sectionInfo numberOfObjects] == 0) {
        AllTicketsHeaderCell *customHeaderCell = [tableView dequeueReusableCellWithIdentifier:@"Header"];
        return customHeaderCell;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TicketsListCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
}

- (void)configureCell:(UITableViewCell *)acell atIndexPath:(NSIndexPath *)indexPath {
    CDPostedTicket *ticket = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    TicketsListCell *cell = (TicketsListCell *)acell;
    cell.delegate = self;
    cell.feedbackContainerView.hidden = YES;
    cell.offersButton.hidden = YES;
    cell.giveFeedbackButton.hidden = YES;
    cell.cancelButton.hidden = YES;
    cell.dealsContainerView.hidden = YES;
    cell.declineOnlyButton.hidden = YES;
    
    // Common controls
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"MMM dd / h:mm a";
    cell.dateLabel.text = [dateFormatter stringFromDate:ticket.postedDate];
    
    NSDictionary *fixtureInfo = (NSDictionary *)ticket.fixtureInfo;
    cell.competitionNameLabel.text = fixtureInfo[@"competitionName"];
    cell.fixtureDate.text = fixtureInfo[@"fixtureDate"];
    
    // TODO: Set fixture image here
//    cell.awayTeamImageView.image = ticket.fixtureInfo[@""]
    cell.awayTeamNameLabel.text = fixtureInfo[@"awayTeamName"];
    cell.homeTeamNameLabel.text = fixtureInfo[@"homeTeamName"];
    cell.venueNameLabel.text = fixtureInfo[@"venueName"];
    cell.ticketsDetailLabel.text = ticket.ticketDetail;
    
    cell.ticketsButton.badgeFont = [UIFont systemFontOfSize:12];
    cell.ticketsButton.badgeValue = [NSString stringWithFormat:@"%d", ticket.numberOfTickets];
    cell.ticketsButton.badgeBGColor = UINavigationBar.appearance.barTintColor;
    cell.ticketsButton.badgeOriginX = -6;
    cell.ticketsButton.badgeOriginY = -6;
    
    // TODO: Set chat badge here
    cell.chatButton.badgeFont = [UIFont systemFontOfSize:12];
    cell.chatButton.badgeValue = [NSString stringWithFormat:@"%d", ticket.numberOfTickets];
    cell.chatButton.badgeOriginX = 0;
    cell.chatButton.badgeOriginY = 0;
    cell.chatButton.badgeBGColor = UINavigationBar.appearance.barTintColor;
    
    cell.shareButton.hidden = YES;
    cell.chatButton.hidden = NO;
    
    // Feedback container view
    if (ticket.chosenBuyerOffer != nil && ticket.chosenBuyerOffer.offerAcceptedDateTime != nil) {
        if (ticket.postedTicketClosedOut) {
            cell.feedbackContainerView.hidden = NO;
            for (UIImageView *imageView in cell.starImageView) {
                if (imageView.tag <= ticket.chosenBuyerOffer.buyerReviewScore) {
                    imageView.image =  [UIImage imageNamed:@"tickets_star_yellow"];
                } else {
                    imageView.image = [UIImage imageNamed:@"tickets_star_grey"];
                }
            }
        } else {
            cell.giveFeedbackButton.hidden = NO;
        }
    }
    
    // Specialized
    if ([ticket.postType isEqualToString:@"SWAP"] && ticket.chosenBuyerOffer != nil && ticket.chosenBuyerOffer.offerAcceptedDateTime != nil) {
        cell.typeImageView.image = [UIImage imageNamed:@"tickets_offers"];
        cell.typeLabel.text = @"Tickets Exchanged";
    } else if (ticket.myPost == 1) {
        cell.typeImageView.image = [UIImage imageNamed:@"tickets_posted"];
        
        if (ticket.chosenBuyerOffer != nil) {
            // TODO: Set buyer offer image here
            cell.profileImageView.image = [UIImage imageNamed:@"demo_avatar_woz"];
            
            if (ticket.chosenBuyerOffer.offerAcceptedDateTime != nil) {
                cell.typeLabel.text = @"Tickets Sold";
                
            } else {
                cell.typeLabel.text = @"Tickets Offered to Sell";
                cell.dateLabel.text = [NSString stringWithFormat:@"Expires in %d min", ticket.chosenBuyerOffer.offerTimeOutMinutes];
            }
        } else {
            cell.typeLabel.text = @"Posted Tickets for Sale";
            
            cell.shareButton.hidden = NO;
            
            cell.chatButton.hidden = YES;
            cell.offersButton.hidden = NO;
            
            [cell.offersButton setImage:[UIImage imageNamed:(ticket.offers.count == 0 ? @"tickets_offer_no" : @"tickets_offer")] forState:UIControlStateNormal];
            cell.offersButton.enabled = (ticket.offers.count > 0);
            cell.offersButton.badgeValue = (ticket.offers.count > 0) ? [NSString stringWithFormat:@"%d", (int)ticket.offers.count] : nil;
            cell.offersButton.badgeFont = [UIFont systemFontOfSize:12];
            cell.offersButton.badgeBGColor = UINavigationBar.appearance.barTintColor;
            
            cell.cancelButton.hidden = NO;
        }
    } else {
        cell.typeImageView.image = [UIImage imageNamed:@"tickets_offers"];
        if (ticket.chosenBuyerOffer != nil) {
            cell.typeLabel.text = @"Tickets on Offer";
            
            cell.dateLabel.text = [NSString stringWithFormat:@"Expires in %d min", ticket.chosenBuyerOffer.offerTimeOutMinutes];
            
            cell.dealsContainerView.hidden = NO;
        } else {
            cell.typeLabel.text = @"Offer to Buy";
            
            cell.declineOnlyButton.hidden = YES;
        }
    }
}

// MARK: - PopoverSelectionViewControllerDelegate
- (void)didSelectItem:(NSInteger)index withAction:(NSInteger)action {
    if (popoverCategory == 0) {
        ticketsType = (int)index;
        
        switch (ticketsType) {
            case 0:
                _titleLabel.text = @"Posted Tickets";
                break;
            case 1:
                _titleLabel.text = @"Ticket Offers";
                break;
            default:
                _titleLabel.text = @"All Tickets";
                break;
        }
        
        _fetchedResultsController = nil;
        
        NSError *error;
        if (![[self fetchedResultsController] performFetch:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            exit(-1);
        }
        
        [self.tableView reloadData];
    } else if (popoverCategory == 2) {
        switch (action) {
            case 0:
                // Deal
                break;
            case 1:
                // Decline
                break;
            default:
            {
                // Chat
                CDTicketsOffer *offer = shownOffers[index];
                [self showChatForOffer:offer];
            }
                break;
        }
    }
}

// MARK: - UIPopoverPresentationControllerDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

// MARK: - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue isKindOfClass:[CCMPopupSegue class]]){
        CCMPopupSegue *popupSegue = (CCMPopupSegue *)segue;
        CGRect rect = CGRectMake(0, (self.view.bounds.size.height - self.view.bounds.size.width) / 2, self.view.bounds.size.width, self.view.bounds.size.width);
        popupSegue.destinationBounds = CGRectInset(rect, 8, 8);
        
        GiveFeedbackViewController *vc = (GiveFeedbackViewController *)segue.destinationViewController;
        vc.ticket = currentTicket;
    }
}

// MARK: - TicketsListCellDelegate
- (void)tapProfileImage:(id)sender {
    // TODO: Set real seller info here
    
    // Show seller info
    NSMutableArray *arrayData = [NSMutableArray new];
    
    PopoverSelectionModel *model = [PopoverSelectionModel new];
    model.image = @"demo_avatar_cook";
    model.title = @"Craig Lynch";
    model.subtitle = @"Dublin, Ireland";
    model.rating = 4;
    
    [arrayData addObject:model];
    
    popoverCategory = 1;
    [self showPopoverWithArrayData:arrayData cellType:PopoverCellTypeSeller];
}

- (void)pressOffers:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if (indexPath) {
        CDPostedTicket *ticket = [_fetchedResultsController objectAtIndexPath:indexPath];
        
        NSMutableArray *arrayData = [NSMutableArray new];
        
        currentTicket = ticket;
        shownOffers = [ticket.offers sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"offerDateTime" ascending:YES]]];
        for (CDTicketsOffer *offer in shownOffers) {
            PopoverSelectionModel *model = [PopoverSelectionModel new];
            
            // TODO: Set avatar here
            model.image = @"demo_avatar_cook";
            model.title = offer.buyerName;
            // TODO: Set offer desc
            model.subtitle = @"Hey, have you still got these for sale? I'm interested. Can you meet me somewhere in the city centre this weekend?";
            
            model.rating = [[(NSDictionary *)offer.buyerRating objectForKey:@"averageUserRating"] integerValue];
            [arrayData addObject:model];
        }
        
        popoverCategory = 2;
        [self showPopoverWithArrayData:arrayData cellType:PopoverCellTypeOffer];
    }
}

- (void)giveFeedback:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if (indexPath) {
        currentTicket = [_fetchedResultsController objectAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"feedback" sender:self];
    }
}

- (void)pressDeals:(id)sender {
    
}

- (void)pressDecline:(id)sender {
    
}

- (void)pressCancel:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if (indexPath) {
        CDPostedTicket *ticket = [_fetchedResultsController objectAtIndexPath:indexPath];
        [[APTicketManager sharedManager] cancelTicketsForSale:ticket.postedTicketsId success:^(NSString *success) {
            _fetchedResultsController = nil;
            
            NSError *error;
            if (![[self fetchedResultsController] performFetch:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                exit(-1);
            }
            
            [self.tableView reloadData];
        } failure:^(NSString *failure) {
            
        }];
    }
}


- (void)pressShare:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if (indexPath) {
        [self shareText:@"Sample Text" andImage:nil andUrl:[NSURL URLWithString:@"http://example.com"]];
    }
}

- (void)pressChat:(id)sender {
    [self showChatForOffer:currentTicket.chosenBuyerOffer];
}

- (void)showChatForOffer:(CDTicketsOffer *)offer {
    MessageViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MessageViewController"];
    
    NSManagedObjectContext *managedContext = [(AppDelegate *)[UIApplication sharedApplication].delegate persistentContainer].viewContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDChat" inManagedObjectContext:managedContext];
    
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"subject.subjectType == 'TicketPost' AND subject.subjectPostedTicketsId == %@", currentTicket.postedTicketsId]];
    
    NSError *error = nil;
    NSArray *results = [managedContext executeFetchRequest:request error:&error];
    
    if (results.count > 0) {
        vc.chat = results[0];
    } else {
        // Create new chat
        CDChat *chat = [[CDChat alloc] initWithEntity:entity insertIntoManagedObjectContext:managedContext];
        
        chat.chatId = [FCUUID uuid];
        chat.chatOwner = [APChatManager sharedManager].currentUserId;
        chat.isChatOwner = @"true";
        chat.exitedChat = @"false";
        
        NSMutableDictionary *subjectDic = [@{@"subjectTitle": offer.buyerName,
                                             @"subjectType": @"TicketPost"} mutableCopy];
        
        subjectDic[@"subjectPostedTicketId"] = offer.ticket.postedTicketsId;

        subjectDic[@"subjectImageAvailable"] = @"false";
        
        chat.subject = [subjectDic copy];
        
        // Fetch contacts
        // TODO: contact needs to be added here or ?
//        NSEntityDescription *contactsEntity = [NSEntityDescription entityForName:@"CDContact" inManagedObjectContext:managedContext];
//        NSFetchRequest *request = [NSFetchRequest new];
//        [request setEntity:contactsEntity];
//        [request setPredicate:[NSPredicate predicateWithFormat:@"appContactId IN %@", newChat.chatMemberContactId]];
//        NSError *error;
//        NSArray *fetchedContacts = [managedContext executeFetchRequest:request error:&error];
//        
//        if (!error) {
//            [chat addChatWithContacts:[NSSet setWithArray:fetchedContacts]];
//            
//            [managedContext save:&error];
//        }
        
        vc.chat = chat;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: - Share
- (void)shareText:(NSString *)text andImage:(UIImage *)image andUrl:(NSURL *)url
{
    NSMutableArray *sharingItems = [NSMutableArray new];
    if (text) {
        [sharingItems addObject:text];
    }
    if (image) {
        [sharingItems addObject:image];
    }
    if (url) {
        [sharingItems addObject:url];
    }
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

// MARK: - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
//    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    /*
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
     */
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    /*
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
     */
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
//    [self.tableView endUpdates];
    [self.tableView reloadData];
}

@end
