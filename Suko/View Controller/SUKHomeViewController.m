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
@property (nonatomic, strong) NSMutableDictionary<NSString*, NSArray<SUKAnime*>*> *dictionaryOfAnime;
@property (nonatomic, strong) NSMutableDictionary<NSString*, NSString*> *dictOfGenres;
@property (nonatomic, strong) NSMutableArray<NSString*> *headerTitlesBesidesTopAnime;
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
    
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = true;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - Navigation

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    searchBar.text = @"";
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    NSString *searchText = searchBar.text;
    searchBar.text = @"";
    
    __weak __typeof(self) weakSelf = self;
    
    [[SUKAPIManager shared] fetchAnimeSearchBySearchQuery:searchText completion:^(NSArray<SUKAnime*> *anime, NSError *error) {
        __strong __typeof(self) strongSelf = weakSelf;
        if (anime != nil) {
            NSMutableDictionary *senderDict = [[NSMutableDictionary alloc] init];
            [senderDict setObject:@"Results" forKey:@"title"];
            [senderDict setObject:anime forKey:@"anime"];
            [strongSelf performSegueWithIdentifier:@"HomeToListSegue" sender:senderDict];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)segueSUKHomeTableViewCell:(SUKHomeTableViewCell *) cell {
    NSMutableDictionary *senderDict = [[NSMutableDictionary alloc] init];
    [senderDict setObject:cell.rowHeaderLabel.text forKey:@"title"];
    [senderDict setObject:cell.arrOfAnime forKey:@"anime"];
    [self performSegueWithIdentifier:@"HomeToListSegue" sender:senderDict];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"HomeToListSegue"]) {
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
    __weak __typeof(self) weakSelf = self;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        __strong __typeof(self) strongSelf = weakSelf;
        NSLog(@"User log out");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SUKLoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        strongSelf.view.window.rootViewController = loginVC;
    }];
}

#pragma mark - Fetching Data using SUKAPIManager

- (void) topAnime {
    [self.spinner startAnimating];
    __weak __typeof(self) weakSelf = self;
    [[SUKAPIManager shared] fetchTopAnime:^(NSArray<SUKAnime*> *anime, NSError *error) {
        __strong __typeof(self) strongSelf = weakSelf;
        if (anime != nil) {
            NSString *title = @"Top Anime";
            [strongSelf.dictionaryOfAnime setObject:anime forKey:title];
            [strongSelf.spinner stopAnimating];
            [strongSelf.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void) genreAnime: (NSMutableArray<NSString*> *) genres {
    [self.spinner startAnimating];
    NSString *genre = [genres lastObject];
    [genres removeLastObject];
    
    __weak __typeof(self) weakSelf = self;
    [[SUKAPIManager shared] fetchGenreAnime:genre completion:^(NSArray<SUKAnime*> *anime, NSError *error) {
        __strong __typeof(self) strongSelf = weakSelf;
        if (anime != nil) {
            if(strongSelf.dictOfGenres != nil) {
                NSString *correspondingGenre = [self.dictOfGenres objectForKey:genre];
                NSString *title = [[@"Most Popular "
                                    stringByAppendingString:correspondingGenre]
                                    stringByAppendingString:@" Anime"];
                
                [strongSelf.headerTitlesBesidesTopAnime addObject:title];
                
                [strongSelf.dictionaryOfAnime setObject:anime forKey:title];
                
                if([genres count] != 0) {
                    [NSThread sleepForTimeInterval:1.0];
                    [strongSelf genreAnime:genres];
                } else {
                    [strongSelf.spinner stopAnimating];
                    [strongSelf.tableView reloadData];
                }
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void) genreList {
    NSArray<NSString *> *genresToNotConsider = @[@"Ecchi", @"Hentai", @"Erotica"];
    __weak __typeof(self) weakSelf = self;
    [[SUKAPIManager shared] fetchGenreList:^(NSArray<NSDictionary*> *genres, NSError *error) {
        __strong __typeof(self) strongSelf = weakSelf;
        if (genres != nil) {
            int maxID = 0;
            NSMutableArray<NSString*> *arrOfIDs = [[NSMutableArray alloc] init];
                        
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
                    
                    [strongSelf.dictOfGenres setObject:genreName forKey:malIDString];
                }
            }
            
            int randomGenre1 = arc4random_uniform((int)self.dictOfGenres.count);
            int randomGenre2 = arc4random_uniform((int)self.dictOfGenres.count);
            while(randomGenre2 == randomGenre1) { 
                randomGenre2 = arc4random_uniform((int)self.dictOfGenres.count);
            }
            
            NSMutableArray<NSString*> *genres = [@[arrOfIDs[randomGenre1], arrOfIDs[randomGenre2]] mutableCopy];
            [strongSelf genreAnime:genres];
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
    
    NSArray<SUKAnime*> *animeData = [self retriveDataForIndexPathRow:indexPath.row][@"anime"];
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
    NSArray<SUKAnime*> *animeData = [self retriveDataForIndexPathRow:row][@"anime"];
    return animeData.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SUKHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SUKHomeCollectionViewCell" forIndexPath:indexPath];
    
    NSInteger row = [(SUKHomeCollectionView *)collectionView indexPath].row;
    NSArray<SUKAnime*> *collectionViewArray = [self retriveDataForIndexPathRow:row][@"anime"];
    SUKAnime *animeToDisplay =  collectionViewArray[indexPath.item];
    
    [cell setAnime:animeToDisplay];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [(SUKHomeCollectionView *)collectionView indexPath].row;
    NSArray<SUKAnime*> *collectionViewArray = [self retriveDataForIndexPathRow:row][@"anime"];
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
