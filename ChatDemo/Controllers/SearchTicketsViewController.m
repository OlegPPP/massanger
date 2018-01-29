//
//  SearchTicketsViewController.m
//  ChatDemo
//
//  Created by Neo on 5/30/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "SearchTicketsViewController.h"
#import "TicketsCurrentLocationCell.h"
#import "TicketsNumberCell.h"
#import "TicketsTypeCell.h"
#import "TicketsSearchCell.h"
#import "TicketsFixtureCell.h"
#import "TicketsSelectFixtureViewController.h"
#import "TicketsSendOfferViewController.h"
#import <UIButton+Badge.h>
#import <GooglePlaces/GooglePlaces.h>
#import <CoreLocation/CoreLocation.h>
#import "API_SearchForTickets.h"
#import "APTicketManager.h"

@interface SearchTicketsViewController () <TicketsSelectFixtureDelegate, TicketsCurrentLocationCellDelegate, GMSAutocompleteViewControllerDelegate, TicketsNumberCellDelegate, TicketsTypeCellDelegate, TicketsSearchCellDelegate, TicketsSendOfferViewControllerDelegate, CLLocationManagerDelegate> {
    NSDictionary *currentFixture;
    NSArray<API_TicketSearchResults *> *ticketsFound;
    BOOL useCurrentLocation;
    CLLocationDegrees latitude, longitude;
    NSString *ticketLocation;
    NSInteger ticketsCount;
    BOOL isSale;
    NSString *ticketsDesc;
    
    CLLocationManager *manager;
    CLGeocoder *geocoder;
    CLLocation *myLocation;
    NSString *myAddress;
    
    // Sending Offer
    API_TicketSearchResults *ticketSendingOffer;
}

@end

@implementation SearchTicketsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Auto table height
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.sectionHeaderHeight = 10;
    self.tableView.sectionFooterHeight = 0;
    
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = [UIColor clearColor];
    
    // Back button title is empty
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // Register nib
    [self.tableView registerNib:[UINib nibWithNibName:@"TicketsCurrentLocationCell" bundle:nil] forCellReuseIdentifier:@"TicketsSearchCurrentLocationCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TicketsNumberCell" bundle:nil] forCellReuseIdentifier:@"TicketsSearchNumberCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TicketsTypeCell" bundle:nil] forCellReuseIdentifier:@"TicketsSearchTypeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TicketsFixtureCell" bundle:nil] forCellReuseIdentifier:@"TicketsSearchFixtureCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TicketsBasicCell" bundle:nil] forCellReuseIdentifier:@"TicketsBasicCell"];
    
    //
    ticketsFound = @[];
    ticketLocation = @"";
    isSale = YES;
    ticketsCount = 1;
    
    manager = [CLLocationManager new];
    manager.delegate = self;
    manager.distanceFilter = kCLDistanceFilterNone;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    geocoder = [CLGeocoder new];
    myLocation = nil;
    myAddress = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    manager.delegate = nil;
}

