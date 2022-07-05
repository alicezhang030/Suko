//
//  SUKHomeViewController.m
//  Suko
//
//  Created by Alice Zhang on 6/29/22.
//

#import "SUKHomeViewController.h"
#import "SUKAPIManager.h"

@interface SUKHomeViewController ()
@property (strong, nonatomic) NSArray *arrayOfTopAnime;
@end

@implementation SUKHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
    [[SUKAPIManager shared] fetchTopAnime:^(NSArray *animes, NSError *error){
        if (animes) {
            NSLog(@"😎 Successfully fetched top anime");
            self.arrayOfTopAnime = animes;
        } else {
            NSLog(@"😫 Error fetching top anime: %@", error.localizedDescription);
        }
    }];*/
}

/*
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
