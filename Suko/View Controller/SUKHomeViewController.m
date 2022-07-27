//
//  SUKHomeViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/5/22.
//

#import "SUKHomeViewController.h"
#import "SUKAPIManager.h"
#import "SUKHomeTableViewCell.h"
#import "SUKHomeCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "SUKAnime.h"
#import "SUKAnimeListViewController.h"
#import "SUKDetailsViewController.h"
#import "SUKLoginViewController.h"
#import "Parse/Parse.h"
#include <stdlib.h>
#import "SUKQuizIntroViewController.h"

@interface SUKHomeViewController () <SUKHomeTableViewCellDelegate, UISearchBarDelegate>
/** The table view on the VC */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** Dictionary containing the data to be displayed. The key is the row title (ex. Top Anime) and the value is an NSArray with elements of SUKAnime type representing the data / anime to be displayed. */
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSArray<SUKAnime *> *> *dictOfAnime;
/** Dictionary containing the possible genres. The key is the genre's ID as stored in the external API and the value is the genre title. */
//@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *dictOfGenres;
/** The activity spinner shown on the screen while data is being fetched. */
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
/** The search bar at the top of the screen*/
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, assign) BOOL cancelTasks;
@end

@implementation SUKHomeViewController

NSString *const kHomeToAnimeListSegueIdentifier = @"HomeToAnimeListSegue";
NSString *const kHomeCollectionCellToDetailsSegueIdentifier = @"HomeCollectionCellToDetailsSegue";
NSNumber *const kNumOfRows = @3;
NSNumber *const knumOfAnimeDisplayedPerRow = @5;

#pragma mark - UIViewController Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Property Set Up
    self.dictOfAnime = [NSMutableDictionary new];
    
    // Fetching Set Up
    [self setCancelTasks:NO];
    
    // Spinner
    self.spinner.hidesWhenStopped = YES;
    self.spinner.layer.cornerRadius = 10;
    [self.spinner setCenter:CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0)];
    
    // Search Bar
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = true;
    
    // Table View
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UIBarButtonItem *movieBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Movies"
                                 style:UIBarButtonItemStylePlain
                                target:self action:@selector(movieBarButtonClicked:)];
    self.navigationItem.rightBarButtonItem = movieBarButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [self setCancelTasks:NO];
    
    if([self.dictOfAnime objectForKey:@"Top Anime"] == nil) {
        [self topAnime];
    }
    
    if(self.dictOfAnime.count < [kNumOfRows intValue]) {
        [self.spinner startAnimating];
        int numberOfListsLeft = 0;
        
        if(self.dictOfAnime.count == 0) {
            numberOfListsLeft = [kNumOfRows intValue] - 1;
        } else {
            numberOfListsLeft = [kNumOfRows intValue] - (int)self.dictOfAnime.count;
        }
        
        [self genreAnime:[NSNumber numberWithInt:numberOfListsLeft]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.spinner stopAnimating];
    
    [self setCancelTasks:YES];
    [[SUKAPIManager shared] cancelAllJikanRequests];
}