// MARK: - Actions
- (IBAction)close:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        if (ticketsFound.count == 0) {
            UITableViewCell *customHeaderCell = [tableView dequeueReusableCellWithIdentifier:@"TicketsSearchNoneHeaderCell"];
            return customHeaderCell;
        } else {
            UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 50)];
            v.backgroundColor = [UIColor clearColor];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18, 22, 300, 18)];
            label.text = @"TICKETS FOUND";
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:18];
            [v addSubview:label];
            return v;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        return (ticketsFound.count > 0 ? 50 : 147);
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return useCurrentLocation ? 1 : 2;
        case 2:
            return 2;
        default:
            return ticketsFound.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            if (currentFixture != nil) {
                TicketsFixtureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TicketsSearchFixtureCell" forIndexPath:indexPath];
                return cell;
            } else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TicketsBasicCell" forIndexPath:indexPath];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"Select Fixture";
                return cell;
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                TicketsCurrentLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TicketsSearchCurrentLocationCell" forIndexPath:indexPath];
                cell.currentLocationSwitch.on = useCurrentLocation;
                cell.delegate = self;
                return cell;
            } else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TicketsBasicCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = ticketLocation.length > 0 ? ticketLocation : @"Enter ticket(s) location";
                cell.accessoryType = UITableViewCellAccessoryNone;
                return cell;
            }
        }
            break;
        case 2:
        {
            if (indexPath.row == 0) {
                TicketsNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TicketsSearchNumberCell" forIndexPath:indexPath];
                cell.delegate = self;
                cell.minusButton.enabled = (ticketsCount > 1);
                cell.plusButton.enabled = (ticketsCount < 50);
                cell.numberLabel.text = [NSString stringWithFormat:@"%ld", ticketsCount];
                return cell;
            } else {
                TicketsTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TicketsSearchTypeCell" forIndexPath:indexPath];
                cell.delegate = self;
                cell.segmentedControl.selectedSegmentIndex = isSale ? 0 : 1;
                return cell;
            }
        }
        default:
        {
            TicketsSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TicketsSearchCell" forIndexPath:indexPath];
            cell.delegate = self;
            
            API_TicketSearchResults *result = ticketsFound[indexPath.row];
            
            if ([result.postType isEqualToString:@"SELL"]) {
                cell.typeImageView.image = [UIImage imageNamed:@"tickets_offers"];
            } else {
                cell.typeImageView.image = [UIImage imageNamed:@"tickets_both"];
            }
            
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            dateFormatter.dateFormat = @"MMM dd / h:mm a";
            cell.dateLabel.text = [dateFormatter stringFromDate:result.postedDate];
            
            // TODO: Calculate distance between mine and seller location
            for (UIImageView *imageView in [cell starImageViews]) {
                if (imageView.tag <= [[result.sellerRating objectForKey:@"averageUserRating"] integerValue]) {
                    imageView.image = [UIImage imageNamed:@"tickets_star_yellow"];
                } else {
                    imageView.image = [UIImage imageNamed:@"tickets_star_grey"];
                }
            }
            
            cell.competitionNameLabel.text = result.fixtureInfo[@"competitionName"];
            cell.venueNameLabel.text = result.fixtureInfo[@"venueName"];
            cell.awayTeamNameLabel.text = result.fixtureInfo[@"awayTeamName"];
            cell.homeTeamNameLabel.text = result.fixtureInfo[@"homeTeamName"];
            // TODO: Set team image
            cell.fixtureDate.text = result.fixtureInfo[@"fixtureDate"];
            cell.ticketsDetailLabel.text = result.ticketDetail;
            
            cell.ticketsButton.badgeFont = [UIFont systemFontOfSize:12];
            cell.ticketsButton.badgeValue = [result.numberOfTickets description];
            cell.ticketsButton.badgeBGColor = UINavigationBar.appearance.barTintColor;
            cell.ticketsButton.badgeOriginX = -6;
            cell.ticketsButton.badgeOriginY = -6;
            cell.ticketsButton.badge.layer.borderWidth = 2;
            cell.ticketsButton.badge.layer.borderColor = [UIColor whiteColor].CGColor;
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            [self performSegueWithIdentifier:@"fixtures" sender:self];
        }
            break;
        case 1:
        {
            if (indexPath.row == 1) {
                // Open location
                GMSAutocompleteViewController *vc = [GMSAutocompleteViewController new];
                vc.delegate = self;
                
                GMSAutocompleteFilter *filter = [GMSAutocompleteFilter new];
                filter.type = kGMSPlacesAutocompleteTypeFilterAddress;
                vc.autocompleteFilter = filter;
                [self presentViewController:vc animated:YES completion:nil];
            }
        }
        default:
            break;
    }
}

// MARK: - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"fixtures"]) {
        TicketsSelectFixtureViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    } else if([segue.identifier isEqualToString:@"input"]) {
        TicketsSendOfferViewController *vc = [(UINavigationController *)segue.destinationViewController viewControllers][0];
        vc.ticket = ticketSendingOffer;
        vc.delegate = self;
    }
}

