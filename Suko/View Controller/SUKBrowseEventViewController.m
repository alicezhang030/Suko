//
//  SUKBrowseEventViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/19/22.
//

#import "SUKBrowseEventViewController.h"
#import "SUKEvent.h"
#import "SUKEventTableViewCell.h"
#import "SUKEventDetailsViewController.h"
#import <MapKit/MapKit.h>

@interface SUKBrowseEventViewController () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<SUKEvent*> *arrOfEvents;

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation SUKBrowseEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.arrOfEvents = [[NSArray alloc] init];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self.locationManager requestWhenInUseAuthorization];

    [self.locationManager startUpdatingLocation];
    
    [self events];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    PFGeoPoint *point = [PFGeoPoint geoPointWithLocation:[locations lastObject]];
    [PFUser currentUser][@"current_coordinates"] = point;
    [[PFUser currentUser] saveInBackground];
    
    [self.locationManager stopUpdatingLocation];
}

- (void)events {
    PFQuery *query = [PFQuery queryWithClassName:@"SUKEvent"];
    [query includeKey:@"location"];
    [query whereKey:@"location" nearGeoPoint:[PFUser currentUser][@"current_coordinates"] withinMiles:5.0];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray<SUKEvent *> *events, NSError *error) {
        for(PFUser *event in events) {
            NSMutableArray *mutableArrOfEvents = [self.arrOfEvents mutableCopy];
            [mutableArrOfEvents addObject:event];
            self.arrOfEvents = [mutableArrOfEvents copy];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrOfEvents.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SUKEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SUKEventTableViewCell"];
    SUKEvent *eventToDisplay = self.arrOfEvents[indexPath.row];
    [cell setEvent:eventToDisplay];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"BrowseEventsToEventDetailsSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell: (SUKEventTableViewCell*) sender];
        SUKEventDetailsViewController *eventDetailsVC = [segue destinationViewController];
        SUKEvent *event = self.arrOfEvents[indexPath.row];
        [eventDetailsVC setEvent:event];
    }
}

@end