#pragma mark - Search Bar

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    searchBar.text = @"";
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    NSString *searchQuery = searchBar.text;
    searchBar.text = @"";
    
    __weak __typeof(self) weakSelf = self;
    [[SUKAPIManager shared] fetchAnimeSearchWithSearchQuery:searchQuery completion:^(NSArray<SUKAnime *> *anime, NSError *error) {
        __strong __typeof(self) strongSelf = weakSelf;
        if (anime != nil) {
            NSMutableDictionary *senderDict = [NSMutableDictionary new];
            [senderDict setObject:@"Results" forKey:@"title"];
            [senderDict setObject:anime forKey:@"anime"];
            [strongSelf performSegueWithIdentifier:kHomeToAnimeListSegueIdentifier sender:senderDict];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

#pragma mark - Fetching Data using SUKAPIManager

- (void)topAnime {
    if(!self.cancelTasks) {
        __weak __typeof(self) weakSelf = self;
        [[SUKAPIManager shared] fetchTopAnimeWithLimit:knumOfAnimeDisplayedPerRow completion:^(NSArray<SUKAnime *> *anime, NSError *error) {
            __strong __typeof(self) strongSelf = weakSelf;
            if (anime != nil) {
                NSString *title = @"Top Anime";
                [strongSelf.dictOfAnime setObject:anime forKey:title];
                [strongSelf.tableView reloadData];
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
}

- (void)genreListWithCompletion:(void(^)(NSMutableDictionary<NSString *, NSString *> *genreIDsAndName, NSError *error))completion {
    if(!self.cancelTasks) {
        [[SUKAPIManager shared] fetchAnimeGenres:^(NSArray<NSDictionary *> *genres, NSError *error) {
            if (genres != nil) {
                NSArray<NSString *> *genresToNotConsider = @[@"Ecchi", @"Hentai", @"Erotica"];
                NSMutableDictionary<NSString *, NSString *> *dictOfGenres = [NSMutableDictionary new];
                
                for(NSDictionary *genreDict in genres) {
                    if(![genresToNotConsider containsObject:[genreDict valueForKey:@"name"]]) {
                        NSString *genreIDString = [NSString stringWithFormat:@"%d", [[genreDict valueForKey:@"mal_id"] intValue]];
                        NSString *genreName = [genreDict valueForKey:@"name"];
                        [dictOfGenres setObject:genreName forKey:genreIDString];
                    }
                }
                
                completion(dictOfGenres, nil);
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
}

- (void)genreAnime:(NSNumber *) numberOfLists {
    if(!self.cancelTasks) {
        [self genreListWithCompletion:^(NSMutableDictionary<NSString *,NSString *> *genreIDsAndName, NSError *error) {
            NSMutableArray<NSString *> *chosenGenresToDisplay = [NSMutableArray new];
            NSArray<NSString *> *genreIDs = [genreIDsAndName allKeys];
            while(chosenGenresToDisplay.count != [numberOfLists intValue]) { // Ensures the app doesn't display duplicate genres
                int randomGenre = arc4random_uniform((int)genreIDsAndName.count);
                if(![chosenGenresToDisplay containsObject:genreIDs[randomGenre]]) {
                    [chosenGenresToDisplay addObject:genreIDs[randomGenre]];
                }
            }
            
            [self genresToDisplay:chosenGenresToDisplay withGenreOptions:genreIDsAndName];
        }];
    }
}

- (void)genresToDisplay:(NSMutableArray<NSString *> *) genres withGenreOptions:(NSMutableDictionary<NSString *,NSString *> *) genreIDsAndName {
    if(genres.count > 0) {
        NSString *genre = [genres lastObject];
        [genres removeLastObject];
        [NSThread sleepForTimeInterval:1.0];
        
        __weak __typeof(self) weakSelf = self;
        [[SUKAPIManager shared] fetchAnimeFromGenre:genre withLimit:knumOfAnimeDisplayedPerRow completion:^(NSArray<SUKAnime *> *anime, NSError *error) {
            __strong __typeof(self) strongSelf = weakSelf;
            if (anime != nil) {
                NSString *title = [[@"Most Popular " stringByAppendingString:[genreIDsAndName objectForKey:genre]] stringByAppendingString:@" Anime"];
                [strongSelf.dictOfAnime setObject:anime forKey:title];
                
                if([genres count] != 0) { // If there are other genre lists to load
                    [NSThread sleepForTimeInterval:1.0];
                    [strongSelf genresToDisplay:genres withGenreOptions:genreIDsAndName];
                } else {
                    [strongSelf.spinner stopAnimating];
                    [strongSelf.tableView reloadData];
                }
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dictOfAnime count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SUKHomeTableViewCell";
    SUKHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.delegate = self;
    cell.rowHeaderLabel.text = [self retriveDataForIndexPathRow:indexPath.row][@"header"];
    cell.arrOfAnime = [self retriveDataForIndexPathRow:indexPath.row][@"anime"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(SUKHomeTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setCollectionViewDataSourceDelegate:self indexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 310;
}

#pragma mark - CollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray<SUKAnime *> *animeDataForThisRow = [self retriveDataForIndexPathRow:[(SUKHomeCollectionView *)collectionView indexPath].row][@"anime"];
    return animeDataForThisRow.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SUKHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SUKHomeCollectionViewCell" forIndexPath:indexPath];
    NSArray<SUKAnime *> *animeDataForThisRow = [self retriveDataForIndexPathRow:[(SUKHomeCollectionView *)collectionView indexPath].row][@"anime"];
    [cell setAnime:animeDataForThisRow[indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<SUKAnime *> *animeDataForThisRow = [self retriveDataForIndexPathRow:[(SUKHomeCollectionView *)collectionView indexPath].row][@"anime"];
    SUKAnime *animeToDisplay = animeDataForThisRow[indexPath.item];
    [self performSegueWithIdentifier:kHomeCollectionCellToDetailsSegueIdentifier sender:animeToDisplay];
}

- (NSMutableDictionary *)retriveDataForIndexPathRow:(NSInteger)indexPathRow {
    NSMutableDictionary *rowData = [NSMutableDictionary new];
    if(indexPathRow == 0) {
        [rowData setObject:@"Top Anime" forKey:@"header"];
        [rowData setObject:self.dictOfAnime[@"Top Anime"] forKey:@"anime"];
    } else {
        NSString *title = [self.dictOfAnime allKeys][indexPathRow];
        [rowData setObject:title forKey:@"header"];
        [rowData setObject:self.dictOfAnime[title] forKey:@"anime"];
    }
    
    return rowData;
}

#pragma mark - Navigation

- (void)segueSUKHomeTableViewCell:(SUKHomeTableViewCell *) cell {
    NSMutableDictionary *senderDict = [NSMutableDictionary new];
    [senderDict setObject:cell.rowHeaderLabel.text forKey:@"title"];
    [senderDict setObject:cell.arrOfAnime forKey:@"anime"];
    [self performSegueWithIdentifier:kHomeToAnimeListSegueIdentifier sender:senderDict];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:kHomeToAnimeListSegueIdentifier]) {
        SUKAnimeListViewController *animeListVC = [segue destinationViewController];
        animeListVC.listTitle = sender[@"title"];
        animeListVC.arrOfAnime = sender[@"anime"];
    }
    
    if([segue.identifier isEqualToString:kHomeCollectionCellToDetailsSegueIdentifier]) {
        SUKDetailsViewController *detailsVC = [segue destinationViewController];
        detailsVC.animeToDisplay = sender;
    }
    
    if([segue.identifier isEqualToString:@"HomeToQuizSegue"]) {
        SUKQuizIntroViewController *quizVC = [segue destinationViewController];
        quizVC.animeGenres = sender;
    }
}

- (void)movieBarButtonClicked:(UIBarButtonItem *) barButton {
    [self genreListWithCompletion:^(NSMutableDictionary<NSString *,NSString *> *genreIDsAndName, NSError *error) {
        if(error == nil) {
            [self performSegueWithIdentifier:@"HomeToQuizSegue" sender:genreIDsAndName];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

@end
