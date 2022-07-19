//
//  SUKPhotoMapViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/13/22.
//

#import "SUKUserMapViewController.h"
#import <MapKit/MapKit.h>
#import "Parse/PFGeoPoint.h"
#import "Parse/Parse.h"
#import "SUKNotCurrentUserProfileViewController.h"
#import "SUKCreateNewEventViewController.h"

@interface SUKUserMapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocation *currentUserLocation;
@property (nonatomic, strong) NSMutableArray<PFUser *> *nearestUsersArr;
@end

@implementation SUKUserMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
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
    
    MKCoordinateRegion currentUserRegion = MKCoordinateRegionMake(self.currentUserLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01));
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
            if(![user.objectId isEqualToString:[PFUser currentUser].objectId]) {
                [self.nearestUsersArr addObject:user];
                
                MKPointAnnotation *annotation = [MKPointAnnotation new];
                PFGeoPoint *user_coordinates = user[@"current_coordinates"];
                annotation.coordinate = CLLocationCoordinate2DMake(user_coordinates.latitude, user_coordinates.longitude);
                annotation.title = user.username;
                [self.mapView addAnnotation:annotation];
                
            }
        }
    }];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSString *title = view.annotation.title;
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:title];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray<PFUser *> *users, NSError *error) {
        if(users.count > 1) {
            NSLog(@"Error: More than one user with the username");
        } else {
            [self.mapView deselectAnnotation:view.annotation animated:YES];
            [self performSegueWithIdentifier:@"MapToNotCurrentUserProfileSegue" sender:[users lastObject]];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"MapToNotCurrentUserProfileSegue"]) {
        SUKNotCurrentUserProfileViewController *notCurrentUserprofileVC = [segue destinationViewController];
        notCurrentUserprofileVC.userToDisplay = sender;
    }

    if([segue.identifier isEqualToString:@"UserMapToCreateEventFormSegue"]) {
        SUKCreateNewEventViewController *newEventFormVC = [segue destinationViewController];
        newEventFormVC.currentUserLocation = self.currentUserLocation;
    }
}

@end
