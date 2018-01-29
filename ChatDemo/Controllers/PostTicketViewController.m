//
//  PostTicketViewController.m
//  ChatDemo
//
//  Created by Neo on 5/31/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "PostTicketViewController.h"
#import "TicketsCurrentLocationCell.h"
#import "TicketsNumberCell.h"
#import "TicketsTypeCell.h"
#import "TicketsSearchCell.h"
#import "TicketsFixtureCell.h"
#import "TicketsSelectFixtureViewController.h"
#import <GooglePlaces/GooglePlaces.h>
#import "TicketsPostInputCell.h"
#import "API_SellTickets.h"
#import "APTicketManager.h"
#import <CoreLocation/CoreLocation.h>

@interface PostTicketViewController () <TicketsSelectFixtureDelegate, TicketsCurrentLocationCellDelegate, GMSAutocompleteViewControllerDelegate, TicketsNumberCellDelegate, TicketsTypeCellDelegate, UITextViewDelegate, CLLocationManagerDelegate> {
    NSDictionary *currentFixture;
    BOOL useCurrentLocation;
    CLLocationDegrees latitude, longitude;
    NSString *ticketLocation;
    int ticketsCount;
    BOOL isSale;
    NSString *ticketsDesc;
    
    CLLocationManager *manager;
    CLGeocoder *geocoder;
    CLLocation *myLocation;
    NSString *myAddress;
}
@end

@implementation PostTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _postButton.enabled = NO;
    
    // Auto table height
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.sectionHeaderHeight = 10;
    self.tableView.sectionFooterHeight = 0;
    
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = [UIColor clearColor];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
    // Back button title is empty
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // Register nib
    [self.tableView registerNib:[UINib nibWithNibName:@"TicketsCurrentLocationCell" bundle:nil] forCellReuseIdentifier:@"TicketsSearchCurrentLocationCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TicketsNumberCell" bundle:nil] forCellReuseIdentifier:@"TicketsSearchNumberCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TicketsTypeCell" bundle:nil] forCellReuseIdentifier:@"TicketsSearchTypeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TicketsFixtureCell" bundle:nil] forCellReuseIdentifier:@"TicketsSearchFixtureCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TicketsBasicCell" bundle:nil] forCellReuseIdentifier:@"TicketsBasicCell"];
    
    ticketLocation = @"";
    isSale = YES;
    ticketsCount = 1;
    
    latitude = 0;
    longitude = 0;
    
    manager = [CLLocationManager new];
    manager.delegate = self;
    manager.distanceFilter = kCLDistanceFilterNone;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    geocoder = [CLGeocoder new];
    myLocation = nil;
    myAddress = nil;
}

- (void)dealloc {
    manager.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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
            return 1;
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
                cell.numberLabel.text = [NSString stringWithFormat:@"%d", ticketsCount];
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
            TicketsPostInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TicketsPostInputCell" forIndexPath:indexPath];
            cell.textView.delegate = self;
            cell.textView.text = ticketsDesc;
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

// MARK: - Actions
- (IBAction)post:(id)sender {
    API_SellTickets *api_SellTickets = [API_SellTickets new];
    api_SellTickets.fixture = currentFixture;
    api_SellTickets.sellerLocationText = ticketLocation;
    api_SellTickets.longitude = latitude;
    api_SellTickets.latitude = longitude;
    api_SellTickets.ticketDetail = ticketsDesc;
    api_SellTickets.numberOfTickets = ticketsCount;
    api_SellTickets.postType = isSale ? @"SALE" : @"SWAP";
//    api_SellTickets.together ;
    
    [[APTicketManager sharedManager] sellTickets:api_SellTickets success:^(NSString *success) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSString *error) {
        NSLog(@"%@", error);
    }];
}

- (IBAction)close:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

// MARK: - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"fixtures"]) {
        TicketsSelectFixtureViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
}

// MARK: - SearchTicketsSelectFixtureDelegate
- (void)selectFixture:(NSDictionary *)fixture {
    currentFixture = fixture;
    [self.tableView reloadData];
    
    [self refreshPostButton];
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
        }
    }
    
    [self refreshPostButton];
}

// MARK: - GMSAutocompleteViewControllerDelegate
- (void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place {
    ticketLocation = place.formattedAddress;
    latitude = place.coordinate.latitude;
    longitude = place.coordinate.longitude;
    
    [self refreshPostButton];
    
    [viewController dismissViewControllerAnimated:YES completion:^{
        [self.tableView reloadData];
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
}

// MARK: - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    [self.tableView beginUpdates];
    ticketsDesc = textView.text;
    [self.tableView endUpdates];
    
    [self refreshPostButton];
}

// Bar button
- (void)refreshPostButton {
    _postButton.enabled = (ticketsDesc.length > 0 && currentFixture != nil && ticketLocation.length > 0 && longitude != 0 && latitude != 0);
}

// MARK: - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    myLocation = newLocation;
    if (useCurrentLocation) {
        latitude = myLocation.coordinate.latitude;
        longitude = myLocation.coordinate.longitude;
        [self refreshPostButton];
    }
    
    // Reverse Geocoding
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks lastObject];
            myAddress = [NSString stringWithFormat:@"%@ %@, %@ %@, %@, %@",
                                 placemark.subThoroughfare, placemark.thoroughfare,
                                 placemark.postalCode, placemark.locality,
                                 placemark.administrativeArea,
                                 placemark.country];
            if (useCurrentLocation) {
                ticketLocation = myAddress;
                [self refreshPostButton];
            }
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
}

@end
