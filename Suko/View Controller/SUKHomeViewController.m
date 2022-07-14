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
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *dictionaryOfAnime;
@property (nonatomic, strong) NSMutableDictionary *dictOfGenres;
@property (nonatomic, strong) NSMutableArray *headerTitlesBesidesTopAnime;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation SUKHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dictionaryOfAnime = [[NSMutableDictionary alloc] init];
    self.dictOfGenres = [[NSMutableDictionary alloc] init];
    self.headerTitlesBesidesTopAnime = [[NSMutableArray alloc] init];
    
    self.spinner.hidesWhenStopped = YES;
    [self.spinner startAnimating];
    
    [self topAnime];
    [self genreList];
    
    //setting up search bar
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = true;
        
    // Set up TableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - Navigation

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder]; // Dismiss the keyboard
    searchBar.text = @""; // Reset the search bar text
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder]; // Dismiss the keyboard
    NSString *searchText = searchBar.text;
    searchBar.text = @""; // Reset the search bar text
    
    [[SUKAPIManager shared] fetchAnimeSearchBySearchQuery:searchText completion:^(NSArray *anime, NSError *error) {
        if (anime != nil) {
            NSMutableDictionary *senderDict = [[NSMutableDictionary alloc] init];
            [senderDict setObject:@"Results" forKey:@"title"];
            [senderDict setObject:anime forKey:@"anime"];
            [self performSegueWithIdentifier:@"HomeToDetailsSegue" sender:senderDict];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)segueSUKHomeTableViewCell:(SUKHomeTableViewCell *) cell {
    NSMutableDictionary *senderDict = [[NSMutableDictionary alloc] init];
    [senderDict setObject:cell.rowHeaderLabel.text forKey:@"title"];
    [senderDict setObject:cell.arrOfAnime forKey:@"anime"];
    [self performSegueWithIdentifier:@"HomeToDetailsSegue" sender:senderDict];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"HomeToDetailsSegue"]) {
        SUKAnimeListViewController *animeListVC = [segue destinationViewController];
        animeListVC.listTitle = sender[@"title"];
        animeListVC.arrOfAnime = sender[@"anime"];
    }

    if([segue.identifier isEqualToString:@"CollectionToDetailsSegue"]) {
        SUKDetailsViewController *detailsVC = [segue destinationViewController];
        detailsVC.animeToDisplay = sender;
    }
}

- (IBAction)didTapLogout:(id)sender {
    // Reset view to the log in screen
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        NSLog(@"User log out");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SUKLoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        self.view.window.rootViewController = loginVC;
    }];
}

#pragma mark - Fetching Data using SUKAPIManager

