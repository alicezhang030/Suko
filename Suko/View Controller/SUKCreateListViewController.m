//
//  SUKCreateListViewController.m
//  Suko
//
//  Created by Alice Zhang on 8/4/22.
//

#import "SUKCreateListViewController.h"
#import "Parse/Parse.h"
#import "SUKConstants.h"
#import "SUKAnimeListViewController.h"

@interface SUKCreateListViewController ()
@property (weak, nonatomic) IBOutlet UITextField *listNameTextField;

@end

@implementation SUKCreateListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard{
    [self.listNameTextField resignFirstResponder];
}

- (IBAction)pressCreate:(id)sender {
    NSMutableArray<NSString *> *currentListTitles = [PFUser currentUser][kPFUserListTitlesKey];
    NSMutableArray<NSMutableArray *> *currentListData = [PFUser currentUser][kPFUserListDataKey];
    
    [currentListTitles addObject:self.listNameTextField.text];
    [currentListData addObject:[NSMutableArray new]];
    
    [PFUser currentUser][kPFUserListTitlesKey] = currentListTitles;
    [PFUser currentUser][kPFUserListDataKey] = currentListData;
    
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(error != nil) {
                NSLog(@"Error creating new list: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully saved new list %@", self.listNameTextField.text);
                [self performSegueWithIdentifier:kCreateListToAnimeListSegueIdentifier sender:nil];
            }
    }];
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:kCreateListToAnimeListSegueIdentifier]) {
        SUKAnimeListViewController *animeListVC = [segue destinationViewController];
        animeListVC.listTitle = self.listNameTextField.text;
        animeListVC.arrOfAnime = [NSMutableArray new];
    }
}


@end
