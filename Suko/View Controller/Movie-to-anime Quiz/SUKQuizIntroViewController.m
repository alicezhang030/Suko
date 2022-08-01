//
//  SUKQuizIntroViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/27/22.
//

#import "SUKQuizIntroViewController.h"
#import "SUKSwipeMovieViewController.h"

@interface SUKQuizIntroViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@end

@implementation SUKQuizIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.startButton.layer.cornerRadius = 4;
    self.startButton.layer.masksToBounds = true;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"QuizStartSegue"]) {
        SUKSwipeMovieViewController *swipeVC = [segue destinationViewController];
        swipeVC.animeGenres = self.animeGenres;
    }
}


@end
