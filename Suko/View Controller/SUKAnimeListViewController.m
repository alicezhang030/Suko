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
#import "Anime.h"

@interface SUKAnimeListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *dataDict;

@end

@implementation SUKAnimeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataDict = [[NSMutableDictionary alloc] init];
    
    [self topAnime];
    
    // Set up TableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - Fetching Data using SUKAPIManager -- To Be Deleted Once I Start Passing Data In

- (void) topAnime {
    [[SUKAPIManager shared] fetchTopAnime:^(NSArray *anime, NSError *error) {
        if (anime != nil) {
            NSString *title = @"Top Anime";
            [self.dataDict setObject:title forKey:@"header"];
            [self.dataDict setObject:anime forKey:@"anime"];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

#pragma mark - TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arrOfAnime = self.dataDict[@"anime"];
    return arrOfAnime.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SUKAnimeListTableViewCell";
    SUKAnimeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *arrOfAnime = self.dataDict[@"anime"];
    Anime *animeToDisplay = arrOfAnime[indexPath.row];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
