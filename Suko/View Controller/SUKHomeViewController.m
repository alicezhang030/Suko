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
@property (nonatomic, strong) NSArray *arrayOfAnime;

@end

@implementation SUKHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchTopAnime];
    [self fetchPopularAnime];
    [self fetchGenreList];
    
    // Set up TableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - Fetching Data

- (void) fetchTopAnime {
    NSDictionary *params = @{@"type": @"tv", @"limit": @10};
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:10];
    
    [[SUKAPIManager shared] fetchAnime:@"/top/anime" params:params completion:^(NSArray *anime, NSError *error) {
        if (anime != nil) {
            NSMutableArray *topAnimeArray = [NSMutableArray arrayWithCapacity:10];
            
            for(int i = 0; i < [anime count]; i++) {
               [topAnimeArray addObject:anime[i]];
            }
            
            [mutableArray addObject:topAnimeArray];
            self.arrayOfAnime = [NSArray arrayWithArray:mutableArray];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void) fetchPopularAnime {
    NSDictionary *params = @{@"type": @"tv", @"limit": @10, @"genre":@25};
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:10];
    
    [[SUKAPIManager shared] fetchAnime:@"/anime" params:params completion:^(NSArray *anime, NSError *error) {
        if (anime != nil) {
            NSMutableArray *topAnimeArray = [NSMutableArray arrayWithCapacity:[anime count]];
            
            for(int i = 0; i < [anime count]; i++) {
               [topAnimeArray addObject:anime[i]];
            }
            
            [mutableArray addObject:topAnimeArray];
            
            if(self.arrayOfAnime == nil) {
                self.arrayOfAnime = [NSArray arrayWithArray:mutableArray];
            } else {
                self.arrayOfAnime = [self.arrayOfAnime arrayByAddingObjectsFromArray:[NSArray arrayWithArray:mutableArray]];
            }
            
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void) fetchGenreList {
    [[SUKAPIManager shared] fetchGenreList:^(NSArray *anime, NSError *error) {
        if (anime != nil) {
            NSArray *arr = anime;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

#pragma mark - TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfAnime.count;
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
    return 300;
}

#pragma mark - CollectionView

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *collectionViewArray = self.arrayOfAnime[[(SUKHomeCollectionView *)collectionView indexPath].row];
    return collectionViewArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SUKHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeCollectionViewCellIdentifier forIndexPath:indexPath];
    
    NSArray *collectionViewArray = self.arrayOfAnime[[(SUKHomeCollectionView *)collectionView indexPath].row];
    
    //TODO: move this into a "set" method in SUKHomeCollectionViewCell
    cell.animeTitleLabel.text = collectionViewArray[indexPath.item][@"title_english"];
    NSString *animePosterURLString = collectionViewArray[indexPath.item][@"images"][@"jpg"][@"large_image_url"];
    NSURL *url = [NSURL URLWithString:animePosterURLString];
    if (url != nil) {
        [cell.animePosterImageView setImageWithURL:url];
    }
    
    return cell;
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
