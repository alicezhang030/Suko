//
//  SUKSignUpViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/8/22.
//

#import "SUKSignUpViewController.h"
#import "Parse/Parse.h"
#import "SUKHomeViewController.h"

@interface SUKSignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation SUKSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)tapSignUpButton:(id)sender {
    // Initialize a user object
    PFUser *newUser = [PFUser user];
        
    // Set user properties
    newUser.email = self.emailField.text;
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    
    [self checkEmptyField];
    
    // Call sign up function on the object
    /*
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            // Display view controller that needs to shown after successful login
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SUKHomeViewController *homeVC = [storyboard instantiateViewControllerWithIdentifier:@"SUKTabController"];
            self.view.window.rootViewController = homeVC;
            //[self performSegueWithIdentifier:@"loginSignUpSegue" sender:nil];
        }
    }];*/
}

- (void) checkEmptyField {
    if([self.emailField.text isEqual:@""] || [self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]) {
        
        NSString *title = @"All fields required";
        NSString *message = @"Please enter an email, username, and password and try again.";
        
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
