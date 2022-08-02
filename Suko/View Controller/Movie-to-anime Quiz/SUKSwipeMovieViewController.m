//
//  SUKSwipeMovieViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/26/22.
//

#import "SUKSwipeMovieViewController.h"
#import "SUKAPIManager.h"
#import "SUKAnimeListViewController.h"

@interface SUKSwipeMovieViewController ()
@property (nonatomic, strong) NSMutableArray<SUKMovie *> *movies;
@property (nonatomic, strong) NSMutableArray<SUKMovie *> *selectedMovies;
@property (nonatomic, strong) NSMutableArray<SUKAnime *> *animeRecommendations;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *animeRecommendationIDs;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (nonatomic, strong) NSNumber *topMoviePageCount;
@end

@implementation SUKSwipeMovieViewController
CGFloat const kAnimeRecLimit = (CGFloat)20.0;

#pragma mark - UIViewController Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup properties
    self.selectedMovies = [NSMutableArray new];
    self.animeRecommendations = [NSMutableArray new];
    self.animeRecommendationIDs = [NSMutableArray new];
    
    // Spinner
    self.spinner.hidesWhenStopped = YES;
    self.spinner.layer.cornerRadius = 10;
    [self.spinner setCenter:CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0)];
    
    self.topMoviePageCount = @1;
    [self topMoviesFromPage:self.topMoviePageCount];
}

- (void)topMoviesFromPage:(NSNumber *)page {
    __weak __typeof(self) weakSelf = self;
    [[SUKAPIManager shared] fetchTopMoviesFromPage:page completion:^(NSArray<SUKMovie *> *movies, NSError *error) {
        __strong __typeof(self) strongSelf = weakSelf;
        if(error != nil) {
            NSString *title = @"Unable to load movies";
            NSString *message = [error.localizedDescription stringByAppendingString:@" Please try again."];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message
                                        preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {}];
            [alert addAction:okAction];
            [strongSelf presentViewController:alert animated:YES completion:^{}];
            
            NSLog(@"Failed to retrive top movies: %@", error.localizedDescription);
        } else {
            strongSelf.movies = [movies mutableCopy];

            self.frontCardView = [self popMovieViewWithFrame:[self frontCardViewFrame]];
            [self.view addSubview:self.frontCardView];

            self.backCardView = [self popMovieViewWithFrame:[self backCardViewFrame]];
            [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        }
    }];
}

#pragma mark - MDCSwipeToChooseDelegate Protocol Methods

// Called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"You couldn't decide on %@.", self.currentMovie.title);
}

// Called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    if (direction == MDCSwipeDirectionLeft) {
        NSLog(@"You disliked %@.", self.currentMovie.title);
    } else {
        NSLog(@"You liked %@.", self.currentMovie.title);
        [self.selectedMovies addObject:self.currentMovie];
    }

    // MDCSwipeToChooseView removes the view from the view hierarchy
    // after it is swiped (this behavior can be customized via the
    // MDCSwipeOptions class). Since the front card view is gone, we
    // move the back card to the front, and create a new back card.
    self.frontCardView = self.backCardView;
    if ((self.backCardView = [self popMovieViewWithFrame:[self backCardViewFrame]])) {
        // Fade the back card into view.
        self.backCardView.alpha = 0.f;
        [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.backCardView.alpha = 1.f;
                         } completion:nil];
    }
    
    if(self.frontCardView == nil && self.backCardView == nil) { // There are no more movies to display.
        [self noMoreMoviesView];
    }
}

