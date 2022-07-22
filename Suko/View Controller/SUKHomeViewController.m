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

@interface SUKHomeViewController () <SUKHomeTableViewCellDelegate, UISearchBarDelegate>
/** The table view on the VC */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** Dictionary containing the data to be displayed. The key is the row title (ex. Top Anime) and the value is an NSArray with elements of SUKAnime type representing the data / anime to be displayed. */
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSArray<SUKAnime *> *> *dictOfAnime;
/** Dictionary containing the possible genres. The key is the genre's ID as stored in the external API and the value is the genre title. */
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *dictOfGenres;
/** The activity spinner shown on the screen while data is being fetched. */
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
/** The search bar at the top of the screen*/
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation SUKHomeViewController

NSString *const kHomeToAnimeListSegueIdentifier = @"HomeToAnimeListSegue";
NSString *const kHomeCollectionCellToDetailsSegueIdentifier = @"HomeCollectionCellToDetailsSegue";
NSNumber *const kNumOfRows = @3;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dictOfAnime = [NSMutableDictionary new];
    self.dictOfGenres = [NSMutableDictionary new];
    
    self.spinner.hidesWhenStopped = YES;
    self.spinner.layer.cornerRadius = 10;
    [self.spinner setCenter:CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0)];
    
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = true;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewWillAppear:(BOOL)animated {
    // If not all desired data have been loaded yet (ex. initial load, used switched to a different tab before all data has loaded)
    if(self.dictOfAnime.count < [kNumOfRows intValue]) {
        [self.spinner startAnimating];
        [self topAnime];
        [self genreList:[NSNumber numberWithInt:([kNumOfRows intValue] - (int)self.dictOfAnime.count)]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.spinner stopAnimating];
    [[SUKAPIManager shared] cancelAllRequests]; // Reduce the number of requests made to external API
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
}

#pragma mark - Fetching Data using SUKAPIManager

- (void)topAnime {
    __weak __typeof(self) weakSelf = self;
    [[SUKAPIManager shared] fetchTopAnimeList:^(NSArray<SUKAnime *> *anime, NSError *error) {
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

- (void)genreAnime:(NSMutableArray<NSString *> *) genres {
    if(genres.count > 0) {
        NSString *genre = [genres lastObject];
        [genres removeLastObject];
        [NSThread sleepForTimeInterval:1.0];
        
        __weak __typeof(self) weakSelf = self;
        [[SUKAPIManager shared] fetchAnimeListWithGenre:genre completion:^(NSArray<SUKAnime *> *anime, NSError *error) {
            __strong __typeof(self) strongSelf = weakSelf;
            if (anime != nil) {
                NSString *correspondingGenre = [self.dictOfGenres objectForKey:genre];
                NSString *title = [[@"Most Popular "
                                    stringByAppendingString:correspondingGenre]
                                   stringByAppendingString:@" Anime"];
                [strongSelf.dictOfAnime setObject:anime forKey:title];
                
                if([genres count] != 0) { // If there are other genre lists to load
                    [NSThread sleepForTimeInterval:1.0];
                    [strongSelf genreAnime:genres];
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

- (void)genreList:(NSNumber *)numberOfLists {
    NSArray<NSString *> *genresToNotConsider = @[@"Ecchi", @"Hentai", @"Erotica"];
    
    __weak __typeof(self) weakSelf = self;
    [[SUKAPIManager shared] fetchGenreList:^(NSArray<NSDictionary *> *genres, NSError *error) {
        __strong __typeof(self) strongSelf = weakSelf;
        if (genres != nil) {
            NSMutableArray<NSString *> *arrOfGenreIDs = [NSMutableArray new]; // Used to choose random genreIDs later
            
            for(NSDictionary *genreDict in genres) {
                if(![genresToNotConsider containsObject:[genreDict valueForKey:@"name"]]) { // Checks if the genre the for-loop is on is SFW or not
                    NSString *genreIDString = [NSString stringWithFormat:@"%d", [[genreDict valueForKey:@"mal_id"] intValue]];
                    NSString *genreName = [genreDict valueForKey:@"name"];
                    [arrOfGenreIDs addObject:genreIDString];
                    [strongSelf.dictOfGenres setObject:genreName forKey:genreIDString];
                }
            }
            
            NSMutableArray<NSString *> *chosenGenresToDisplay = [NSMutableArray new];
            while(chosenGenresToDisplay.count != [numberOfLists intValue]) {
                int randomGenre = arc4random_uniform((int)self.dictOfGenres.count);
                if(![chosenGenresToDisplay containsObject:arrOfGenreIDs[randomGenre]]) { // Ensures the app doesn't display duplicate genres
                    [chosenGenresToDisplay addObject:arrOfGenreIDs[randomGenre]];
                }
            }
            
            [strongSelf genreAnime:chosenGenresToDisplay];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dictOfAnime count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SUKHomeTableViewCell";
    SUKHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.delegate = self;
    
    NSString *headerTitle = [self retriveDataForIndexPathRow:indexPath.row][@"header"];
    cell.rowHeaderLabel.text = headerTitle;
    
    NSArray<SUKAnime *> *animeData = [self retriveDataForIndexPathRow:indexPath.row][@"anime"];
    cell.arrOfAnime = animeData;
    
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
    NSArray<SUKAnime *> *animeData = [self retriveDataForIndexPathRow:[(SUKHomeCollectionView *)collectionView indexPath].row][@"anime"];
    return animeData.count;
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

@end
