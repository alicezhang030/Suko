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

@interface SUKAnimeListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation SUKAnimeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.listTitle;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.spinner.hidesWhenStopped = YES;
    self.spinner.layer.cornerRadius = 10;
    [self.spinner setCenter:CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0)];
    [self.spinner startAnimating];
    
    if([self.arrOfAnime count] == 0 && self.arrOfAnimeMALID != nil && self.arrOfAnimeMALID.count > 0){
        __weak __typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            __strong __typeof(self) strongSelf = weakSelf;
            [strongSelf updateArrOfAnime];
        });
    } else {
        [self emptyTableView];
        [self.spinner stopAnimating];
    }
}

- (void)updateArrOfAnime {
    if(self.arrOfAnimeMALID.count == 0) {
        [self emptyTableView];
    }
        
    for(int i = 0; i < self.arrOfAnimeMALID.count; i++) {
        NSNumber *malID = [self.arrOfAnimeMALID objectAtIndex:i];
        
        __weak __typeof(self) weakSelf = self;
        [[SUKAPIManager shared] fetchAnimeWithID:malID completion:^(SUKAnime *anime, NSError *error) {
            __strong __typeof(self) strongSelf = weakSelf;
            if (error == nil) {
                NSMutableArray<SUKAnime *> *currentArrOfAnime = [self.arrOfAnime mutableCopy];
                [currentArrOfAnime addObject:anime];
                strongSelf.arrOfAnime = [currentArrOfAnime copy];
                [strongSelf.tableView reloadData];
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
            
            if(i == strongSelf.arrOfAnimeMALID.count - 1) {
                [strongSelf.spinner stopAnimating];
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
    emptyListMessageLabel.backgroundColor = [UIColor clearColor];
    emptyListMessageLabel.textAlignment = NSTextAlignmentCenter;
    emptyListMessageLabel.textColor = [UIColor blackColor];
    emptyListMessageLabel.numberOfLines = 0;
    emptyListMessageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    emptyListMessageLabel.text = @"No anime in this list yet.";
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
