//
//  SUKPhotoMapViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/13/22.
//

#import "SUKPhotoMapViewController.h"
#import <MapKit/MapKit.h>

@interface SUKPhotoMapViewController () <CLLocationManagerDelegate>
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
    NSLog(@"Location %f %f", self.currentUserLocation.coordinate.latitude, self.currentUserLocation.coordinate.longitude);
    [self.locationManager stopUpdatingLocation];
}

@end
