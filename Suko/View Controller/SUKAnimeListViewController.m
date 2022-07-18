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
    
    // Set up TableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.spinner.hidesWhenStopped = YES;
    [self.spinner startAnimating];
    
    if([self.arrOfAnime count] == 0 && self.arrOfAnimeMALID != nil){
        [self assignArrOfAnimeWithArrOfMALID];
    } else {
        [self.spinner stopAnimating];
    }
}

-(void) assignArrOfAnimeWithArrOfMALID {
    for(int i = 0; i < self.arrOfAnimeMALID.count; i++) {
        NSNumber *malID = [self.arrOfAnimeMALID objectAtIndex:i];
        
        [[SUKAPIManager shared] fetchSpecificAnimeByID:malID completion:^(SUKAnime *anime, NSError *error) {
            if (anime != nil) {
                NSMutableArray *currentArrOfAnime = [self.arrOfAnime mutableCopy];
                [currentArrOfAnime addObject:anime];
                self.arrOfAnime = [currentArrOfAnime copy];
                [self.tableView reloadData];
                
                if(i == self.arrOfAnimeMALID.count - 1) {
                    [self.spinner stopAnimating];
                }
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
        
        [NSThread sleepForTimeInterval:10.0];
    }
}
 
#pragma mark - TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrOfAnime.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SUKAnimeListTableViewCell";
    SUKAnimeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    SUKAnime *animeToDisplay = self.arrOfAnime[indexPath.row];
    
    cell.titleLabel.text = animeToDisplay.title;
    
    NSString *numOfEpString = [NSString stringWithFormat:@"%d", animeToDisplay.episodes];
    cell.numOfEpLabel.text = [numOfEpString stringByAppendingString:@" Episodes"];
    
    NSString *animePosterURLString = animeToDisplay.posterURL;
    NSURL *url = [NSURL URLWithString:animePosterURLString];
    if (url != nil) {
        [cell.posterView setImageWithURL:url];
    }

    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString: @"DetailsSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell: (SUKAnimeListTableViewCell*) sender];
        SUKAnime *dataToPass = self.arrOfAnime[indexPath.row];
        SUKDetailsViewController *detailVC = [segue destinationViewController];
        detailVC.animeToDisplay = dataToPass;
    }
}


@end
