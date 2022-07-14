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

@interface SUKNotCurrentUserProfileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (nonatomic, strong) NSArray *listTitles;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SUKNotCurrentUserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up TableView
    self.listTitles = @[@"Want to Watch", @"Watching", @"Watched"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"NotCurrentUserProfileToListSegue"]) {
        SUKAnimeListViewController *animeListVC = [segue destinationViewController];
        SUKLibraryTableViewCell *cell = sender;
        animeListVC.listTitle = cell.listTitleLabel.text;
        animeListVC.userToDisplay = self.userToDisplay;
        animeListVC.arrOfAnime = [NSMutableArray array];
    }
}

@end
