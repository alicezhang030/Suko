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
}

- (IBAction)tapPostButton:(id)sender {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *milesAway = [formatter numberFromString:self.usersMileAwayTextField.text];
    
    if(milesAway != nil) {
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
