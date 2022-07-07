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

// TODO: Change arrayOfAnime to NSDictionary
// TODO: Change array of anime to Models

@end

@implementation SUKHomeViewController
const BOOL displayGenre = YES;
const NSNumber *knumOfAnimeDisplayedPerRow = @10;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dictionaryOfAnime = [[NSMutableDictionary alloc] init];
    self.dictOfGenres = [[NSMutableDictionary alloc] init];
    
    [self fetchTopAnime];
    [self fetchGenreList];
    //[self fetchGenreAnime:@25];
    
    // Set up TableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - Fetching Data

/*
+(NSDictionary*)getConstGenreList {
    static NSDictionary *dictOfGenres = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = @{
            @"key1": @"value1",
            @"key2": @"value2",
            @"key3": @"value3"
        };
    });
    return inst;
}*/

- (void) fetchTopAnime {
    NSDictionary *params = @{@"type": @"tv", @"limit": knumOfAnimeDisplayedPerRow};
    
    [[SUKAPIManager shared] fetchAnime:@"/top/anime" params:params completion:^(NSArray *anime, NSError *error) {
        if (anime != nil) {
            [self.dictionaryOfAnime setObject:anime forKey:@"Top Anime"];
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
                NSLog(@"%@", [self.dictOfGenres objectForKey:malID]);
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
                NSNumber *malId = [genreDict valueForKey:@"mal_id"];
                int malIdInt = [malId intValue];
                NSString *malIdString = [NSString stringWithFormat:@"%d", malIdInt];
                
                NSString *genreName = [genreDict valueForKey:@"name"];
                
                [self.dictOfGenres setObject:genreName forKey:malIdString];
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
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(SUKHomeTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setCollectionViewDataSourceDelegate:self indexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
    return 360;
}

#pragma mark - CollectionView

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger row = [(SUKHomeCollectionView *)collectionView indexPath].row;
    return [self retriveDataForIndexPathRow:row].count;
    
    /*
    NSArray *topAiringAnime = self.dictionaryOfAnime[@"Top Airing Anime"];
    return [self retriveDataForIndexPath: [(SUKHomeCollectionView *)collectionView indexPath].row];*/
    
    /*
    if(row == 0) {
        NSArray *topAiringAnime = self.dictionaryOfAnime[@"Top Airing Anime"];
        return topAiringAnime.count;
    }*/
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SUKHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SUKHomeCollectionViewCell" forIndexPath:indexPath];
    
    NSInteger row = [(SUKHomeCollectionView *)collectionView indexPath].row;
    NSArray *collectionViewArray = [self retriveDataForIndexPathRow:row];
    
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

- (NSArray *) retriveDataForIndexPathRow: (NSInteger) indexPathRow {
    return self.dictionaryOfAnime[@"Top Anime"];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
