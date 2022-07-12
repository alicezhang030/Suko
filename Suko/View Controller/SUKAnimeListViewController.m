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
#import "SUKUsersLists.h"

@interface SUKAnimeListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SUKAnimeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = self.listTitle;
    
    // Set up TableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    if([self.listTitle.lowercaseString isEqualToString:@"want to watch"]) {
        [self updateDictionaryOfAnime:DefaultLibraryListsWantToWatch];
    } else if ([self.listTitle.lowercaseString isEqualToString:@"watching"]){
        [self updateDictionaryOfAnime:DefaultLibraryListsWatching];
    } else if ([self.listTitle.lowercaseString isEqualToString:@"watched"]){
        [self updateDictionaryOfAnime:DefaultLibraryListsWatched];
    }
}
 
- (void) updateDictionaryOfAnime:(DefaultLibraryLists) listTitle {
    PFQuery *query = [PFQuery queryWithClassName:@"SUKUsersLists"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray<SUKUsersLists*> *usersLists, NSError *error) {
        if(usersLists.count > 1) {
            NSLog(@"More than one entry for this user in the database");
        } else if (usersLists.count == 1) {
            SUKUsersLists *usersListObj = [usersLists objectAtIndex:0];
                        
            switch(listTitle) {
                case DefaultLibraryListsWantToWatch:
                    for(NSNumber *malID in usersListObj.wantToWatchArr) {
                        [[SUKAPIManager shared] fetchSpecificAnimeByID:malID completion:^(SUKAnime *anime, NSError *error) {
                             if (anime != nil) {
                                 [self.arrOfAnime addObject:anime];
                                 [self.tableView reloadData];
                             } else {
                                 NSLog(@"%@", error.localizedDescription);
                             }
                         }];
                        [NSThread sleepForTimeInterval:0.4];
                    }
                    break;
                case DefaultLibraryListsWatching:
                    for(NSNumber *malID in usersListObj.watchingArr) {
                        [[SUKAPIManager shared] fetchSpecificAnimeByID:malID completion:^(SUKAnime *anime, NSError *error) {
                             if (anime != nil) {
                                 [self.arrOfAnime addObject:anime];
                                 [self.tableView reloadData];
                             } else {
                                 NSLog(@"%@", error.localizedDescription);
                             }
                         }];
                        [NSThread sleepForTimeInterval:0.4];
                    }
                    break;
                case DefaultLibraryListsWatched:
                    for(NSNumber *malID in usersListObj.watchedArr) {
                        [[SUKAPIManager shared] fetchSpecificAnimeByID:malID completion:^(SUKAnime *anime, NSError *error) {
                             if (anime != nil) {
                                 [self.arrOfAnime addObject:anime];
                                 [self.tableView reloadData];
                             } else {
                                 NSLog(@"%@", error.localizedDescription);
                             }
                         }];
                        [NSThread sleepForTimeInterval:0.4];
                    }
                    break;
                default:
                    break;
            }
        }
    }];
    NSLog(@"%@", self.arrOfAnime);
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