- (void)noMoreMoviesView {
    UIView *noMoreMoviesView = [[UIView alloc] initWithFrame:self.view.frame];
    noMoreMoviesView.tag = 1000; // Set tag to assist in removing this view later
    
    UILabel *loadMoreMoviesLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 70, CGRectGetWidth(self.view.frame), 20)];
    loadMoreMoviesLabel.backgroundColor = [UIColor clearColor];
    loadMoreMoviesLabel.textAlignment = NSTextAlignmentCenter;
    loadMoreMoviesLabel.textColor = [UIColor blackColor];
    loadMoreMoviesLabel.numberOfLines = 0;
    loadMoreMoviesLabel.lineBreakMode = NSLineBreakByWordWrapping;
    loadMoreMoviesLabel.text = @"Would you like to swipe on more movies?";
    [loadMoreMoviesLabel setCenter:CGPointMake(CGRectGetWidth(self.view.frame)/2.0, CGRectGetHeight(self.view.frame)/2.0 - (40 + 10))];
    
    UIButton *loadMoreMoviesButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [loadMoreMoviesButton addTarget:self action:@selector(tappedLoadMore) forControlEvents:UIControlEventTouchUpInside];
    [loadMoreMoviesButton setTitle:@"Load more" forState:UIControlStateNormal];
    loadMoreMoviesButton.frame = CGRectMake((self.view.frame.size.width - 160)/2, (self.view.frame.size.height - 40)/2, 160, 40);
    [loadMoreMoviesButton setBackgroundColor:[UIColor colorWithRed:0.76078431372 green:0.56470588235 blue:1.0 alpha:1.0]];
    [loadMoreMoviesButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIButton *recommendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [recommendButton addTarget:self action:@selector(tappedRecommendAnimeButton) forControlEvents:UIControlEventTouchUpInside];
    [recommendButton setTitle:@"Recommend anime" forState:UIControlStateNormal];
    recommendButton.frame = CGRectMake((self.view.frame.size.width - 160)/2, (self.view.frame.size.height - 40)/2 + (40 + 10), 160, 40);
    [recommendButton setBackgroundColor:[UIColor colorWithRed:0.76078431372 green:0.56470588235 blue:1.0 alpha:1.0]];
    [recommendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    loadMoreMoviesButton.layer.cornerRadius = 4;
    recommendButton.layer.cornerRadius = 4;
    loadMoreMoviesButton.layer.masksToBounds = true;
    recommendButton.layer.masksToBounds = true;

    [noMoreMoviesView addSubview:loadMoreMoviesLabel];
    [noMoreMoviesView addSubview:loadMoreMoviesButton];
    [noMoreMoviesView addSubview:recommendButton];
    
    [self.view addSubview:noMoreMoviesView];
}

- (void)tappedLoadMore {
    self.topMoviePageCount = [NSNumber numberWithInt:([self.topMoviePageCount intValue] + 1)];
    [self topMoviesFromPage:self.topMoviePageCount];
    
    // Remove the no more movies subview
    for(UIView *subView in self.view.subviews) {
        if(subView.tag == 1000) {
            [subView removeFromSuperview];
        }
    }
}

- (void)tappedRecommendAnimeButton {
    if(self.selectedMovies.count == 0) {
        NSString *title = @"Must select movies";
        NSString *message = @"Please swipe right on at least one movie and then try again.";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                       message:message
                                                                preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{}];
    } else {
        [self.view bringSubviewToFront:self.spinner];
        [self.spinner startAnimating];
        
        NSMutableDictionary<NSNumber *, NSNumber *> *genreCount = [self countGenreOfSelectedMovies:self.selectedMovies];
        
        __weak __typeof(self) weakSelf = self;
        [self movieGenreList:^(NSArray<NSDictionary *> *genres, NSError *error) {
            __strong __typeof(self) strongSelf = weakSelf;
            if(error != nil) {
                NSString *title = @"Something went wrong...";
                NSString *message = [error.localizedDescription stringByAppendingString:@" Please try again."];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message
                                            preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {}];
                [alert addAction:okAction];
                [strongSelf presentViewController:alert animated:YES completion:^{}];
                
                NSLog(@"Failed to fetch movie genres: %@", error.localizedDescription);
            } else {
                NSMutableDictionary<NSNumber *, NSString *> *movieGenres = [NSMutableDictionary new]; // Key: genre ID, Value: genre title
                for(NSDictionary *genre in genres) {
                    [movieGenres setObject:genre[@"name"] forKey:genre[@"id"]];
                }
                
                [strongSelf animeRecsGivenFrequencyOfGenresInSelectedMovies:genreCount withMovieGenreOptions:movieGenres completion:^(NSError *error) {
                    if(error != nil) {
                        NSLog(@"Failed to load recommentations: %@", error.localizedDescription);
                    } else {
                        [self.spinner stopAnimating];
                        [strongSelf performSegueWithIdentifier:@"SwipeQuizToListSegue" sender:self.animeRecommendations];
                    }
                }];
            }
        }];
    }
}

