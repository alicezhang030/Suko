//
//  SUKSettingsViewController.m
//  Suko
//
//  Created by Alice Zhang on 8/5/22.
//

#import "SUKSettingsViewController.h"
#import "SUKLoginViewController.h"
#import "Parse/Parse.h"
#import "SUKConstants.h"

@interface SUKSettingsViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *privacySwitch;
@end

@implementation SUKSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Privacy Switch
    NSNumber * currentSetting = [PFUser currentUser][kPFUserUserMapPrivacyKey];
    self.privacySwitch.on = [currentSetting isEqualToNumber:@0] ? YES : NO;
}

- (IBAction)tapUserMapSwitch:(id)sender {
    NSNumber * currentSetting = [PFUser currentUser][kPFUserUserMapPrivacyKey];
    [PFUser currentUser][kPFUserUserMapPrivacyKey] = [currentSetting isEqualToNumber:@1] ? @0 : @1;
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error != nil) {
            NSLog(@"Error saving user's user map privacy settings: %@", error.localizedDescription);
        }
    }];
}

- (IBAction)tapLogout:(id)sender {
    NSLog(@"User tapped log out");
    
    __weak __typeof(self) weakSelf = self;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        __strong __typeof(self) strongSelf = weakSelf;
        if(error != nil) {
            NSString *title = @"Failed to logout";
            NSString *message = error.localizedDescription;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message
                                        preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {}];
            [alert addAction:okAction];
            [strongSelf presentViewController:alert animated:YES completion:^{}];
            
            NSLog(@"Failed to logout: %@", error.localizedDescription);
        } else {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SUKLoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
            strongSelf.view.window.rootViewController = loginVC;
        }
    }];
}

@end
