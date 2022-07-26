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
@end

@implementation SUKSwipeMovieViewController

#pragma mark - UIViewController Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedMovies = [NSMutableArray new];
    self.animeRecommendations = [NSMutableArray new];
    self.animeRecommendationIDs = [NSMutableArray new];
    
    self.spinner.hidesWhenStopped = YES;
    self.spinner.layer.cornerRadius = 10;
    [self.spinner setCenter:CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0)];
    [self.spinner startAnimating];
    
    __weak __typeof(self) weakSelf = self;
    [[SUKAPIManager shared] fetchPopularMovieList:^(NSArray<SUKMovie *> *movies, NSError *error) {
        __strong __typeof(self) strongSelf = weakSelf;
        if(movies != nil) {
            strongSelf.movies = [movies mutableCopy];
            
            // Display the first ChoosePersonView in front. Users can swipe to indicate
            // whether they like or dislike the person displayed.
            self.frontCardView = [self popMovieViewWithFrame:[self frontCardViewFrame]];
            [self.view addSubview:self.frontCardView];
            
            // Display the second ChoosePersonView in back. This view controller uses
            // the MDCSwipeToChooseDelegate protocol methods to update the front and
            // back views after each user swipe.
            self.backCardView = [self popMovieViewWithFrame:[self backCardViewFrame]];
            [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        
        [self.spinner stopAnimating];
    }];
}

#pragma mark - MDCSwipeToChooseDelegate Protocol Methods

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"You couldn't decide on %@.", self.currentMovie.title);
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    // MDCSwipeToChooseView shows "NOPE" on swipes to the left,
    // and "LIKED" on swipes to the right.
    if (direction == MDCSwipeDirectionLeft) {
        NSLog(@"You noped %@.", self.currentMovie.title);
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
    
    if(self.frontCardView == nil) {
        [self.spinner startAnimating];
        NSMutableDictionary<NSNumber *, NSNumber *> *genreCount = [self countGenreOfSelectedMovies:self.selectedMovies];
        NSArray<NSNumber *> *sortedMovieGenreIDs = [self sortMovieGenreIDsBySelectionCount:genreCount];
        [self animeRecommendationsGivenMovieGenreIDs:sortedMovieGenreIDs];
    }
}

#pragma mark - Internal Methods

- (void)setFrontCardView:(ChooseMovieView *)frontCardView {
    // Keep track of the person currently being chosen.
    // Quick and dirty, just for the purposes of this sample app.
    _frontCardView = frontCardView;
    self.currentMovie = frontCardView.movie;
}

