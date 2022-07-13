//
//  SUKProfileViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/12/22.
//

#import "SUKProfileViewController.h"
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"
#import "SUKLoginViewController.h"

@interface SUKProfileViewController () 
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end

@implementation SUKProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Load the user profile image
    self.profileImageView.file = [PFUser currentUser][@"profile_image"];
    [self.profileImageView loadInBackground];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height /2;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.borderWidth = 0;
    
    // Load the username
    self.usernameLabel.text = [@"@" stringByAppendingString:[PFUser currentUser].username];
}

- (IBAction)tapLogout:(id)sender {
    NSLog(@"User tapped log out");
    
    // Reset view to the log in screen
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SUKLoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        self.view.window.rootViewController = loginVC;
    }];
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
