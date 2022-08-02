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
#import "SUKLibraryTableViewCell.h"
#import "SUKAnimeListViewController.h"
#import "SUKAPIManager.h"

@interface SUKProfileViewController () <UITableViewDataSource, UITableViewDelegate, SUKEditProfileDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet PFImageView *backdropImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (nonatomic, strong) UIBarButtonItem *logoutButton;
@property (nonatomic, strong) NSArray<NSString *> *listTitles;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SUKProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up TableView
    self.listTitles = [PFUser currentUser][@"list_titles"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(tapLogout)];
    NSMutableArray<UIBarButtonItem *>* currentRightBarItemsMutable = [self.navigationItem.rightBarButtonItems mutableCopy];
    [currentRightBarItemsMutable addObject:self.logoutButton];
    self.navigationItem.rightBarButtonItems = [currentRightBarItemsMutable copy];
        
    [self loadContents];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadContents];
}

- (void)userFinishedEditingProfile {
    [self loadContents];
}

- (void)loadContents {
    // Load the user profile image and backdrop
    self.profileImageView.file = [PFUser currentUser][@"profile_image"];
    [self.profileImageView loadInBackground];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height /2;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.borderWidth = 0;
    
    self.backdropImageView.file = [PFUser currentUser][@"profile_backdrop"];
    [self.backdropImageView loadInBackground];
    
    // Load the username
    self.usernameLabel.text = [@"@" stringByAppendingString:[PFUser currentUser].username];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listTitles count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SUKLibraryTableViewCell";
    SUKLibraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.listTitleLabel.text = self.listTitles[indexPath.row];
    return cell;
}

- (void)tapLogout {
    NSLog(@"User tapped log out");
    
    __weak __typeof(self) weakSelf = self;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if(error != nil) {
            NSString *title = @"Failed to logout";
            NSString *message = error.localizedDescription;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message
                                        preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {}];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:^{}];
            
            NSLog(@"Failed to logout: %@", error.localizedDescription);
        } else {
            __strong __typeof(self) strongSelf = weakSelf;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SUKLoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
            strongSelf.view.window.rootViewController = loginVC;
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ProfileToListSegue"]) {
        SUKAnimeListViewController *animeListVC = [segue destinationViewController];
        SUKLibraryTableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        animeListVC.listTitle = cell.listTitleLabel.text;
        animeListVC.arrOfAnimeMALID = [PFUser currentUser][@"list_data"][indexPath.row];
        animeListVC.arrOfAnime = [NSMutableArray new];
    }
    
    if([segue.identifier isEqualToString:@"ProfileToEditProfileSegue"]) {
        UINavigationController *navController = [segue destinationViewController];
        SUKEditProfileViewController *editProfileVC = (SUKEditProfileViewController *)([navController viewControllers][0]);
        editProfileVC.delegate = self;
    }
}

@end
