//
//  SUKLoginViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/8/22.
//

#import "SUKLoginViewController.h"
#import "Parse/Parse.h"
#import "SUKHomeViewController.h"
#import "SUKSignUpViewController.h"

@interface SUKLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation SUKLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)tapLoginButton:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [self checkEmptyField];

    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            // Display view controller that needs to shown after successful login
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SUKHomeViewController *homeVC = [storyboard instantiateViewControllerWithIdentifier:@"SUKTabController"];
            self.view.window.rootViewController = homeVC;
        }
    }];
}

- (IBAction)tapSignupButton:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SUKSignUpViewController *signupVC = [storyboard instantiateViewControllerWithIdentifier:@"SignUpVC"];
    self.view.window.rootViewController = signupVC;
}

- (void) checkEmptyField {
    if([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]) {
        
        NSString *title = @"All fields required";
        NSString *message = @"Please enter a username and password and try again.";
        
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