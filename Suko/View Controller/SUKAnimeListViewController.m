//
//  SUKAnimeListViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/7/22.
//

#import "SUKAnimeListViewController.h"
#import "SUKAPIManager.h"
#import "SUKAnimeListTableViewCell.h"
#import "SUKAnime.h"
#import "SUKDetailsViewController.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "SUKHomeViewController.h"
#import "SUKConstants.h"
#import "Parse/Parse.h"

@interface SUKAnimeListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, assign) int currentLoadStartingIndex;
@property (nonatomic, strong) NSMutableSet<NSNumber *> *loadedMALIDs;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trashBarButton;
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
    
    // Trash Bar Button
    NSArray<UIViewController *> *viewControllers = [self.navigationController viewControllers];
    NSArray<NSString *> *defaultListTitles = [NSArray arrayWithObjects: @"want to watch", @"watching", @"watched", nil];
    if([viewControllers[0] isKindOfClass:[SUKHomeViewController class]] || [defaultListTitles containsObject: self.listTitle.lowercaseString]) {
        [self.trashBarButton setEnabled:NO];
        [self.trashBarButton setTintColor: [UIColor clearColor]];
    }
    
    if ((self.arrOfAnimeMALID != nil && self.arrOfAnimeMALID.count <= 0) || (self.arrOfAnimeMALID == nil && self.arrOfAnime != nil && self.arrOfAnime.count <= 0)) {
        NSMutableArray<SUKAnime *> *currentArrOfAnime = [self.arrOfAnime mutableCopy];
        [currentArrOfAnime removeAllObjects];
        self.arrOfAnime = currentArrOfAnime;
        [self.loadedMALIDs removeAllObjects];
        
        [self emptyTableView];
        [self.tableView reloadData];
    } else if(self.arrOfAnime.count < (int)self.arrOfAnimeMALID.count){
        [self.spinner startAnimating];
        self.tableView.backgroundView = nil;
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
                if (strongSelf.arrOfAnime.count <= 0) {
                    [strongSelf emptyTableView];
                    [strongSelf.tableView reloadData];
                }
                
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
    [cell configureCellWithAnime:animeToDisplay];
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

#pragma mark - Trash

- (IBAction)tappedTrash:(id)sender {
    NSMutableArray<NSString *> *currentListTitles = [PFUser currentUser][kPFUserListTitlesKey];
    NSMutableArray<NSMutableArray *> *currentListData = [PFUser currentUser][kPFUserListDataKey];
    
    int indexOfList = (int)[currentListTitles indexOfObject:self.listTitle];
    [currentListTitles removeObjectAtIndex:indexOfList];
    [currentListData removeObjectAtIndex:indexOfList];
    
    [PFUser currentUser][kPFUserListTitlesKey] = currentListTitles;
    [PFUser currentUser][kPFUserListDataKey] = currentListData;
    
    __weak __typeof(self) weakSelf = self;
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        __strong __typeof(self) strongSelf = weakSelf;
        if(error != nil) {
            NSLog(@"Error deleting list: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully deleted list.");
            
            NSArray<UIViewController *> *viewControllers = [strongSelf.navigationController viewControllers];
            [strongSelf.navigationController popToViewController:viewControllers[0] animated:YES]; // Navigate back to original library VC
        }
    }];
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
