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

NSString * const kListTitlesDictionaryKey = @"list_titles";
NSString * const kListDataDictionaryKey = @"list_data";
NSString * const kFollowerArrDictionaryKey = @"follower_arr";

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
    
    newUser[kListTitlesDictionaryKey] = [NSMutableArray new];
    [newUser[kListTitlesDictionaryKey] addObject:@"Want to Watch"];
    [newUser[kListTitlesDictionaryKey] addObject:@"Watching"];
    [newUser[kListTitlesDictionaryKey] addObject:@"Watched"];
    
    newUser[kFollowerArrDictionaryKey] = [NSArray new];
    
    newUser[kListDataDictionaryKey] = [NSMutableArray new];
    for(int i = 0; i < [newUser[kListTitlesDictionaryKey] count]; i++) {
        [newUser[kListDataDictionaryKey] addObject:[NSMutableArray new]];
    }
    
    [self checkEmptyField];
    
    __weak __typeof(self) weakSelf = self;
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        __strong __typeof(self) strongSelf = weakSelf;
        if (error != nil) {
            NSString *title = @"Signup failed";
            NSString *message = [error.localizedDescription stringByAppendingString:@" Please try again."];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message
                                        preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {}];
            [alert addAction:okAction];
            [strongSelf presentViewController:alert animated:YES completion:^{}];
            
            NSLog(@"User sign up failed: %@", error.localizedDescription);
        } else {
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
