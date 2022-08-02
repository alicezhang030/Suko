//
//  SUKNotCurrentUserProfileViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/14/22.
//

#import "SUKNotCurrentUserProfileViewController.h"
#import "Parse/PFImageView.h"
#import "SUKLibraryTableViewCell.h"
#import "SUKAnimeListViewController.h"
#import "SUKAPIManager.h"
#import "SUKFollow.h"
#import "SUKConstants.h"

@interface SUKNotCurrentUserProfileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *backdropImageView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *blurView;
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (nonatomic, strong) NSArray<NSString *> *listTitles;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (nonatomic, strong) UIRefreshControl *refreshControl; //pull down and refresh the page
@end

@implementation SUKNotCurrentUserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
        
    // Blur view
    self.blurView.alpha = 0;
    
    // Load contents
    [self loadContents];
    
    // Refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadContents) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)loadContents {
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"objectId" equalTo:self.userToDisplay.objectId];
    
    __weak __typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray<PFUser *> *users, NSError *error) {
        if(users.count != 1) {
            NSLog(@"Error: The number of users with this ID isn't one. Number of users with this ID: %lu", users.count);
        } else {
            __strong __typeof(self) strongSelf = weakSelf;

            PFUser *displayedUser = [users lastObject];
            
            strongSelf.listTitles = displayedUser[kPFUserListTitlesKey];
            [strongSelf.tableView reloadData];
            
            strongSelf.profileImageView.file = displayedUser[kPFUserProfileImageKey];
            [strongSelf.profileImageView loadInBackground];
            strongSelf.profileImageView.layer.cornerRadius = strongSelf.profileImageView.frame.size.height /2;
            strongSelf.profileImageView.layer.masksToBounds = YES;
            strongSelf.profileImageView.layer.borderWidth = 0;
            
            strongSelf.backdropImageView.file = displayedUser[kPFUserProfileBackdropKey];
            [strongSelf.backdropImageView loadInBackground];
            
            strongSelf.usernameLabel.text = [@"@" stringByAppendingString:displayedUser.username];
            
            if([displayedUser.objectId isEqualToString:[PFUser currentUser].objectId]) {
                [strongSelf.followButton removeFromSuperview];
            } else {
                strongSelf.followButton.layer.cornerRadius = 4;
                strongSelf.followButton.layer.masksToBounds = true;
            }
            
            PFQuery *query = [PFQuery queryWithClassName:@"SUKFollow"];
            [query whereKey:kSUKFollowFollowersKey equalTo:[PFUser currentUser]];
            [query whereKey:kSUKFollowUserBeingFollowedKey equalTo:displayedUser];
            
            [query findObjectsInBackgroundWithBlock:^(NSArray<SUKFollow *> *follows, NSError *error) {
                if(error != nil) {
                    NSLog(@"Failed to fetch follow relationship: %@", error.localizedDescription);
                } else if([follows count] > 1) {
                    NSLog(@"Error: More than one follow relationship between current user and user being displayed");
                } else if([follows count] == 1) {
                    [strongSelf.followButton setTitle:@"Following" forState:UIControlStateNormal];
                } else {
                    [strongSelf.followButton setTitle:@"Follow" forState:UIControlStateNormal];
                }
                
                [self.refreshControl endRefreshing];
            }];
        }
    }];
}

- (IBAction)tapFollowButton:(id)sender {
    // Check if current user is already following self.userToDisplay
    PFQuery *query = [PFQuery queryWithClassName:@"SUKFollow"];
    [query whereKey:@"follower" equalTo:[PFUser currentUser]];
    [query whereKey:kSUKFollowUserBeingFollowedKey equalTo:self.userToDisplay];
    
    __weak __typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray<SUKFollow *> *follows, NSError *error) {
        __strong __typeof(self) strongSelf = weakSelf;
        if([follows count] > 1) {
            NSLog(@"Error: More than one follow relationship between current user and user being displayed");
            [self.refreshControl endRefreshing];
        } else if([follows count] == 1) {
            [SUKFollow deleteFollow:[follows lastObject]];
            [strongSelf.followButton setTitle:@"Follow" forState:UIControlStateNormal];
        } else {
            [SUKFollow postFollowWithFollower:[PFUser currentUser] userBeingFollowed:self.userToDisplay withCompletion:^(BOOL succeeded, NSError * error) {
                if(error != nil) {
                    NSLog(@"Problem uploading the event: %@", error.localizedDescription);
                } else {
                    NSLog(@"The follow was uploaded!");
                    __strong __typeof(self) strongSelf = weakSelf;
                    [strongSelf.followButton setTitle:@"Following" forState:UIControlStateNormal];
                }
            }];
        }
    }];
}

#pragma mark - Animation

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //self.blurView.alpha = 1;
    [UIView animateWithDuration:0.5 animations:^{
        self.blurView.alpha = 1;
        self.backdropImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        self.blurView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [UIView animateWithDuration:0.5 animations:^{
        self.blurView.alpha = 0;
        self.backdropImageView.transform = CGAffineTransformIdentity;
        self.blurView.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listTitles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SUKLibraryTableViewCell";
    SUKLibraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.listTitleLabel.text = self.listTitles[indexPath.row];
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"NotCurrentUserProfileToListSegue"]) {
        SUKAnimeListViewController *animeListVC = [segue destinationViewController];
        SUKLibraryTableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        animeListVC.listTitle = cell.listTitleLabel.text;
        animeListVC.arrOfAnimeMALID = self.userToDisplay[kPFUserListDataKey][indexPath.row];
        animeListVC.arrOfAnime = [NSMutableArray new];
    }
}

@end
