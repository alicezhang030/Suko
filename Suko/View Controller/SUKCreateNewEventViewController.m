//
//  SUKCreateNewEventViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/15/22.
//

#import "SUKCreateNewEventViewController.h"
#import "SUKEvent.h"
#import "SUKUserMapViewController.h"
#import "SUKChooseEventLocationViewController.h"

@interface SUKCreateNewEventViewController ()
@property (weak, nonatomic) IBOutlet UITextField *eventNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *eventDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIDatePicker *timeDatePicker;

@end

@implementation SUKCreateNewEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.eventDescriptionTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.eventDescriptionTextView.layer.borderWidth = 0.5;
}

-(void)dismissKeyboard{
    [self.eventNameTextField resignFirstResponder];
    [self.eventDescriptionTextView resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"CreateNewEventToChooseEventLocationSegue"]) {
        SUKChooseEventLocationViewController *chooseLocationVC = [segue destinationViewController];
        chooseLocationVC.currentUserLocation = self.currentUserLocation;
    }
}

/*
NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
formatter.numberStyle = NSNumberFormatterDecimalStyle;
NSNumber *milesAway = [formatter numberFromString:self.usersMileAwayTextField.text];

if([self.eventNameTextField.text isEqual:@""] || [self.locationTextField.text isEqual:@""] || [self.usersMileAwayTextField.text isEqual:@""] || milesAway == nil) {
    
    NSString *title = @"All fields required";
    NSString *message = @"Please enter an event name, location, and radius and try again.";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                message:message
                                preferredStyle:(UIAlertControllerStyleAlert)];
    // Create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * _Nonnull action) {}];
    
    // Add the OK action to the alert controller
    [alert addAction:okAction];
    
    // Present the alert
    [self presentViewController:alert animated:YES completion:^{}];
} else {
    [SUKEvent postEvent:self.eventNameTextField.text eventLocation:self.locationTextField.text date:(NSDate *) self.timeDatePicker.date usersMilesAway:milesAway withCompletion:^(BOOL succeeded, NSError * error) {
        if (succeeded) {
            NSLog(@"The event was uploaded!");
            
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"Problem uploading the event: %@", error.localizedDescription);
        }
    }];
}*/

@end
