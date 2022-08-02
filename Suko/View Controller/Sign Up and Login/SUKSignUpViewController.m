//
//  SUKSignUpViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/8/22.
//

#import "SUKSignUpViewController.h"
#import "Parse/Parse.h"
#import "SUKHomeViewController.h"
#import "SUKLoginViewController.h"

@interface SUKSignUpViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation SUKSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard{
    [self.emailField resignFirstResponder];
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (void)tapSignUpButton:(id)sender {
    // Initialize a user object
    PFUser *newUser = [PFUser user];
        
    // Set user properties
    newUser.email = self.emailField.text;
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    
    newUser[@"list_titles"] = [NSMutableArray new];
    [newUser[@"list_titles"] addObject:@"Want to Watch"];
    [newUser[@"list_titles"] addObject:@"Watching"];
    [newUser[@"list_titles"] addObject:@"Watched"];
    
    newUser[@"follower_arr"] = [NSArray new];
    
    newUser[@"list_data"] = [NSMutableArray new];
    for(int i = 0; i < [newUser[@"list_titles"] count]; i++) {
        [newUser[@"list_data"] addObject:[NSMutableArray new]];
    }
    
    [self checkEmptyField];
    
    __weak __typeof(self) weakSelf = self;
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSString *title = @"Signup failed";
            NSString *message = [error.localizedDescription stringByAppendingString:@" Please try again."];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message
                                        preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {}];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:^{}];
            
            NSLog(@"User sign up failed: %@", error.localizedDescription);
        } else {
            __strong __typeof(self) strongSelf = weakSelf;
            NSLog(@"User registered successfully");
            // Display view controller that needs to shown after successful login
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SUKHomeViewController *homeVC = [storyboard instantiateViewControllerWithIdentifier:@"SUKTabController"];
            strongSelf.view.window.rootViewController = homeVC;
        }
    }];
}

- (IBAction)tapLogInButton:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SUKLoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    self.view.window.rootViewController = loginVC;
}

- (void)checkEmptyField {
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

@end
