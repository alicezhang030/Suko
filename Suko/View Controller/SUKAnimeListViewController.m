//
//  SUKAnimeListViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/7/22.
//

#import "SUKAnimeListViewController.h"
#import "SUKAPIManager.h"
#import "UIImageView+AFNetworking.h"
#import "SUKAnimeListTableViewCell.h"
#import "SUKAnime.h"
#import "SUKDetailsViewController.h"
#import "UIScrollView+SVInfiniteScrolling.h"

@interface SUKAnimeListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, assign) int currentLoadStartingIndex;
@property (nonatomic, strong) NSMutableSet<NSNumber *> *loadedMALIDs;
@end

@implementation SUKAnimeListViewController

int const kNumAnimePerLoad = 5;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Navigation title
    self.navigationItem.title = self.listTitle;
    
    // Table View
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // Spinner
    self.spinner.hidesWhenStopped = YES;
    self.spinner.layer.cornerRadius = 10;
    [self.spinner setCenter:CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0)];
    
    // Properties
    self.currentLoadStartingIndex = 0;
    self.loadedMALIDs = [NSMutableSet new];
    
    // Infinite scroll
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        self.currentLoadStartingIndex = self.currentLoadStartingIndex + kNumAnimePerLoad;
        __weak __typeof(self) weakSelf = self;
        
        if(self.arrOfAnime.count < (int)self.arrOfAnimeMALID.count) { // If haven't loaded everything in the list yet
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                __strong __typeof(self) strongSelf = weakSelf;
                [strongSelf setArrOfAnimeWithArrOfMALIDs];
            });
        } else { // Have loaded everything in the list
            [self.tableView.infiniteScrollingView stopAnimating];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    // Since the app adds to the data arr even when the page is not visible,
    // we need to reload the table view to display the anime that were loaded while the page wasn't visible
    [self.tableView reloadData];
    
    if ((self.arrOfAnimeMALID != nil && self.arrOfAnimeMALID.count <= 0) || (self.arrOfAnimeMALID == nil && self.arrOfAnime != nil && self.arrOfAnime.count <= 0)) {
        [self emptyTableView];
    } else if(self.arrOfAnime.count < (int)self.arrOfAnimeMALID.count){
        [self.spinner startAnimating];
        __weak __typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            __strong __typeof(self) strongSelf = weakSelf;
            [strongSelf setArrOfAnimeWithArrOfMALIDs];
        });
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.spinner stopAnimating];
}

# pragma mark - Data

- (void)setArrOfAnimeWithArrOfMALIDs {
    // Set the ending loop index
    int endingLoopIndex = 0;
    if(self.currentLoadStartingIndex + kNumAnimePerLoad < (int)self.arrOfAnimeMALID.count) { // Not the last load for the entire list yet
        endingLoopIndex = self.currentLoadStartingIndex + kNumAnimePerLoad;
    } else { // Last load for the entire list
        endingLoopIndex = (int)self.arrOfAnimeMALID.count;
    }
        
    // Load the data into ArrOfAnime
    for(int i = self.currentLoadStartingIndex; i < endingLoopIndex; i++) {
        NSNumber *malID = [self.arrOfAnimeMALID objectAtIndex:i];
        
        __weak __typeof(self) weakSelf = self;
        [[SUKAPIManager shared] fetchAnimeWithID:malID completion:^(SUKAnime *anime, NSError *error) {
            __strong __typeof(self) strongSelf = weakSelf;
            
            if(error != nil) {
                NSLog(@"Error fetching anime with ID: %@, %@", [malID stringValue], error.localizedDescription);
            } else if (![strongSelf.loadedMALIDs containsObject:[NSNumber numberWithInt:anime.malID]]) {
                [strongSelf.loadedMALIDs addObject:[NSNumber numberWithInt:anime.malID]];
                NSMutableArray<SUKAnime *> *currentArrOfAnime = [self.arrOfAnime mutableCopy];
                [currentArrOfAnime addObject:anime];
                strongSelf.arrOfAnime = [currentArrOfAnime copy];
            }
            
            if(i == endingLoopIndex - 1) {
                [strongSelf.tableView reloadData];
                [strongSelf.spinner stopAnimating];
                [strongSelf.tableView.infiniteScrollingView stopAnimating];
            }
        }];
        
        [NSThread sleepForTimeInterval:1.2];
    }
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrOfAnime.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SUKAnimeListTableViewCell";
    SUKAnimeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    SUKAnime *animeToDisplay = self.arrOfAnime[indexPath.row];
    
    cell.titleLabel.text = animeToDisplay.title;
    
    NSString *numOfEpString = [NSString stringWithFormat:@"%d", animeToDisplay.numEpisodes];
    cell.numOfEpLabel.text = [numOfEpString stringByAppendingString:@" Episodes"];
    
    NSString *animePosterURLString = animeToDisplay.posterURL;
    NSURL *url = [NSURL URLWithString:animePosterURLString];
    if (url != nil) {
        [cell.posterView setImageWithURL:url];
    }
    
    return cell;
}

- (void)emptyTableView {
    UILabel *emptyListMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 70, self.tableView.bounds.size.width/2, self.tableView.bounds.size.height/2)];
    emptyListMessageLabel.textAlignment = NSTextAlignmentCenter;
    emptyListMessageLabel.numberOfLines = 0;
    emptyListMessageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    emptyListMessageLabel.text = @"No anime to display.";
    self.tableView.backgroundView = emptyListMessageLabel;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString: @"DetailsSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell: (SUKAnimeListTableViewCell *) sender];
        SUKAnime *dataToPass = self.arrOfAnime[indexPath.row];
        SUKDetailsViewController *detailVC = [segue destinationViewController];
        detailVC.animeToDisplay = dataToPass;
    }
}

@end
