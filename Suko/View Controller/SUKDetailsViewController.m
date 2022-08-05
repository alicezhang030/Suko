//
//  SUKDetailsViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/8/22.
//

#import "SUKDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "SUKConstants.h"
#import "SUKReviewTableViewCell.h"
#import "SUKReview.h"
#import "SUKCreateReviewViewController.h"

@interface SUKDetailsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfEpLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet MKDropdownMenu *dropdownMenu;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<NSString *> *listOptions;

@property (strong, nonatomic) NSArray<SUKReview *> *reviews;
@property (weak, nonatomic) IBOutlet UIButton *leaveReviewButton;
@end

@implementation SUKDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Anime Contents
    NSString *animePosterURLString = self.animeToDisplay.posterURL;
    NSURL *url = [NSURL URLWithString:animePosterURLString];
    if(url != nil) {
        [self.posterView setImageWithURL:url];
    }
    
    self.titleLabel.text = self.animeToDisplay.title;
    self.synopsisLabel.text = self.animeToDisplay.synopsis;
    NSString *numOfEpString = [NSString stringWithFormat:@"%d", self.animeToDisplay.numEpisodes];
    self.numOfEpLabel.text = [numOfEpString stringByAppendingString:@" Episodes"];
    
    // Dropdown Menu
    self.listOptions = [@[@"Remove from lists"] mutableCopy];
    [self.listOptions addObjectsFromArray: [PFUser currentUser][kPFUserListTitlesKey]];
    self.dropdownMenu.backgroundDimmingOpacity = 0.00;
    self.dropdownMenu.dropdownCornerRadius = 4.0;
    self.dropdownMenu.layer.cornerRadius = 4;
    self.dropdownMenu.layer.masksToBounds = true;
    
    // Tableview
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Leave a review Button
    self.leaveReviewButton.layer.cornerRadius = 4;
    self.leaveReviewButton.layer.masksToBounds = true;
}

- (void)viewWillAppear:(BOOL)animated {
    self.listOptions = [@[@"Remove from lists"] mutableCopy];
    [self.listOptions addObjectsFromArray: [PFUser currentUser][kPFUserListTitlesKey]];
    
    PFQuery *query = [PFQuery queryWithClassName:@"SUKReview"];
    [query includeKey:@"author"];
    [query whereKey:@"animeID" equalTo:[NSNumber numberWithInt:self.animeToDisplay.malID]];
    
    __weak __typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray<SUKReview *> *reviews, NSError *error) {
        __strong __typeof(self) strongSelf = weakSelf;
        if(error != nil) {
            NSLog(@"Error loading this anime's reviews: %@", error.localizedDescription);
        } else {
            strongSelf.reviews = reviews;
            [strongSelf.tableView reloadData];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];

  if(self.isMovingFromParentViewController) {
      [self.dropdownMenu closeAllComponentsAnimated:YES];
  }
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reviews.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SUKReviewTableViewCell";
    SUKReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell configureCellWithReview:self.reviews[indexPath.row]];
    return cell;
}


#pragma mark - MKDropdownMenuDataSource

- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu {
    return 1;
}

- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component {
    return self.listOptions.count;
}

#pragma mark - MKDropdownMenuDelegate

- (NSString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu titleForComponent:(NSInteger)component {
    return @"Add to list";
}
- (NSString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.listOptions[row];
}

- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSMutableArray<NSMutableArray *> *currentUserListData = [PFUser currentUser][kPFUserListDataKey];
    NSNumber *malID = [NSNumber numberWithInt:self.animeToDisplay.malID];
    
    if(row == 0) { // User clicked on "remove from lists"
        for(int i = 0; i < [currentUserListData count]; i++) {
            if([currentUserListData[i] containsObject:malID]) {
                [currentUserListData[i] removeObject:malID];
                break;
            }
        }
    } else {
        for(int i = 0; i < [currentUserListData count]; i++) {
            // row - 1 because row 0 is "Remove from List"
            if([currentUserListData[i] containsObject:malID]) {
                [currentUserListData[i] removeObject:malID];
                break;
            }
        }
        [currentUserListData[row-1] addObject:malID];
    }
    
    [PFUser currentUser][kPFUserListDataKey] = currentUserListData;
    [[PFUser currentUser] saveInBackground];
    [self.dropdownMenu closeAllComponentsAnimated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:kDetailsToCreateReviewSegue]) {
        SUKCreateReviewViewController *createReviewVC = [segue destinationViewController];
        [createReviewVC configureViewWithAnime:self.animeToDisplay];
    }
}

@end
