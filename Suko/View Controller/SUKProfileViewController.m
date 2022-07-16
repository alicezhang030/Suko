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

@interface SUKProfileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (nonatomic, strong) UIBarButtonItem *logoutButton;
@property (nonatomic, strong) NSArray *listTitles;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *animeToPass;

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
    NSMutableArray* currentRightBarItemsMutable = [self.navigationItem.rightBarButtonItems mutableCopy];
    [currentRightBarItemsMutable addObject:self.logoutButton];
    self.navigationItem.rightBarButtonItems = [currentRightBarItemsMutable copy];
    
    self.animeToPass = [NSMutableArray array];
    
    [self loadContents];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadContents];
}

-(void) loadContents {
    // Load the user profile image
    self.profileImageView.file = [PFUser currentUser][@"profile_image"];
    [self.profileImageView loadInBackground];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height /2;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.borderWidth = 0;
    
    // Load the username
    self.usernameLabel.text = [@"@" stringByAppendingString:[PFUser currentUser].username];
}

#pragma mark - TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listTitles count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SUKLibraryTableViewCell";
    SUKLibraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.listTitleLabel.text = self.listTitles[indexPath.row];
    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.animeToPass removeAllObjects];
    NSArray *arrOfMalID = [PFUser currentUser][@"list_data"][indexPath.row];
    
    if(arrOfMalID.count == 0) {
        [self performSegueWithIdentifier:@"ProfileToListSegue" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
    }
    
    for(int i = 0; i < arrOfMalID.count; i++) {
        NSNumber *malID = [arrOfMalID objectAtIndex:i];
        [[SUKAPIManager shared] fetchSpecificAnimeByID:malID completion:^(SUKAnime *anime, NSError *error) {
             if (anime != nil) {
                 [self.animeToPass addObject:anime];
                 if(i == arrOfMalID.count - 1) {
                     [self performSegueWithIdentifier:@"ProfileToListSegue" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
                 }
             } else {
                 NSLog(@"%@", error.localizedDescription);
             }
         }];
        
        [NSThread sleepForTimeInterval:0.4];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ProfileToEditProfileSegue"]) {
        UINavigationController *navController = segue.destinationViewController;
        SUKEditProfileViewController *editVC =  (SUKEditProfileViewController*)navController.topViewController;
    }
    
    if([segue.identifier isEqualToString:@"ProfileToListSegue"]) {
        SUKAnimeListViewController *animeListVC = [segue destinationViewController];
        SUKLibraryTableViewCell *cell = sender;
        animeListVC.listTitle = cell.listTitleLabel.text;
        animeListVC.userToDisplay = [PFUser currentUser];
        animeListVC.arrOfAnime = self.animeToPass;
    }
}

@end
