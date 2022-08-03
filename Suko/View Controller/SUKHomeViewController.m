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
#import "SUKConstants.h"

#import "NaturalLanguage/NLEmbedding.h"

@interface SUKHomeViewController () <SUKHomeTableViewCellDelegate, UISearchBarDelegate>

/** The table view on the VC */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** Dictionary containing the data to be displayed. The key is the row title (ex. Top Anime) and the value is an NSArray with elements of SUKAnime type representing the data / anime to be displayed. */
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSArray<SUKAnime *> *> *dictOfAnime;

/** The activity spinner shown on the screen while data is being fetched. */
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

/** The search bar at the top of the screen */
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation SUKHomeViewController

NSNumber *const kNumOfRows = @3;
NSNumber *const knumOfAnimeDisplayedPerRow = @8;

#pragma mark - UIViewController Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Property Set Up
    self.dictOfAnime = [NSMutableDictionary new];
    
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
    
    // Movie Bar Button
    UIBarButtonItem *movieBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Movies" style:UIBarButtonItemStylePlain target:self action:@selector(movieBarButtonClicked:)];
    self.navigationItem.rightBarButtonItem = movieBarButton;
    
    /* Commented out code
    NSString* path = [[NSBundle mainBundle] pathForResource:@"stop_words" ofType:@"txt"];
    NSString* stopWordsContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    NSArray<NSString *> *stopWordsArr = [stopWordsContent componentsSeparatedByString:@"\n"];
    
    NSString *regExPattern = @"";
    if(stopWordsArr.count > 0) {
        for(int i = 0; i < stopWordsArr.count - 2; i++) {
            regExPattern = [[[regExPattern stringByAppendingString:@"(\\\\b"] stringByAppendingString:stopWordsArr[i]] stringByAppendingString:@"\\\\b)|"];
        }
        regExPattern = [[[regExPattern stringByAppendingString:@"(\\\\b"] stringByAppendingString:stopWordsArr[stopWordsArr.count - 2]] stringByAppendingString:@"\\\\b)"];
    }*/
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kStopWordsRegExPattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSString *closest = @"All of a sudden again, they arrived: parasitic aliens that descended upon Earth and quickly infiltrated humanity by burrowing into the brains of vulnerable targets. These insatiable beings acquire full control of their host and are able to morph into a variety of forms in order to feed on unsuspecting prey.";
    NSString *secondClosest = @"Surrounded by a forest and a gated entrance, the Grace Field House is inhabited by orphans happily living together as one big family, looked after by their Mama, Isabella. Although they are required to take tests daily, the children are free to spend their time as they see fit, usually playing outside, as long as they do not venture too far from the orphanage—a rule they are expected to follow no matter what. However, all good times must come to an end, as every few months, a child is adopted and sent to live with their new family, never to be heard from again.";
    NSString *notClose = @"Ryuuji Takasu is a gentle high school student with a love for housework; but in contrast to his kind nature, he has an intimidating face that often gets him labeled as a delinquent. On the other hand is Taiga Aisaka, a small, doll-like student, who is anything but a cute and fragile girl. Equipped with a wooden katana and feisty personality, Taiga is known throughout the school as the Palmtop Tiger.";
    NSString *movie = @"Dangerously ill with a rare blood disorder, and determined to save others suffering his same fate, Dr. Michael Morbius attempts a desperate gamble. What at first appears to be a radical success soon reveals itself to be a remedy potentially worse than the disease.";
    
    NSString *modifiedClosestString = [regex stringByReplacingMatchesInString:closest options:0 range:NSMakeRange(0,[closest length]) withTemplate:@""];
    NSString *modifiedSecondClosestString = [regex stringByReplacingMatchesInString:secondClosest options:0 range:NSMakeRange(0,[secondClosest length]) withTemplate:@""];
    NSString *modifiedNotCloseString = [regex stringByReplacingMatchesInString:notClose options:0 range:NSMakeRange(0,[notClose length]) withTemplate:@""];
    NSString *modifiedMovieString = [regex stringByReplacingMatchesInString:movie options:0 range:NSMakeRange(0,[movie length]) withTemplate:@""];
    
    NLEmbedding *embedding = [NLEmbedding sentenceEmbeddingForLanguage:NLLanguageEnglish];
    NLDistance closestDistance = [embedding distanceBetweenString:modifiedClosestString andString:modifiedMovieString distanceType:NLDistanceTypeCosine];
    NLDistance secondClosestDistance = [embedding distanceBetweenString:modifiedSecondClosestString andString:modifiedMovieString distanceType:NLDistanceTypeCosine];
    NLDistance notCloseDistance = [embedding distanceBetweenString:modifiedNotCloseString andString:modifiedMovieString distanceType:NLDistanceTypeCosine];
}

