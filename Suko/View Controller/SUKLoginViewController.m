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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (IBAction)tapLoginButton:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [self checkEmptyField];

    __weak __typeof(self) weakSelf = self;
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            __strong __typeof(self) strongSelf = weakSelf;
            NSLog(@"User logged in successfully");
            // Display view controller that needs to shown after successful login
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SUKHomeViewController *homeVC = [storyboard instantiateViewControllerWithIdentifier:@"SUKTabController"];
            strongSelf.view.window.rootViewController = homeVC;
        }
    }];
}

- (IBAction)tapSignupButton:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SUKSignUpViewController *signupVC = [storyboard instantiateViewControllerWithIdentifier:@"SignUpVC"];
    self.view.window.rootViewController = signupVC;
}

- (void)checkEmptyField {
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

@end
