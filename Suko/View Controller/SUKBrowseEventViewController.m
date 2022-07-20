//
//  SUKBrowseEventViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/19/22.
//

#import "SUKBrowseEventViewController.h"
#import "SUKEvent.h"
#import "SUKBrowseEventTableViewCell.h"
#import "SUKEventDetailsViewController.h"
#import <MapKit/MapKit.h>
#import "SUKNotCurrentUserProfileViewController.h"
#import "Parse/Parse.h"

@interface SUKBrowseEventViewController () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<SUKEvent*> *arrOfEvents;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UISegmentedControl *discoverRegisteredSegmentedControl;

@end

@implementation SUKBrowseEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    self.arrOfEvents = [[NSArray alloc] init];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self.locationManager requestWhenInUseAuthorization];

    [self.locationManager startUpdatingLocation];
    
    [self refreshData];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    PFGeoPoint *point = [PFGeoPoint geoPointWithLocation:[locations lastObject]];
    [PFUser currentUser][@"current_coordinates"] = point;
    [[PFUser currentUser] saveInBackground];
    
    [self.locationManager stopUpdatingLocation];
}

- (void) refreshData {
    if(self.discoverRegisteredSegmentedControl.selectedSegmentIndex == 0) {
        [self browseEvents];
    } else {
        [self registeredEvents];
    }
}

- (IBAction)segmentChanged:(id)sender {
    [self refreshData];
}

- (void)browseEvents {
    NSMutableArray *mutableArrOfEvents = [self.arrOfEvents mutableCopy];
    [mutableArrOfEvents removeAllObjects];
    self.arrOfEvents = mutableArrOfEvents;
    
    // Default: sorted based on distance away from current coordinates
    PFQuery *query = [PFQuery queryWithClassName:@"SUKEvent"];
    [query includeKey:@"location"];
    [query whereKey:@"location" nearGeoPoint:[PFUser currentUser][@"current_coordinates"] withinMiles:5.0];
    [query whereKey:@"endTime" greaterThan:[NSDate now]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray<SUKEvent *> *events, NSError *error) {
        if(events.count == 0) {
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }
        for(PFUser *event in events) {
            NSMutableArray *mutableArrOfEvents = [self.arrOfEvents mutableCopy];
            [mutableArrOfEvents addObject:event];
            self.arrOfEvents = [mutableArrOfEvents copy];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }
    }];
}

- (void) registeredEvents {
    NSMutableArray *mutableArrOfEvents = [self.arrOfEvents mutableCopy];
    [mutableArrOfEvents removeAllObjects];
    self.arrOfEvents = mutableArrOfEvents;
    
    PFQuery *query = [PFQuery queryWithClassName:@"SUKEvent"];
    [query includeKey:@"location"];
    [query whereKey:@"location" nearGeoPoint:[PFUser currentUser][@"current_coordinates"] withinMiles:5.0];
    [query whereKey:@"endTime" greaterThan:[NSDate now]];
    NSString *currentUserID = [PFUser currentUser].objectId;
    [query whereKey:@"attendees" containsAllObjectsInArray:@[currentUserID]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray<SUKEvent *> *events, NSError *error) {
        if(events.count == 0) {
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }
        for(PFUser *event in events) {
            NSMutableArray *mutableArrOfEvents = [self.arrOfEvents mutableCopy];
            [mutableArrOfEvents addObject:event];
            self.arrOfEvents = [mutableArrOfEvents copy];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }
    }];
}

#pragma mark - TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrOfEvents.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SUKBrowseEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SUKBrowseEventTableViewCell"];
    SUKEvent *eventToDisplay = self.arrOfEvents[indexPath.row];
    [cell setEvent:eventToDisplay];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"BrowseEventsToEventDetailsSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell: (SUKBrowseEventTableViewCell*) sender];
        SUKEventDetailsViewController *eventDetailsVC = [segue destinationViewController];
        SUKEvent *event = self.arrOfEvents[indexPath.row];
        [eventDetailsVC setEvent:event];
    }
}

@end
