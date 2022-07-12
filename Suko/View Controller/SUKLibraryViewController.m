//
//  SUKLibraryViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/8/22.
//

#import "SUKLibraryViewController.h"
#import "SUKLibraryTableViewCell.h"
#import "SUKAnimeListViewController.h"
#import "SUKUsersLists.h"
#import "SUKAPIManager.h"

@interface SUKLibraryViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listTitles;
@property (nonatomic, strong) NSMutableDictionary<NSString*, NSMutableArray*> *dictionaryOfAnime;

@end

@implementation SUKLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up TableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
        
    self.dictionaryOfAnime = [[NSMutableDictionary alloc] init];
    [self.dictionaryOfAnime setObject: [NSMutableArray array] forKey:@"Want to Watch"];
    [self.dictionaryOfAnime setObject: [NSMutableArray array] forKey:@"Watching"];
    [self.dictionaryOfAnime setObject: [NSMutableArray array] forKey:@"Watched"];
    
    self.listTitles = [@[@"Want to Watch", @"Watching", @"Watched"] mutableCopy];
}

#pragma mark - TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dictionaryOfAnime count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SUKLibraryTableViewCell";
    SUKLibraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.listTitleLabel.text = self.listTitles[indexPath.row];
    return cell;
}

#pragma mark - Navigation

- (void)segueSUKHomeTableViewCell:(SUKLibraryTableViewCell *) cell {
    NSMutableDictionary *senderDict = [[NSMutableDictionary alloc] init];
    [senderDict setObject:cell.listTitleLabel.text forKey:@"title"];
    [senderDict setObject:[self.dictionaryOfAnime objectForKey:cell.listTitleLabel.text] forKey:@"anime"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"LibraryToListSegue"]) {
        SUKAnimeListViewController *animeListVC = [segue destinationViewController];
        SUKLibraryTableViewCell *cell = sender;
        animeListVC.listTitle = cell.listTitleLabel.text;
        animeListVC.arrOfAnime = [NSMutableArray array];
    }
}

@end
