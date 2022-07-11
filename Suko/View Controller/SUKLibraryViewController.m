//
//  SUKLibraryViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/8/22.
//

#import "SUKLibraryViewController.h"
#import "SUKLibraryTableViewCell.h"
#import "SUKAnimeListViewController.h"
#import "SUKUsersLists.h"
#import "SUKAPIManager.h"

@interface SUKLibraryViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listTitles;
@property (nonatomic, strong) NSMutableDictionary<NSString*, NSMutableArray*> *dictionaryOfAnime;

@end

@implementation SUKLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up TableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self updateDictionaryOfAnime:DefaultLibraryListsWantToWatch];
    [self updateDictionaryOfAnime:DefaultLibraryListsWatching];
    [self updateDictionaryOfAnime:DefaultLibraryListsWatched];
        
    self.dictionaryOfAnime = [[NSMutableDictionary alloc] init];
    [self.dictionaryOfAnime setObject: [NSMutableArray array] forKey:@"Want to Watch"];
    [self.dictionaryOfAnime setObject: [NSMutableArray array] forKey:@"Watching"];
    [self.dictionaryOfAnime setObject: [NSMutableArray array] forKey:@"Watched"];
    
    self.listTitles = [@[@"Want to Watch", @"Watching", @"Watched"] mutableCopy];
}

#pragma mark - TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dictionaryOfAnime count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SUKLibraryTableViewCell";
    SUKLibraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.listTitleLabel.text = self.listTitles[indexPath.row];
    return cell;
}

#pragma mark - Fetch Data

- (void) updateDictionaryOfAnime:(DefaultLibraryLists) listTitle {
    PFQuery *query = [PFQuery queryWithClassName:@"SUKUsersLists"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray<SUKUsersLists*> *usersLists, NSError *error) {
        if(usersLists.count > 1) {
            NSLog(@"More than one entry for this user in the database");
        } else if (usersLists.count == 1) {
            /* User has added at least 1 thing to a list before
             Lists could still be empty if user removed everything from lists */

            SUKUsersLists *usersListObj = [usersLists objectAtIndex:0];
            
            switch(listTitle) {
                case DefaultLibraryListsWantToWatch:
                    for(NSNumber *malID in usersListObj.wantToWatchArr) {
                        [[SUKAPIManager shared] fetchSpecificAnimeByID:malID completion:^(SUKAnime *anime, NSError *error) {
                             if (anime != nil) {
                                 [[self.dictionaryOfAnime objectForKey:@"Want to Watch"] addObject:anime];
                             } else {
                                 NSLog(@"%@", error.localizedDescription);
                             }
                         }];
                        [NSThread sleepForTimeInterval:0.5];
                    }
                    break;
                case DefaultLibraryListsWatching:
                    for(NSNumber *malID in usersListObj.watchingArr) {
                        [[SUKAPIManager shared] fetchSpecificAnimeByID:malID completion:^(SUKAnime *anime, NSError *error) {
                             if (anime != nil) {
                                 [[self.dictionaryOfAnime objectForKey:@"Watching"] addObject:anime];
                             } else {
                                 NSLog(@"%@", error.localizedDescription);
                             }
                         }];
                        [NSThread sleepForTimeInterval:0.5];
                    }
                    break;
                case DefaultLibraryListsWatched:
                    for(NSNumber *malID in usersListObj.watchedArr) {
                        [[SUKAPIManager shared] fetchSpecificAnimeByID:malID completion:^(SUKAnime *anime, NSError *error) {
                             if (anime != nil) {
                                 [[self.dictionaryOfAnime objectForKey:@"Watched"] addObject:anime];
                             } else {
                                 NSLog(@"%@", error.localizedDescription);
                             }
                         }];
                        [NSThread sleepForTimeInterval:0.5];
                    }
                    break;
                default:
                    break;
            }
        }
        
        /* Don't need to take care of the case where user hasn't added anything to a list yet
           because the dictionary already has empty arrays as default */
    }];
}

#pragma mark - Navigation

- (void)segueSUKHomeTableViewCell:(SUKLibraryTableViewCell *) cell {
    NSMutableDictionary *senderDict = [[NSMutableDictionary alloc] init];
    [senderDict setObject:cell.listTitleLabel.text forKey:@"title"];
    [senderDict setObject:[self.dictionaryOfAnime objectForKey:cell.listTitleLabel.text] forKey:@"anime"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"LibraryToListSegue"]) {
        SUKAnimeListViewController *animeListVC = [segue destinationViewController];
        SUKLibraryTableViewCell *cell = sender;
        animeListVC.listTitle = cell.listTitleLabel.text;
        
        if([cell.listTitleLabel.text.lowercaseString containsString:@"want"]) {
            [self updateDictionaryOfAnime:DefaultLibraryListsWantToWatch];
        } else if ([cell.listTitleLabel.text.lowercaseString isEqualToString:@"watching"]){
            [self updateDictionaryOfAnime:DefaultLibraryListsWatching];
        } else if ([cell.listTitleLabel.text.lowercaseString isEqualToString:@"watched"]){
            [self updateDictionaryOfAnime:DefaultLibraryListsWatched];
        }
        
        animeListVC.arrOfAnime = [self.dictionaryOfAnime objectForKey:cell.listTitleLabel.text];
    }
}

@end
