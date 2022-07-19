//
//  SUKBrowseEventViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/19/22.
//

#import "SUKBrowseEventViewController.h"
#import "SUKEvent.h"
#import "SUKEventTableViewCell.h"

@interface SUKBrowseEventViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<SUKEvent*> *arrOfEvents;

@end

@implementation SUKBrowseEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.arrOfEvents = [[NSArray alloc] init];
    
    [self events];
}

- (void)events {
    PFQuery *query = [PFQuery queryWithClassName:@"SUKEvent"];
    [query includeKey:@"location"];
    [query whereKey:@"location" nearGeoPoint:[PFUser currentUser][@"current_coordinates"] withinMiles:5.0];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray<SUKEvent *> *events, NSError *error) {
        for(PFUser *event in events) {
            NSMutableArray *mutableArrOfEvents = [self.arrOfEvents mutableCopy];
            [mutableArrOfEvents addObject:event];
            self.arrOfEvents = [mutableArrOfEvents copy];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrOfEvents.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SUKEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SUKEventTableViewCell"];
    SUKEvent *eventToDisplay = self.arrOfEvents[indexPath.row];
    [cell setEvent:eventToDisplay];
    
    return cell;
}

@end
