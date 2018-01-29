//
//  SearchTicketsSelectFixtureViewController.m
//  ChatDemo
//
//  Created by Neo on 5/31/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "TicketsSelectFixtureViewController.h"
#import "TicketsFixtureCell.h"

@interface TicketsSelectFixtureViewController () {
    NSArray *fixtures;
}

@end

@implementation TicketsSelectFixtureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell
    [self.tableView registerNib:[UINib nibWithNibName:@"TicketsFixtureCell" bundle:nil] forCellReuseIdentifier:@"TicketsFixtureCell"];
    
    // Table properties
    // Auto table height
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 100;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.sectionHeaderHeight = 10;
    self.tableView.sectionFooterHeight = 0;
    
    // TODO: fetch real fixtures here
    fixtures = @[@{@"id": @"1",
                   @"competitionName": @"GAA Football All Ireland",
                   @"venueName": @"Landsdown Load",
                   @"awayTeamImage": @"dublin",
                   @"awayTeamName": @"Dublin",
                   @"homeTeamImage": @"galway",
                   @"homeTeamName": @"Galway",
                   @"fixtureDate": @"Jan 15 at 6:20 pm"},
                 @{@"id": @"2",
                   @"competitionName": @"GAA Football All Ireland",
                   @"venueName": @"Landsdown Load",
                   @"awayTeamImage": @"dublin",
                   @"awayTeamName": @"Dublin",
                   @"homeTeamImage": @"galway",
                   @"homeTeamName": @"Galway",
                   @"fixtureDate": @"Jan 15 at 6:20 pm"}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return fixtures.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TicketsFixtureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TicketsFixtureCell" forIndexPath:indexPath];
    
    NSDictionary *fixtureDic = fixtures[indexPath.row];
    
    // Configure the cell...
    cell.competitionNameLabel.text = fixtureDic[@"competitionName"];
    cell.venueNameLabel.text = fixtureDic[@"venueName"];
    cell.fixtureDateLabel.text = fixtureDic[@"fixtureDate"];
    cell.awayTeamImageView.image = [UIImage imageNamed:fixtureDic[@"awayTeamImage"]];
    cell.awayTeamNameLabel.text = fixtureDic[@"awayTeamName"];
    cell.homeTeamImageView.image = [UIImage imageNamed:fixtureDic[@"homeTeamImage"]];
    cell.homeTeamNameLabel.text = fixtureDic[@"homeTeamName"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(selectFixture:)]) {
        [_delegate selectFixture:fixtures[indexPath.row]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
