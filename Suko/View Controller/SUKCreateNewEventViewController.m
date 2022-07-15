//
//  SUKCreateNewEventViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/15/22.
//

#import "SUKCreateNewEventViewController.h"
#import "SUKEvent.h"

@interface SUKCreateNewEventViewController ()
@property (weak, nonatomic) IBOutlet UITextField *eventNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *timeDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *usersMileAwayTextField;

@end

@implementation SUKCreateNewEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard{
    [self.eventNameTextField resignFirstResponder];
    [self.locationTextField resignFirstResponder];
    [self.usersMileAwayTextField resignFirstResponder];
}

- (IBAction)tapPostButton:(id)sender {
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
            } else {
                NSLog(@"Problem uploading the event: %@", error.localizedDescription);
            }
        }];
        
    }
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
