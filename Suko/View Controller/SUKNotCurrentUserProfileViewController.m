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

@interface SUKNotCurrentUserProfileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (nonatomic, strong) NSArray<NSString *> *listTitles;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *followButton;


@end

@implementation SUKNotCurrentUserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up TableView
    self.listTitles = [PFUser currentUser][@"list_titles"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
        
    [self loadContents];
}

- (void)loadContents {
    self.profileImageView.file = self.userToDisplay[@"profile_image"];
    [self.profileImageView loadInBackground];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height /2;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.borderWidth = 0;
    
    self.usernameLabel.text = [@"@" stringByAppendingString:self.userToDisplay.username];
    
    if([self.userToDisplay.objectId isEqualToString:[PFUser currentUser].objectId]) {
        [self.followButton removeFromSuperview];
    } else {
        self.followButton.layer.cornerRadius = 4;
        self.followButton.layer.masksToBounds = true;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"SUKFollow"];
    [query whereKey:@"follower" equalTo:[PFUser currentUser]];
    [query whereKey:@"userBeingFollowed" equalTo:self.userToDisplay];
    
    __weak __typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray<SUKFollow *> *follows, NSError *error) {
        __strong __typeof(self) strongSelf = weakSelf;
        if([follows count] > 1) {
            NSLog(@"Error: More than one follow relationship between current user and user being displayed");
        } else if([follows count] == 1) {
            [strongSelf.followButton setTitle:@"Following" forState:UIControlStateNormal];
        } else {
            [strongSelf.followButton setTitle:@"Follow" forState:UIControlStateNormal];
        }
    }];
}

- (IBAction)tapFollowButton:(id)sender {
    // Check if current user is already following self.userToDisplay
    PFQuery *query = [PFQuery queryWithClassName:@"SUKFollow"];
    [query whereKey:@"follower" equalTo:[PFUser currentUser]];
    [query whereKey:@"userBeingFollowed" equalTo:self.userToDisplay];
    
    __weak __typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray<SUKFollow *> *follows, NSError *error) {
        __strong __typeof(self) strongSelf = weakSelf;
        if([follows count] > 1) {
            NSLog(@"Error: More than one follow relationship between current user and user being displayed");
        } else if([follows count] == 1) {
            [SUKFollow deleteFollow:[follows lastObject]];
            [strongSelf.followButton setTitle:@"Follow" forState:UIControlStateNormal];
        } else {
            [SUKFollow postFollowWithFollower:[PFUser currentUser] userBeingFollowed:self.userToDisplay withCompletion:^(BOOL succeeded, NSError * error) {
                __strong __typeof(self) strongSelf = weakSelf;
                if (succeeded) {
                    NSLog(@"The follow was uploaded!");
                    [strongSelf.followButton setTitle:@"Following" forState:UIControlStateNormal];
                } else {
                    NSLog(@"Problem uploading the event: %@", error.localizedDescription);
                }
            }];
        }
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
        animeListVC.arrOfAnimeMALID = self.userToDisplay[@"list_data"][indexPath.row];
        animeListVC.arrOfAnime = [NSMutableArray new];
    }
}

@end
