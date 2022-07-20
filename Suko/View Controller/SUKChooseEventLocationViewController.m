//
//  SUKChooseEventLocationViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/19/22.
//

#import "SUKChooseEventLocationViewController.h"
#import "SUKEvent.h"

@interface SUKChooseEventLocationViewController () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentUserLocation;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation SUKChooseEventLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self.locationManager requestWhenInUseAuthorization];

    [self.locationManager startUpdatingLocation];

    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc]
                                                 initWithTarget:self
                                                         action:@selector(handleLongPress:)];
    [self.mapView addGestureRecognizer:longPressRecognizer];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.currentUserLocation = [locations lastObject];
    
    MKCoordinateRegion currentUserRegion = MKCoordinateRegionMake(self.currentUserLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01));
    [self.mapView setRegion:currentUserRegion animated:false];
    
    PFGeoPoint *point = [PFGeoPoint geoPointWithLocation:self.currentUserLocation];
    [PFUser currentUser][@"current_coordinates"] = point;
    [[PFUser currentUser] saveInBackground];
    
    [self.locationManager stopUpdatingLocation];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    CGPoint point = [sender locationInView:self.mapView];
    CLLocationCoordinate2D chosenCoordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.coordinate = chosenCoordinate;
    annotation.title = @"Event location";
    [self.mapView addAnnotation:annotation];
}

- (IBAction)pressConfirm:(id)sender {
    if([self.mapView.annotations count] == 0) {
        NSString *title = @"Location required";
        NSString *message = @"Please long hold on the map to select a location for your event and try again.";
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                       message:message
                                                                preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{}];
    } else if([self.mapView.annotations count] > 1) {
        NSLog(@"Error: more than one annotation on map");
    } else {
        id<MKAnnotation> eventLocationAnnotation = [self.mapView.annotations lastObject];
        CLLocationCoordinate2D eventCoordinate = eventLocationAnnotation.coordinate;
        CLLocation *eventLocation = [[CLLocation alloc] initWithLatitude:eventCoordinate.latitude longitude:eventCoordinate.longitude];
        
        [SUKEvent postEventWithName:self.eventName eventDescription:self.eventDescription eventLocation:eventLocation startTime:self.eventStartDate endTime:self.eventEndDate postedBy:[PFUser currentUser] withCompletion:^(BOOL succeeded, NSError * error) {
            if (succeeded) {
                NSLog(@"The event was uploaded!");
                
                NSArray *viewControllers = [self.navigationController viewControllers];
                [self.navigationController popToViewController:viewControllers[0] animated:YES]; // Navigate back to original map VC
            } else {
                NSLog(@"Problem uploading the event: %@", error.localizedDescription);
            }
        }];
    }
}

@end
