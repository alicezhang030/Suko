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
#import "SUKEditProfileViewController.h"

@interface SUKProfileViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (nonatomic, strong) UIBarButtonItem *logoutButton;

@end

@implementation SUKProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.userToDisplay == nil) {
        self.userToDisplay = [PFUser currentUser];
    }
    
    self.logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(tapLogout)];
    NSMutableArray* currentRightBarItemsMutable = [self.navigationItem.rightBarButtonItems mutableCopy];
    [currentRightBarItemsMutable addObject:self.logoutButton];
    self.navigationItem.rightBarButtonItems = [currentRightBarItemsMutable copy];
    
    // Hides log out and edit buttons if the user being displayed is not the current user
    if(![self.userToDisplay.objectId isEqualToString:[PFUser currentUser].objectId]) {
        for(UIBarButtonItem *rightButton in self.navigationItem.rightBarButtonItems) {
            rightButton.tintColor = [UIColor clearColor];
            rightButton.enabled = NO;
        }
    }
    
    [self loadContents];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadContents];
}

-(void) loadContents {
    // Load the user profile image
    self.profileImageView.file = self.userToDisplay[@"profile_image"];
    [self.profileImageView loadInBackground];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height /2;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.borderWidth = 0;
    
    // Load the username
    self.usernameLabel.text = [@"@" stringByAppendingString:self.userToDisplay.username];
}

-(void) tapLogout {
    NSLog(@"User tapped log out");
    
    // Reset view to the log in screen
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SUKLoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        self.view.window.rootViewController = loginVC;
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ProfileToEditProfileSegue"]) {
        UINavigationController *navController = segue.destinationViewController;
        SUKEditProfileViewController *editVC =  (SUKEditProfileViewController*)navController.topViewController;
        editVC.userToDisplay = self.userToDisplay;
    }
}

@end