#pragma mark - Internal Methods

- (void)setFrontCardView:(ChooseMovieView *)frontCardView {
    // Keep track of the movie currently being chosen.
    _frontCardView = frontCardView;
    self.currentMovie = frontCardView.movie;
}

- (ChooseMovieView *)popMovieViewWithFrame:(CGRect)frame {
    if ([self.movies count] == 0) {
        return nil;
    }

    // UIView+MDCSwipeToChoose and MDCSwipeToChooseView each take an "options" argument.
    // Here, we specify the view controller as a delegate,
    // and provide a custom callback that moves the back card view
    // based on how far the user has panned the front card view.
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 160.f; // Distance in pixels that a view must be panned in order to constitue a selection
    options.onPan = ^(MDCPanState *state){
        CGRect frame = [self backCardViewFrame];
        self.backCardView.frame = CGRectMake(frame.origin.x,
                                             frame.origin.y - (state.thresholdRatio * 10.f),
                                             CGRectGetWidth(frame),
                                             CGRectGetHeight(frame));
    };
    options.likedText = @"Like";
    options.nopeText = @"Dislike";
    
    // Create a movieView with the top movie in the movies array, then pop
    // that movie off the stack.
    ChooseMovieView *movieView = [[ChooseMovieView alloc] initWithFrame:frame movie:self.movies[0] options:options];
    [self.movies removeObjectAtIndex:0];
    
    UITapGestureRecognizer *cardTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTappedCard:)];
    cardTapRecognizer.numberOfTapsRequired = 2;
    [movieView addGestureRecognizer:cardTapRecognizer];
    
    return movieView;
}

- (void)doubleTappedCard:(UITapGestureRecognizer *)sender {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionRight];
}

#pragma mark View Construction

- (CGRect)frontCardViewFrame {
    CGFloat horizontalPadding = 20.f;
    CGFloat topPadding = 100.f;
    CGFloat bottomPadding = 230.f;
    return CGRectMake(horizontalPadding,
                      topPadding,
                      CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
                      CGRectGetHeight(self.view.frame) - bottomPadding);
}

- (CGRect)backCardViewFrame {
    CGRect frontFrame = [self frontCardViewFrame];
    return CGRectMake(frontFrame.origin.x,
                      frontFrame.origin.y + 10.f,
                      CGRectGetWidth(frontFrame),
                      CGRectGetHeight(frontFrame));
}

#pragma mark - Recommendation Algorithm

- (NSMutableDictionary<NSNumber *, NSNumber *> *)countGenreOfSelectedMovies:(NSArray<SUKMovie *> *) selectedMovies {
    NSMutableDictionary<NSNumber *, NSNumber *> *genreCount = [NSMutableDictionary new];
    for(SUKMovie *selectedMovie in selectedMovies) {
        for(NSNumber *genreID in selectedMovie.genreIDs) {
            if([genreCount objectForKey:genreID] == nil) {
                [genreCount setObject:@1 forKey:genreID];
            } else {
                int updatedCountInt = [[genreCount objectForKey:genreID] intValue] + 1;
                [genreCount setObject:[NSNumber numberWithInt:updatedCountInt] forKey:genreID];
            }
        }
    }
    return genreCount;
}

