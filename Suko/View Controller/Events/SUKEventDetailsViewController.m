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
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation SUKEventDetailsViewController

NSString * const kEventDetailsToNotCurrentUserProfileSegue = @"EventDetailsToNotCurrentUserProfileSegue";
NSString * const kProfileImageDictionaryKey = @"profile_image";
NSString * const kAttendeesDictionaryKey = @"attendees";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *profileImageTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.profileImageView addGestureRecognizer:profileImageTapGestureRecognizer];
    [self.profileImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *usernameTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.usernameLabel setUserInteractionEnabled:YES];
    [self.usernameLabel addGestureRecognizer:usernameTapGestureRecognizer];
    
    self.registerButton.layer.cornerRadius = 4;
    self.registerButton.layer.masksToBounds = true;
    
    self.spinner.hidesWhenStopped = YES;
    [self.spinner startAnimating];
}

- (void)setEvent:(SUKEvent *)event {
    _event = event;
    
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __strong __typeof(self) strongSelf = weakSelf;
        [strongSelf setAddress];
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.eventNameLabel.text = event.name;
            self.decriptionLabel.text = event.eventDescription;
            self.usernameLabel.text = event.postedBy.username;
            self.profileImageView.file = event.postedBy[kProfileImageDictionaryKey];
            [self.profileImageView loadInBackground];
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height /2;
            self.profileImageView.layer.masksToBounds = YES;
            self.profileImageView.layer.borderWidth = 0;
            
            if([self.event[kAttendeesDictionaryKey] containsObject:[PFUser currentUser].objectId]) {
                [self.registerButton setTitle:@"Registered" forState:UIControlStateNormal];
            } else {
                [self.registerButton setTitle:@"Register" forState:UIControlStateNormal];
            }
            
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            dateFormatter.dateFormat = @"MM/dd/yyyy h:mm a";
            self.dateLabel.text = [[[dateFormatter stringFromDate:event.startTime]
                                    stringByAppendingString:@" - "]
                                   stringByAppendingString:[dateFormatter stringFromDate:event.endTime]];
        });
    });
}

- (void)setAddress {
    CLGeocoder *geoCoder = [CLGeocoder new];
    CLLocation *eventCoordinates = [[CLLocation alloc] initWithLatitude:self.event.location.latitude longitude:self.event.location.longitude];
    
    __weak __typeof(self) weakSelf = self;
    [geoCoder reverseGeocodeLocation:eventCoordinates completionHandler:^(NSArray<CLPlacemark *> * placemarks, NSError * error) {
        __strong __typeof(self) strongSelf = weakSelf;
        if(error != nil) {
            strongSelf.addressLabel.text = @"Failed to load address";
            [strongSelf.spinner stopAnimating];
            
            NSLog(@"Failed to load address: %@", error.localizedDescription);
        } else {
            CNPostalAddressFormatter *addressFormatter = [CNPostalAddressFormatter new];
            NSString *multiLineAddress = [addressFormatter stringFromPostalAddress:placemarks[0].postalAddress];
            NSArray<NSString *> *addressBrokenByLines = [multiLineAddress componentsSeparatedByString:@"\n"];
            NSString *singleLineAddress = [addressBrokenByLines componentsJoinedByString:@" "];

            strongSelf.addressLabel.text = singleLineAddress;
            
            [strongSelf.spinner stopAnimating];
        }
    }];
}

- (IBAction)tapRegister:(id)sender {
    NSMutableArray<NSString *> *attendeesMutable = [self.event.attendees mutableCopy];
    
    if([self.event[kAttendeesDictionaryKey] containsObject:[PFUser currentUser].objectId]) {
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

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender {
    [self performSegueWithIdentifier:kEventDetailsToNotCurrentUserProfileSegue sender:self.event.postedBy];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:kEventDetailsToNotCurrentUserProfileSegue]) {
        SUKNotCurrentUserProfileViewController *notCurrentUserprofileVC = [segue destinationViewController];
        notCurrentUserprofileVC.userToDisplay = sender;
    }
}

@end