// MARK: - SearchTicketsSelectFixtureDelegate
- (void)selectFixture:(NSDictionary *)fixture {
    currentFixture = fixture;
    
    [self doSearch];
}

// MARK: - TicketsCurrentLocationCellDelegate
- (void)didSwitchLocation:(BOOL)isCurrentLocation {
    useCurrentLocation = isCurrentLocation;
    latitude = 0;
    longitude = 0;
    ticketLocation = @"";
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if (useCurrentLocation) {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            [manager requestWhenInUseAuthorization];
        }
        
        [manager startUpdatingLocation];
        
        if (myLocation != nil) {
            latitude = myLocation.coordinate.latitude;
            longitude = myLocation.coordinate.longitude;
        }
        
        if (myAddress != nil) {
            ticketLocation = myAddress;
            
            [self doSearch];
        }
    }
}

// MARK: - GMSAutocompleteViewControllerDelegate
- (void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place {
    ticketLocation = place.formattedAddress;
    latitude = place.coordinate.latitude;
    longitude = place.coordinate.longitude;
    
    [viewController dismissViewControllerAnimated:YES completion:^{
        [self doSearch];
    }];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController didFailAutocompleteWithError:(NSError *)error {
    NSLog(@"%@", error.localizedDescription);
}

- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

// MARK: - TicketsNumberCellDelegate
- (void)pressMinus:(id)sender {
    ticketsCount--;
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)pressPlus:(id)sender {
    ticketsCount++;
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

// MARK: - TicketsTypeCellDelegate
- (void)didChangeTicketsType:(NSInteger)type {
    isSale = type == 0;
    
    [self doSearch];
}

// MARK: - TicketsSearchCellDelegate
- (void)showOfferInput:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if (indexPath) {
        ticketSendingOffer = ticketsFound[indexPath.row];
        [self performSegueWithIdentifier:@"input" sender:self];
    }
}

// MARK: - TicketsSendOfferViewControllerDelegate
- (void)sendOffer:(NSString *)offerText {
    [[APTicketManager sharedManager] offerToBuyTickets:ticketSendingOffer.postedTicketsId success:^(NSString *success) {
        
    } failure:^(NSString *failure) {
        
    }];
}

// MARK: - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    myLocation = newLocation;
    if (useCurrentLocation) {
        latitude = myLocation.coordinate.latitude;
        longitude = myLocation.coordinate.longitude;
    }
    
    // Reverse Geocoding
//    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
//        if (error == nil && [placemarks count] > 0) {
//            CLPlacemark *placemark = [placemarks lastObject];
//            myAddress = [NSString stringWithFormat:@"%@ %@, %@ %@, %@, %@",
//                         placemark.subThoroughfare, placemark.thoroughfare,
//                         placemark.postalCode, placemark.locality,
//                         placemark.administrativeArea,
//                         placemark.country];
//            if (useCurrentLocation) {
//                ticketLocation = myAddress;
//            }
//        } else {
//            NSLog(@"%@", error.debugDescription);
//        }
//    } ];
}

// MARK: - Search action
- (void)doSearch {
    [self.tableView reloadData];
    if (currentFixture == nil || ticketLocation == nil || ticketLocation.length == 0 || latitude == 0 || longitude == 0) {
        return;
    }
    API_SearchForTickets *api_SearchForTickets = [API_SearchForTickets new];
    api_SearchForTickets.fixture = currentFixture[@"id"];
    api_SearchForTickets.useCurrentLocation = useCurrentLocation;
    api_SearchForTickets.latitude = latitude;
    api_SearchForTickets.longitude = longitude;
    api_SearchForTickets.swap = !isSale;
    [[APTicketManager sharedManager] searchForTicketsToBuy:api_SearchForTickets success:^(NSArray<API_TicketSearchResults *> *success) {
        ticketsFound = success;
        [self.tableView reloadData];
    } failure:^(NSString *failure) {
        
    }];
}

@end
