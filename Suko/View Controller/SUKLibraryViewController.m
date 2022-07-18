//
//  SUKLibraryViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/8/22.
//

#import "SUKLibraryViewController.h"
#import "SUKLibraryTableViewCell.h"
#import "SUKAnimeListViewController.h"
#import "SUKAPIManager.h"

@interface SUKLibraryViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *listTitles;
@property (nonatomic, strong) NSMutableSet *animeToPassMalID;
@property (nonatomic, strong) NSMutableArray *animeToPass;

@end

@implementation SUKLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up TableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.listTitles = [PFUser currentUser][@"list_titles"];
    self.animeToPass = [NSMutableArray array];
    self.animeToPassMalID = [NSMutableSet set];
}

#pragma mark - TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listTitles count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SUKLibraryTableViewCell";
    SUKLibraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.listTitleLabel.text = self.listTitles[indexPath.row];
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"LibraryToListSegue"]) {
        SUKAnimeListViewController *animeListVC = [segue destinationViewController];
        
        SUKLibraryTableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        animeListVC.listTitle = cell.listTitleLabel.text;
        animeListVC.userToDisplay = [PFUser currentUser];
        
        animeListVC.arrOfAnimeMALID = @[@185, @43608];
        //[PFUser currentUser][@"list_data"][indexPath.row];
        animeListVC.arrOfAnime = [[NSArray alloc] init];
    }
}

@end