- (void)viewWillAppear:(BOOL)animated {
    if([self.dictOfAnime objectForKey:@"Top Anime"] == nil) {
        [self topAnime];
    }
    
    if(self.dictOfAnime.count < [kNumOfRows intValue]) {
        [self.spinner startAnimating];
        int numGenreRowsLeft = 0;
        
        if(self.dictOfAnime.count == 0) {
            numGenreRowsLeft = [kNumOfRows intValue] - 1;
        } else {
            numGenreRowsLeft = [kNumOfRows intValue] - (int)self.dictOfAnime.count;
        }
        
        [self randomGenresForNRows:[NSNumber numberWithInt:numGenreRowsLeft]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.spinner stopAnimating];
    [[SUKAPIManager shared] cancelAllRequests];
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
        if(error != nil) {
            NSLog(@"Failed to fetch anime with search query %@: %@", searchQuery, error.localizedDescription);
        } else {
            __strong __typeof(self) strongSelf = weakSelf;
            NSMutableDictionary *senderDict = [NSMutableDictionary new];
            [senderDict setObject:@"Results" forKey:@"title"];
            [senderDict setObject:anime forKey:@"anime"];
            [strongSelf performSegueWithIdentifier:kHomeToAnimeListSegueIdentifier sender:senderDict];
        }
    }];
}

#pragma mark - Fetching Data using SUKAPIManager

- (void)topAnime {
    __weak __typeof(self) weakSelf = self;
    [[SUKAPIManager shared] fetchTopAnimeWithLimit:knumOfAnimeDisplayedPerRow completion:^(NSArray<SUKAnime *> *anime, NSError *error) {
        if(error != nil) {
            NSLog(@"Failed to fetch top anime: %@", error.localizedDescription);
        } else {
            __strong __typeof(self) strongSelf = weakSelf;
            NSString *title = @"Top Anime";
            [strongSelf.dictOfAnime setObject:anime forKey:title];
            [strongSelf.tableView reloadData];
        }
    }];
}

- (void)genreOptionsWithCompletion:(void(^)(NSMutableDictionary<NSString *, NSString *> *genreIDsAndName, NSError *error))completion {
    [[SUKAPIManager shared] fetchAnimeGenres:^(NSArray<NSDictionary *> *genres, NSError *error) {
        if(error != nil) {
            completion(nil, error);
        } else {
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
        }
    }];
}

- (void)randomGenresForNRows:(NSNumber *) numberOfLists {
    [self genreOptionsWithCompletion:^(NSMutableDictionary<NSString *,NSString *> *genreIDsAndName, NSError *error) {
        if(error != nil) {
            NSLog(@"Error retriving the genre options: %@", error.localizedDescription);
            [self.spinner stopAnimating];
            [self.tableView reloadData];
        } else {
            NSMutableArray<NSString *> *chosenGenresToDisplay = [NSMutableArray new];
            NSArray<NSString *> *genreIDs = [genreIDsAndName allKeys];
            while(chosenGenresToDisplay.count != [numberOfLists intValue]) { // Ensures the app doesn't display duplicate genres
                int randomGenre = arc4random_uniform((int)genreIDsAndName.count);
                if(![chosenGenresToDisplay containsObject:genreIDs[randomGenre]]) {
                    [chosenGenresToDisplay addObject:genreIDs[randomGenre]];
                }
            }
            
            [self genresToDisplay:chosenGenresToDisplay withGenreOptions:genreIDsAndName];
        }
    }];
}

- (void)genresToDisplay:(NSMutableArray<NSString *> *) genres withGenreOptions:(NSMutableDictionary<NSString *,NSString *> *) genreIDsAndName {
    if(genres.count > 0) {
        NSString *genre = [genres lastObject];
        [genres removeLastObject];
        [NSThread sleepForTimeInterval:1.0];
        
        __weak __typeof(self) weakSelf = self;
        [[SUKAPIManager shared] fetchAnimeFromGenre:genre withLimit:knumOfAnimeDisplayedPerRow completion:^(NSArray<SUKAnime *> *anime, NSError *error) {
            __strong __typeof(self) strongSelf = weakSelf;
            if(error != nil) {
                NSLog(@"Error retriving anime from genre %@: %@", genre, error.localizedDescription);
                [strongSelf.spinner stopAnimating];
                [strongSelf.tableView reloadData];
            } else {
                NSString *title = [[@"Most Popular " stringByAppendingString:[genreIDsAndName objectForKey:genre]] stringByAppendingString:@" Anime"];
                [strongSelf.dictOfAnime setObject:anime forKey:title];
                
                if([genres count] != 0) { // If there are other genre lists to load
                    [NSThread sleepForTimeInterval:1.0];
                    [strongSelf genresToDisplay:genres withGenreOptions:genreIDsAndName];
                } else {
                    [strongSelf.spinner stopAnimating];
                    [strongSelf.tableView reloadData];
                }
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
    [self genreOptionsWithCompletion:^(NSMutableDictionary<NSString *,NSString *> *genreIDsAndName, NSError *error) {
        if(error != nil) {
            NSLog(@"Error retriving the genre options: %@", error.localizedDescription);
        } else {
            [self performSegueWithIdentifier:@"HomeToQuizSegue" sender:genreIDsAndName];
        }
    }];
}

@end