- (ChooseMovieView *)popMovieViewWithFrame:(CGRect)frame {
    if ([self.movies count] == 0) {
        return nil;
    }

    // UIView+MDCSwipeToChoose and MDCSwipeToChooseView are heavily customizable.
    // Each take an "options" argument. Here, we specify the view controller as
    // a delegate, and provide a custom callback that moves the back card view
    // based on how far the user has panned the front card view.
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 160.f; // distance in pixels that a view must be panned in order to constitue a selection
    options.onPan = ^(MDCPanState *state){
        CGRect frame = [self backCardViewFrame];
        self.backCardView.frame = CGRectMake(frame.origin.x,
                                             frame.origin.y - (state.thresholdRatio * 10.f),
                                             CGRectGetWidth(frame),
                                             CGRectGetHeight(frame));
    };

    // Create a movieView with the top movie in the movies array, then pop
    // that movie off the stack.
    ChooseMovieView *movieView = [[ChooseMovieView alloc] initWithFrame:frame
                                                                    movie:self.movies[0]
                                                                   options:options];
    [self.movies removeObjectAtIndex:0];
    return movieView;
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

- (NSArray<NSNumber *> *) sortMovieGenreIDsBySelectionCount:(NSMutableDictionary<NSNumber *, NSNumber *> *) genreCount {
    NSArray<NSNumber *> *sortedMovieGenreIDs = [genreCount keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
        if ([obj1 intValue] > [obj2 intValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        } else if ([obj1 intValue] < [obj2 intValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    return sortedMovieGenreIDs;
}

- (void) animeRecommendationsGivenMovieGenreIDs:(NSArray<NSNumber *> *) movieGenreIDs{
    __weak __typeof(self) weakSelf = self;
    [self movieGenreList:^(NSArray<NSDictionary *> *genres, NSError *error) {
        __strong __typeof(self) strongSelf = weakSelf;
        NSMutableDictionary<NSNumber *, NSString *> *movieGenres = [NSMutableDictionary new];
        for(NSDictionary *genre in genres) {
            [movieGenres setObject:genre[@"name"] forKey:genre[@"id"]];
        }
        
        [strongSelf animeRecsGivenMovieGenreIDs:movieGenreIDs withMovieGenreOptions:movieGenres completion:^(NSError *error) {
            if(error == nil) {
                [self.spinner stopAnimating];
                [strongSelf performSegueWithIdentifier:@"SwipeQuizToListSegue" sender:self.animeRecommendations];
            }
        }];
    }];
}

- (void)movieGenreList:(void(^)(NSArray<NSDictionary *> *genres, NSError *error))completion {
    [[SUKAPIManager shared] fetchMovieGenreList:^(NSArray<NSDictionary *> *genres, NSError *error) {
        if(genres != nil) {
            completion(genres, nil);
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)animeRecsGivenMovieGenreIDs:(NSArray<NSNumber *> *) movieGenreIDs withMovieGenreOptions:(NSMutableDictionary<NSNumber *, NSString *> *) genreOptions completion:(void(^)(NSError *error)) completion {
    
    NSDictionary<NSString *,NSString *> *movieGenreToAnimeGenre = @{@"Family":@"Kids", @"Adventure":@"Adventure", @"Romance":@"Romance", @"Drama":@"Drama", @"Mystery":@"Mystery", @"Crime":@"Organized Crime", @"War":@"Military", @"Action":@"Action", @"Science Fiction":@"Sci-Fi", @"Music":@"Music", @"Western":@"None", @"History":@"Historical", @"Documentary":@"None", @"Comedy":@"Comedy", @"Fantasy":@"Fantasy", @"TV Movie":@"None", @"Animation":@"None", @"Thriller":@"Suspense", @"Horror":@"Horror"};
    
    for(int i = 0; i < movieGenreIDs.count; i++) {
        NSString *correspondingAnimeGenreName = [movieGenreToAnimeGenre objectForKey:[genreOptions objectForKey:movieGenreIDs[i]]];
        
        if(correspondingAnimeGenreName != nil && ![correspondingAnimeGenreName isEqualToString:@"None"]) {
            NSString *correspondingAnimeGenreID = [[self.animeGenres allKeysForObject:correspondingAnimeGenreName] lastObject];
            
            __weak __typeof(self) weakSelf = self;
            [[SUKAPIManager shared] fetchAnimeListWithGenre:correspondingAnimeGenreID completion:^(NSArray<SUKAnime *> *animes, NSError *error) {
                __strong __typeof(self) strongSelf = weakSelf;
                if (animes != nil) {
                    for(SUKAnime *anime in animes) {
                        if(![strongSelf.animeRecommendationIDs containsObject:[NSNumber numberWithInt:anime.malID]]) {
                            [strongSelf.animeRecommendationIDs addObject:[NSNumber numberWithInt:anime.malID]];
                            [strongSelf.animeRecommendations addObject:anime];
                        }
                    }
                } else {
                    NSLog(@"%@", error.localizedDescription);
                }
                
                if(i == movieGenreIDs.count - 1) {
                    NSLog(@"Recommendation algorithm finished.");
                    completion(nil);
                }
            }];
            
            [NSThread sleepForTimeInterval:1.0];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString: @"SwipeQuizToListSegue"]) {
        SUKAnimeListViewController *listVC = [segue destinationViewController];
        listVC.listTitle = @"Recommendations";
        listVC.arrOfAnime = sender;
    }
}


@end
