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
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@end

@implementation SUKCreateListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.createButton.layer.cornerRadius = 4;
    self.createButton.layer.masksToBounds = true;
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
    
    __weak __typeof(self) weakSelf = self;
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        __strong __typeof(self) strongSelf = weakSelf;
        if(error != nil) {
            NSLog(@"Error creating new list: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully saved new list %@", self.listNameTextField.text);
            
            NSArray<UIViewController *> *viewControllers = [strongSelf.navigationController viewControllers];
            [strongSelf.navigationController popToViewController:viewControllers[0] animated:YES]; // Navigate back to original library VC
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
