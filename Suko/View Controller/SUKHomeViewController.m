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

@interface SUKHomeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *dictionaryOfAnime;
@property (nonatomic, strong) NSMutableDictionary *dictOfGenres;
@property (nonatomic, strong) NSMutableArray *headerTitlesBesidesTopAnime;

// TODO: Change array of anime to Models

@end

@implementation SUKHomeViewController
const BOOL displayGenre = YES;
const NSNumber *knumOfAnimeDisplayedPerRow = @10;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dictionaryOfAnime = [[NSMutableDictionary alloc] init];
    self.dictOfGenres = [[NSMutableDictionary alloc] init];
    self.headerTitlesBesidesTopAnime = [[NSMutableArray alloc] init];
    
    [self fetchTopAnime];
    [self fetchGenreList];
    //[self fetchGenreAnime:@25];
    
    // Set up TableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - Fetching Data

- (void) fetchTopAnime {
    NSDictionary *params = @{@"type": @"tv", @"limit": knumOfAnimeDisplayedPerRow};
    
    [[SUKAPIManager shared] fetchAnime:@"/top/anime" params:params completion:^(NSArray *anime, NSError *error) {
        if (anime != nil) {
            NSString *title = @"Top Anime";
            [self.dictionaryOfAnime setObject:anime forKey:title];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void) fetchGenreAnime: (NSNumber *) genre {
    NSDictionary *params = @{@"type": @"tv", @"limit": knumOfAnimeDisplayedPerRow, @"order_by": @"score", @"sort": @"desc", @"genres":genre};
    
    [[SUKAPIManager shared] fetchAnime:@"/anime" params:params completion:^(NSArray *anime, NSError *error) {
        if (anime != nil) {
            if(self.dictOfGenres != nil) {
                NSString *malID = [genre stringValue];
                NSString *correspondingGenre = [self.dictOfGenres objectForKey:malID];
                NSString *title = [[@"Most Popular "
                                    stringByAppendingString:correspondingGenre]
                                    stringByAppendingString:@" Anime"];
                
                [self.headerTitlesBesidesTopAnime addObject:title];
                
                [self.dictionaryOfAnime setObject:anime forKey:title];
                [self.tableView reloadData];
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void) fetchGenreList {
    [[SUKAPIManager shared] fetchGenreList:^(NSArray *genres, NSError *error) {
        if (genres != nil) {
            for(NSDictionary *genreDict in genres) {
                NSNumber *malID = [genreDict valueForKey:@"mal_id"];
                int malIDInt = [malID intValue];
                NSString *malIDString = [NSString stringWithFormat:@"%d", malIDInt];
                
                NSString *genreName = [genreDict valueForKey:@"name"];
                
                [self.dictOfGenres setObject:genreName forKey:malIDString];
            }
            
            [self fetchGenreAnime:@25];
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
    
    NSString *headerTitle = [self retriveDataForIndexPathRow:indexPath.row][@"header"];
    cell.rowHeaderLabel.text = headerTitle;    
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
    
    //TODO: move this into a "set" method in SUKHomeCollectionViewCell
    NSString *title = collectionViewArray[indexPath.item][@"title"];
    cell.animeTitleLabel.text = [[title componentsSeparatedByString:@"\\"] objectAtIndex:0];
    
    NSString *animePosterURLString = collectionViewArray[indexPath.item][@"images"][@"jpg"][@"large_image_url"];
    NSURL *url = [NSURL URLWithString:animePosterURLString];
    if (url != nil) {
        [cell.animePosterImageView setImageWithURL:url];
    }
    
    return cell;
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