- (void) topAnime {
    [self.spinner startAnimating];
    [[SUKAPIManager shared] fetchTopAnime:^(NSArray *anime, NSError *error) {
        if (anime != nil) {
            NSString *title = @"Top Anime";
            [self.dictionaryOfAnime setObject:anime forKey:title];
            [self.spinner stopAnimating];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void) genreAnime: (NSMutableArray *) genres {
    [self.spinner startAnimating];
    NSString *genre = [genres lastObject];
    [genres removeLastObject];
    
    [[SUKAPIManager shared] fetchGenreAnime:genre completion:^(NSArray *anime, NSError *error) {
        if (anime != nil) {
            if(self.dictOfGenres != nil) {
                NSString *correspondingGenre = [self.dictOfGenres objectForKey:genre];
                NSString *title = [[@"Most Popular "
                                    stringByAppendingString:correspondingGenre]
                                    stringByAppendingString:@" Anime"];
                
                [self.headerTitlesBesidesTopAnime addObject:title];
                
                [self.dictionaryOfAnime setObject:anime forKey:title];
                
                if([genres count] != 0) {
                    [NSThread sleepForTimeInterval:1.0];
                    [self genreAnime:genres];
                } else {
                    [self.spinner stopAnimating];
                    [self.tableView reloadData];
                }
            }
        }
        NSLog(@"%@", error.localizedDescription);
    }];
}

- (void) genreList {
    NSArray<NSString *> *genresToNotConsider = @[@"Ecchi", @"Hentai", @"Erotica"];
    [[SUKAPIManager shared] fetchGenreList:^(NSArray *genres, NSError *error) {
        if (genres != nil) {
            int maxID = 0;
            NSMutableArray *arrOfIDs = [[NSMutableArray alloc] init];
                        
            for(NSDictionary *genreDict in genres) {
                if(![genresToNotConsider containsObject:[genreDict valueForKey:@"name"]]) {
                    NSNumber *malID = [genreDict valueForKey:@"mal_id"];
                    int malIDInt = [malID intValue];
                    
                    if(malIDInt > maxID) {
                        maxID = malIDInt;
                    }
                    
                    NSString *malIDString = [NSString stringWithFormat:@"%d", malIDInt];
                    [arrOfIDs addObject:malIDString];
                    
                    NSString *genreName = [genreDict valueForKey:@"name"];
                    
                    [self.dictOfGenres setObject:genreName forKey:malIDString];
                }
            }
            
            int randomGenre1 = arc4random_uniform((int)self.dictOfGenres.count);
            int randomGenre2 = arc4random_uniform((int)self.dictOfGenres.count);
            while(randomGenre2 == randomGenre1) { // Make sure the two genres are not the same
                randomGenre2 = arc4random_uniform((int)self.dictOfGenres.count);
            }
            
            NSMutableArray *genres = [@[arrOfIDs[randomGenre1], arrOfIDs[randomGenre2]] mutableCopy];
            [self genreAnime:genres];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

#pragma mark - TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dictionaryOfAnime count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SUKHomeTableViewCell";
    SUKHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.delegate = self;
    
    NSString *headerTitle = [self retriveDataForIndexPathRow:indexPath.row][@"header"];
    cell.rowHeaderLabel.text = headerTitle;
    
    NSArray *animeData = [self retriveDataForIndexPathRow:indexPath.row][@"anime"];
    cell.arrOfAnime = animeData;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(SUKHomeTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setCollectionViewDataSourceDelegate:self indexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
    return 305;
}

#pragma mark - CollectionView

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger row = [(SUKHomeCollectionView *)collectionView indexPath].row;
    NSArray *animeData = [self retriveDataForIndexPathRow:row][@"anime"];
    return animeData.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SUKHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SUKHomeCollectionViewCell" forIndexPath:indexPath];
    
    NSInteger row = [(SUKHomeCollectionView *)collectionView indexPath].row;
    NSArray *collectionViewArray = [self retriveDataForIndexPathRow:row][@"anime"];
    SUKAnime *animeToDisplay =  collectionViewArray[indexPath.item];
    
    [cell setAnime:animeToDisplay];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [(SUKHomeCollectionView *)collectionView indexPath].row;
    NSArray *collectionViewArray = [self retriveDataForIndexPathRow:row][@"anime"];
    SUKAnime *animeToDisplay =  collectionViewArray[indexPath.item];
    
    [self performSegueWithIdentifier:@"CollectionToDetailsSegue" sender:animeToDisplay];
}

- (NSMutableDictionary *) retriveDataForIndexPathRow: (NSInteger) indexPathRow {
    NSMutableDictionary *rowData = [[NSMutableDictionary alloc] init];
    
    if(indexPathRow == 0) {
        [rowData setObject:@"Top Anime" forKey:@"header"];
        [rowData setObject:self.dictionaryOfAnime[@"Top Anime"] forKey:@"anime"];
    } else {
        NSString *title = self.headerTitlesBesidesTopAnime[indexPathRow - 1];
        [rowData setObject:title forKey:@"header"];
        [rowData setObject:self.dictionaryOfAnime[title] forKey:@"anime"];
    }
    
    return rowData;
}

@end
