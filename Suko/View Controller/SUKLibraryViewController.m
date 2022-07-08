//
//  SUKLibraryViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/8/22.
//

#import "SUKLibraryViewController.h"
#import "SUKLibraryTableViewCell.h"

@interface SUKLibraryViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *lists;

@end

@implementation SUKLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up TableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.lists = [@[@"Want to Watch", @"Watching", @"Watched"] mutableCopy];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.lists count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SUKLibraryTableViewCell";
    SUKLibraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.listTitleLabel.text = self.lists[indexPath.row];
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
