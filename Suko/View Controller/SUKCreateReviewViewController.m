//
//  SUKCreateReviewViewController.m
//  Suko
//
//  Created by Alice Zhang on 8/5/22.
//

#import "SUKCreateReviewViewController.h"
#import "HCSStarRatingView.h"
#import "SUKReview.h"

@interface SUKCreateReviewViewController () <UITextViewDelegate>
@property (nonatomic, strong) NSNumber *animeBeingReviewedID;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starReview;
@end

@implementation SUKCreateReviewViewController

NSString * const ktextViewPlaceHolder = @"I really enjoyed this anime. It made me cry, laugh, and scream. I especially enjoyed the main character's relationship with his friends. It was so wholesome! I don't want to say too much in fear of spoiling. Definitely give this anime a shot!";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.delegate = self;
    self.textView.textColor = [UIColor lightGrayColor];
    self.textView.text = ktextViewPlaceHolder;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    [self.textView resignFirstResponder];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if(self.textView.textColor == [UIColor lightGrayColor]) {
        self.textView.text = @"";
        self.textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if([self.textView.text isEqualToString:@""]) {
        self.textView.text = ktextViewPlaceHolder;
        self.textView.textColor = [UIColor lightGrayColor];
    }
}

- (void)configureViewWithAnime:(SUKAnime *)anime {
    self.animeBeingReviewedID = [NSNumber numberWithInt:anime.malID];
}

- (IBAction)tapSave:(id)sender {
    if(self.textView.textColor == [UIColor lightGrayColor] || self.starReview.value == 0.0) {
        NSString *title = @"Must select stars and write a review.";
        NSString *message = @"Please choose your star rating, write your thoughts in the text box, and try again.";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message
                                    preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{}];
    } else {
        __weak __typeof(self) weakSelf = self;
        [SUKReview postReviewWithAuthor:[PFUser currentUser] reviewContent:self.textView.text starRating:[NSNumber numberWithFloat:self.starReview.value] forAnimeWithID:self.animeBeingReviewedID withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(error != nil) {
                NSLog(@"Problem saving the review: %@", error.localizedDescription);
            } else {
                __strong __typeof(self) strongSelf = weakSelf;
                NSLog(@"The review was uploaded!");
                NSArray<UIViewController *> *viewControllers = [strongSelf.navigationController viewControllers];
                [strongSelf.navigationController popToViewController:viewControllers[1] animated:YES];
            }
        }];
    }
}

@end
