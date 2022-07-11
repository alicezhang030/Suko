//
//  SUKDetailsViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/8/22.
//

#import "SUKDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "SUKUsersLists.h"

@interface SUKDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfEpLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;

@property (strong, nonatomic) NSArray<NSString *> *listOptions;

@end

@implementation SUKDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *animePosterURLString = self.animeToDisplay.posterURL;
    NSURL *url = [NSURL URLWithString:animePosterURLString];
    if(url != nil) {
        [self.posterView setImageWithURL:url];
    }
    
    self.titleLabel.text = self.animeToDisplay.title;
    self.synopsisLabel.text = self.animeToDisplay.synopsis;
    
    NSString *numOfEpString = [NSString stringWithFormat:@"%d", self.animeToDisplay.episodes];
    self.numOfEpLabel.text = [numOfEpString stringByAppendingString:@" Episodes"];
    
    self.listOptions = @[@"Remove from lists", @"Want to Watch", @"Watching", @"Watched"];
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
    [SUKUsersLists postUsersLists:[PFUser currentUser] defaultList:row malId:[NSNumber numberWithInt:self.animeToDisplay.malID] withCompletion:^(BOOL succeeded, NSError * error) {
        if (succeeded) {
            NSLog(@"The SUKUsersLists was uploaded!");
        } else {
            NSLog(@"Problem uploading the Like: %@", error.localizedDescription);
        }
    }];
}

#pragma mark - MKDropdownMenuDelegate


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
