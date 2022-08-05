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
#import "SUKConstants.h"

@interface SUKUserMapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocation *currentUserLocation;
@property (nonatomic, strong) NSMutableArray<PFUser *> *nearestUsersArr;
@end

@implementation SUKUserMapViewController

int const kUserMileRadius = 3.0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self.locationManager requestWhenInUseAuthorization];

    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.currentUserLocation = [locations lastObject];
    
    MKCoordinateRegion currentUserRegion = MKCoordinateRegionMake(self.currentUserLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01));
    [self.mapView setRegion:currentUserRegion animated:false];
    
    PFGeoPoint *point = [PFGeoPoint geoPointWithLocation:self.currentUserLocation];
    [PFUser currentUser][kPFUserCurrentCoordinatesKey] = point;
    [[PFUser currentUser] saveInBackground];
    
    [self nearestUsers];
    
    [self.locationManager stopUpdatingLocation];
}

- (void)nearestUsers {
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query includeKey:kPFUserCurrentCoordinatesKey];
    [query whereKey:kPFUserCurrentCoordinatesKey nearGeoPoint:[PFUser currentUser][kPFUserCurrentCoordinatesKey] withinMiles:kUserMileRadius];
    [query whereKey:kPFUserUserMapPrivacyKey equalTo:@0];
    
    __weak __typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray<PFUser *> *users, NSError *error) {
        __strong __typeof(self) strongSelf = weakSelf;
        if(error != nil) {
            NSString *title = @"Failed to load nearby users";
            NSString *message = error.localizedDescription;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message
                                        preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {}];
            [alert addAction:okAction];
            [strongSelf presentViewController:alert animated:YES completion:^{}];
            
            NSLog(@"Failed to load nearby users: %@", error.localizedDescription);
        } else {
            for(PFUser *user in users) {
                if(![user.objectId isEqualToString:[PFUser currentUser].objectId]) {
                    [strongSelf.nearestUsersArr addObject:user];
                    
                    MKPointAnnotation *annotation = [MKPointAnnotation new];
                    PFGeoPoint *user_coordinates = user[kPFUserCurrentCoordinatesKey];
                    annotation.coordinate = CLLocationCoordinate2DMake(user_coordinates.latitude, user_coordinates.longitude);
                    annotation.title = user.username;
                    [strongSelf.mapView addAnnotation:annotation];
                }
            }
        }
    }];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSString *title = view.annotation.title;
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:title];
    
    __weak __typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray<PFUser *> *users, NSError *error) {
        __strong __typeof(self) strongSelf = weakSelf;
        if(error != nil) {
            NSString *title = @"Failed to load profile";
            NSString *message = error.localizedDescription;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message
                                        preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {}];
            [alert addAction:okAction];
            [strongSelf presentViewController:alert animated:YES completion:^{}];
            
            NSLog(@"Failed to %@'s profile: %@", title, error.localizedDescription);
        } else if(users.count > 1) {
            NSLog(@"Error: More than one user with the username");
        } else {
            [strongSelf.mapView deselectAnnotation:view.annotation animated:YES];
            [strongSelf performSegueWithIdentifier:kUserMapToNotCurrentUserProfileSegueIdentifier sender:[users lastObject]];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:kUserMapToNotCurrentUserProfileSegueIdentifier]) {
        SUKNotCurrentUserProfileViewController *notCurrentUserprofileVC = [segue destinationViewController];
        notCurrentUserprofileVC.userToDisplay = sender;
    }
}

@end
