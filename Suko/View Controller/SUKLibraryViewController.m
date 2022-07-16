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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.animeToPass removeAllObjects];
    NSArray *arrOfMalID = [PFUser currentUser][@"list_data"][indexPath.row];
    
    if(arrOfMalID.count == 0) {
        [self performSegueWithIdentifier:@"LibraryToListSegue" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
    }
    
    for(int i = 0; i < arrOfMalID.count; i++) {
        NSNumber *malID = [arrOfMalID objectAtIndex:i];
        [[SUKAPIManager shared] fetchSpecificAnimeByID:malID completion:^(SUKAnime *anime, NSError *error) {
             if (anime != nil) {
                     [self.animeToPass addObject:anime];
                 
                 if(i == arrOfMalID.count - 1) {
                     [self performSegueWithIdentifier:@"LibraryToListSegue" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
                 }
             } else {
                 NSLog(@"%@", error.localizedDescription);
             }
         }];
        
        [NSThread sleepForTimeInterval:0.4];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"LibraryToListSegue"]) {
        SUKAnimeListViewController *animeListVC = [segue destinationViewController];
        
        SUKLibraryTableViewCell *cell = sender;
        animeListVC.listTitle = cell.listTitleLabel.text;
        animeListVC.userToDisplay = [PFUser currentUser];
        
        animeListVC.arrOfAnime = self.animeToPass;
    }
}

@end
