//
//  SUKPhotoMapViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/13/22.
//

#import "SUKPhotoMapViewController.h"
#import <MapKit/MapKit.h>
#import "Parse/PFGeoPoint.h";
#import "Parse/Parse.h"

@interface SUKPhotoMapViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocation *currentUserLocation;
@end

@implementation SUKPhotoMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self.locationManager requestWhenInUseAuthorization];

    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.currentUserLocation = [locations lastObject];
    
    MKCoordinateRegion currentUserRegion = MKCoordinateRegionMake(self.currentUserLocation.coordinate, MKCoordinateSpanMake(0.1, 0.1));
    [self.mapView setRegion:currentUserRegion animated:false];
    
    PFGeoPoint *point = [PFGeoPoint geoPointWithLocation:self.currentUserLocation];
    [PFUser currentUser][@"current_coordinates"] = point;
    [[PFUser currentUser] saveInBackground];
    
    [self nearestUsers];
    
    [self.locationManager stopUpdatingLocation];
}

- (void) nearestUsers {
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query includeKey:@"current_coordinates"];
    [query whereKey:@"current_coordinates" nearGeoPoint:[PFUser currentUser][@"current_coordinates"] withinMiles:2.0];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray<PFUser *> *users, NSError *error) {
        for(PFUser *user in users) {
            if([user.objectId isEqualToString:[PFUser currentUser].objectId]) {
                // Do something with the nearest users
            }
        }
    }];
}

@end
