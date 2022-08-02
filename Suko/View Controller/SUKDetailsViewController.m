//
//  SUKDetailsViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/8/22.
//

#import "SUKDetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface SUKDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfEpLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet MKDropdownMenu *dropdownMenu;

@property (strong, nonatomic) NSArray<NSString *> *listOptions;
@end

@implementation SUKDetailsViewController
NSString * const kListDataDictionaryKey = @"list_data";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *animePosterURLString = self.animeToDisplay.posterURL;
    NSURL *url = [NSURL URLWithString:animePosterURLString];
    if(url != nil) {
        [self.posterView setImageWithURL:url];
    }
    
    self.titleLabel.text = self.animeToDisplay.title;
    self.synopsisLabel.text = self.animeToDisplay.synopsis;
    
    NSString *numOfEpString = [NSString stringWithFormat:@"%d", self.animeToDisplay.numEpisodes];
    self.numOfEpLabel.text = [numOfEpString stringByAppendingString:@" Episodes"];
    
    self.listOptions = @[@"Remove from lists", @"Want to Watch", @"Watching", @"Watched"];
    self.dropdownMenu.backgroundDimmingOpacity = 0.00;
    self.dropdownMenu.dropdownCornerRadius = 4.0;
    self.dropdownMenu.layer.cornerRadius = 4;
    self.dropdownMenu.layer.masksToBounds = true;
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];

  if (self.isMovingFromParentViewController) {
      [self.dropdownMenu closeAllComponentsAnimated:YES];
  }
}

#pragma mark - MKDropdownMenuDataSource

- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu {
    return 1;
}

- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component {
    return self.listOptions.count;
}

#pragma mark - MKDropdownMenuDelegate

- (NSString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu titleForComponent:(NSInteger)component {
    return @"Add to list";
}
- (NSString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.listOptions[row];
}

- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSMutableArray<NSMutableArray *> *currentAllData = [PFUser currentUser][kListDataDictionaryKey];
    NSNumber *malID = [NSNumber numberWithInt:self.animeToDisplay.malID];
    
    if(row == 0) { // User clicked on "remove from lists"
        for(int i = 0; i < [currentAllData count]; i++) {
            if([currentAllData[i] containsObject:malID]) {
                [currentAllData[i] removeObject:malID];
                break;
            }
        }
        
        [PFUser currentUser][kListDataDictionaryKey] = currentAllData;
        [[PFUser currentUser] saveInBackground];
        [self.dropdownMenu closeAllComponentsAnimated:YES];
    } else {
        for(int i = 0; i < [currentAllData count]; i++) {
            // row - 1 because row 0 is "Remove from List"
            if([currentAllData[i] containsObject:malID]) {
                [currentAllData[i] removeObject:malID];
                break;
            }
        }
        
        [currentAllData[row-1] addObject:malID];
        [PFUser currentUser][kListDataDictionaryKey] = currentAllData;
        [[PFUser currentUser] saveInBackground];
        [self.dropdownMenu closeAllComponentsAnimated:YES];
    }
}

@end