- (void)movieGenreList:(void(^)(NSArray<NSDictionary *> *genres, NSError *error))completion {
    [[SUKAPIManager shared] fetchMovieGenres:^(NSArray<NSDictionary *> *genres, NSError *error) {
        if(error != nil) {
            completion(nil, error);
        } else {
            completion(genres, nil);
        }
    }];
}

- (void)animeRecsGivenFrequencyOfGenresInSelectedMovies:(NSMutableDictionary<NSNumber *, NSNumber *> *) genreIDsAndFrequency withMovieGenreOptions:(NSMutableDictionary<NSNumber *, NSString *> *) genreOptions completion:(void(^)(NSError *error)) completion {
    // Western, Documentary, TV Movie, and Animation don't match well into any anime genre, so I put "Action" as default
    NSDictionary<NSString *,NSString *> *movieGenreToAnimeGenre = @{@"Family":@"Kids", @"Adventure":@"Adventure", @"Romance":@"Romance", @"Drama":@"Drama", @"Mystery":@"Mystery", @"Crime":@"Organized Crime", @"War":@"Military", @"Action":@"Action", @"Science Fiction":@"Sci-Fi", @"Music":@"Music", @"Western":@"Action", @"History":@"Historical", @"Documentary":@"Action", @"Comedy":@"Comedy", @"Fantasy":@"Fantasy", @"TV Movie":@"Action", @"Animation":@"Action", @"Thriller":@"Suspense", @"Horror":@"Horror"};
    
    NSArray<NSNumber *> *selectedMovieGenreIDs = [genreIDsAndFrequency allKeys];
    NSNumber *totalGenreOccurences = [[genreIDsAndFrequency allValues] valueForKeyPath:@"@sum.self"];
    
    for(int i = 0; i < selectedMovieGenreIDs.count; i++) {
        NSString *correspondingAnimeGenreName = [movieGenreToAnimeGenre objectForKey:[genreOptions objectForKey:selectedMovieGenreIDs[i]]];
        
        if(correspondingAnimeGenreName != nil) { // If there is a matching anime genre for this movie genre
            // Calculate the number of recommendations to retrive from this genre based on its frequency
            NSNumber *genreFrequency = [genreIDsAndFrequency objectForKey:selectedMovieGenreIDs[i]];
            double roundedLimitDouble = round(([genreFrequency doubleValue] / [totalGenreOccurences doubleValue])  * kAnimeRecLimit);
            NSNumber *roundedLimit = [NSNumber numberWithDouble:roundedLimitDouble];
            
            NSString *correspondingAnimeGenreID = [[self.animeGenres allKeysForObject:correspondingAnimeGenreName] lastObject];
            __weak __typeof(self) weakSelf = self;
            [[SUKAPIManager shared] fetchAnimeFromGenre:correspondingAnimeGenreID withLimit:roundedLimit completion:^(NSArray<SUKAnime *> *animes, NSError *error) {
                if(error != nil) {
                    NSLog(@"Failed fo fetch top anime from genre with ID %@: %@", correspondingAnimeGenreID, error.localizedDescription);
                } else {
                    __strong __typeof(self) strongSelf = weakSelf;
                    for(SUKAnime *anime in animes) {
                        if(![strongSelf.animeRecommendationIDs containsObject:[NSNumber numberWithInt:anime.malID]]) {
                            [strongSelf.animeRecommendationIDs addObject:[NSNumber numberWithInt:anime.malID]];
                            [strongSelf.animeRecommendations addObject:anime];
                        }
                    }
                }
                
                if(i == selectedMovieGenreIDs.count - 1) {
                    NSLog(@"Recommendation algorithm finished.");
                    completion(nil);
                }
            }];
            
            [NSThread sleepForTimeInterval:1.0];
        }
    }
    
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString: @"SwipeQuizToListSegue"]) {
        SUKAnimeListViewController *listVC = [segue destinationViewController];
        listVC.listTitle = @"Recommendations";
        listVC.arrOfAnime = sender;
    }
}


@end
