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
        if([self.eventNameTextField.text isEqual:@""] || [self.eventDescriptionTextView.text isEqual:@""]) {
            NSString *title = @"All fields required";
            NSString *message = @"Please enter an event name and an event description and try again.";
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                           message:message
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {}];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:^{}];
        } else {
            SUKChooseEventLocationViewController *chooseLocationVC = [segue destinationViewController];
            chooseLocationVC.currentUserLocation = self.currentUserLocation;
            chooseLocationVC.eventName = self.eventNameTextField.text;
            chooseLocationVC.eventDescription = self.eventDescriptionTextView.text;
            chooseLocationVC.eventDate = self.timeDatePicker.date;
        }
    }
}

@end
