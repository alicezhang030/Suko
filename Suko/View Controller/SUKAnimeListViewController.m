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
#import "SUKDetailsViewController.h"

@interface SUKAnimeListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SUKAnimeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    //[self topAnime];
    
    self.navigationItem.title = self.listTitle;
    
    // Set up TableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - Fetching Data using SUKAPIManager -- To Be Deleted Once I Start Passing Data In


/*
- (void) topAnime {
    [[SUKAPIManager shared] fetchTopAnime:^(NSArray *anime, NSError *error) {
        if (anime != nil) {
            NSString *title = @"Top Anime";
            [self.arrOfAnime setObject:title forKey:@"header"];
            [self.arrOfAnime setObject:anime forKey:@"anime"];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}*/

#pragma mark - TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrOfAnime.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SUKAnimeListTableViewCell";
    SUKAnimeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    Anime *animeToDisplay = self.arrOfAnime[indexPath.row];
    
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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString: @"DetailsSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell: (SUKAnimeListTableViewCell*) sender];
        Anime *dataToPass = self.arrOfAnime[indexPath.row];
        SUKDetailsViewController *detailVC = [segue destinationViewController];
        detailVC.animeToDisplay = dataToPass;
    }
}


@end
