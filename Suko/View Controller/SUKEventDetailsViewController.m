//
//  SUKEventDetailsViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/19/22.
//

#import "SUKEventDetailsViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <Contacts/CNPostalAddressFormatter.h>
#import <Parse/PFImageView.h>
#import "SUKNotCurrentUserProfileViewController.h"

@interface SUKEventDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *decriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation SUKEventDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *profileImageTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.profileImageView addGestureRecognizer:profileImageTapGestureRecognizer];
    [self.profileImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *usernameTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.usernameLabel setUserInteractionEnabled:YES];
    [self.usernameLabel addGestureRecognizer:usernameTapGestureRecognizer];
}

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    [self performSegueWithIdentifier:@"EventDetailsToNotCurrentUserProfileSegue" sender:self.event.postedBy];
}

- (void) setEvent:(SUKEvent*) event {
    _event = event;
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    CLLocation *eventCoordinates = [[CLLocation alloc] initWithLatitude:event.location.latitude longitude:event.location.longitude];
    
    [geoCoder reverseGeocodeLocation:eventCoordinates completionHandler:^(NSArray<CLPlacemark *> * placemarks, NSError * error) {
        CNPostalAddressFormatter *addressFormatter = [[CNPostalAddressFormatter alloc] init];
        NSString *multiLineAddress = [addressFormatter stringFromPostalAddress:placemarks[0].postalAddress];
        NSArray *addressBrokenByLines = [multiLineAddress componentsSeparatedByString:@"\n"];
        NSString *singleLineAddress = [addressBrokenByLines componentsJoinedByString:@" "];

        self.addressLabel.text = singleLineAddress;
        
        self.eventNameLabel.text = event.name;
        
        self.decriptionLabel.text = event.eventDescription;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM/dd/yyyy h:mm a";
        self.dateLabel.text = [[[dateFormatter stringFromDate:event.startTime]
                                stringByAppendingString:@" - "]
                               stringByAppendingString:[dateFormatter stringFromDate:event.endTime]];
        
        PFUser *eventPoster = event.postedBy;
        [eventPoster fetchIfNeeded];
        self.usernameLabel.text = eventPoster.username;
        
        self.profileImageView.file = eventPoster[@"profile_image"];
        [self.profileImageView loadInBackground];
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height /2;
        self.profileImageView.layer.masksToBounds = YES;
        self.profileImageView.layer.borderWidth = 0;
        
        if([self.event[@"attendees"] containsObject:[PFUser currentUser].objectId]) {
            [self.registerButton setTitle:@"Registered" forState:UIControlStateNormal];
        } else {
            [self.registerButton setTitle:@"Register" forState:UIControlStateNormal];
        }
    }];
}

- (IBAction)tapRegister:(id)sender {
    NSMutableArray *attendeesMutable = [self.event.attendees mutableCopy];
    
    if([self.event[@"attendees"] containsObject:[PFUser currentUser].objectId]) {
        [attendeesMutable removeObject:[PFUser currentUser].objectId];
        [self.registerButton setTitle:@"Register" forState:UIControlStateNormal];
    } else {
        [attendeesMutable addObject:[PFUser currentUser].objectId];
        [self.registerButton setTitle:@"Registered" forState:UIControlStateNormal];
    }
    
    self.event.attendees = [attendeesMutable copy];
    [self.event saveInBackground];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"EventDetailsToNotCurrentUserProfileSegue"]) {
        SUKNotCurrentUserProfileViewController *notCurrentUserprofileVC = [segue destinationViewController];
        notCurrentUserprofileVC.userToDisplay = sender;
    }
}

@end
