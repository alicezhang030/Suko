//
//  SUKChooseEventLocationViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/19/22.
//

#import "SUKChooseEventLocationViewController.h"

@interface SUKChooseEventLocationViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation SUKChooseEventLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MKCoordinateRegion currentUserRegion = MKCoordinateRegionMake(self.currentUserLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01));
    [self.mapView setRegion:currentUserRegion animated:false];
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc]
                                                 initWithTarget:self
                                                         action:@selector(handleLongPress:)];
    [self.mapView addGestureRecognizer:longPressRecognizer];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
