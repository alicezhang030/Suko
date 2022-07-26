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
    [self.spinner startAnimating];
    
    // Fetch movies to initially display
    __weak __typeof(self) weakSelf = self;
    [[SUKAPIManager shared] fetchTopMovies:^(NSArray<SUKMovie *> *movies, NSError *error) {
        __strong __typeof(self) strongSelf = weakSelf;
        if(movies != nil) {
            strongSelf.movies = [movies mutableCopy];

            self.frontCardView = [self popMovieViewWithFrame:[self frontCardViewFrame]];
            [self.view addSubview:self.frontCardView];

            self.backCardView = [self popMovieViewWithFrame:[self backCardViewFrame]];
            [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        } else {
            NSLog(@"%@", error.localizedDescription);
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
    
    if(self.frontCardView == nil) { // There are no more movies to display.
        NSMutableDictionary<NSNumber *, NSNumber *> *genreCount = [self countGenreOfSelectedMovies:self.selectedMovies];
        
        __weak __typeof(self) weakSelf = self;
        [self movieGenreList:^(NSArray<NSDictionary *> *genres, NSError *error) {
            if(error == nil) {
                __strong __typeof(self) strongSelf = weakSelf;
                
                NSMutableDictionary<NSNumber *, NSString *> *movieGenres = [NSMutableDictionary new]; // Key: genre ID, Value: genre title
                for(NSDictionary *genre in genres) {
                    [movieGenres setObject:genre[@"name"] forKey:genre[@"id"]];
                }
                
                [strongSelf animeRecsGivenFrequencyOfGenresInSelectedMovies:genreCount withMovieGenreOptions:movieGenres completion:^(NSError *error) {
                    if(error == nil) {
                        [strongSelf performSegueWithIdentifier:@"SwipeQuizToListSegue" sender:self.animeRecommendations];
                    }
                }];
            } else {
                NSLog(@"%@", error.localizedDescription);
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

- (void)movieGenreList:(void(^)(NSArray<NSDictionary *> *genres, NSError *error))completion {
    [[SUKAPIManager shared] fetchMovieGenres:^(NSArray<NSDictionary *> *genres, NSError *error) {
        if(genres != nil) {
            completion(genres, nil);
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)animeRecsGivenFrequencyOfGenresInSelectedMovies:(NSMutableDictionary<NSNumber *, NSNumber *> *) genreIDsAndFrequency withMovieGenreOptions:(NSMutableDictionary<NSNumber *, NSString *> *) genreOptions completion:(void(^)(NSError *error)) completion {
    NSDictionary<NSString *,NSString *> *movieGenreToAnimeGenre = @{@"Family":@"Kids", @"Adventure":@"Adventure", @"Romance":@"Romance", @"Drama":@"Drama", @"Mystery":@"Mystery", @"Crime":@"Organized Crime", @"War":@"Military", @"Action":@"Action", @"Science Fiction":@"Sci-Fi", @"Music":@"Music", @"Western":@"None", @"History":@"Historical", @"Documentary":@"None", @"Comedy":@"Comedy", @"Fantasy":@"Fantasy", @"TV Movie":@"None", @"Animation":@"None", @"Thriller":@"Suspense", @"Horror":@"Horror"};
    
    NSArray<NSNumber *> *selectedMovieGenreIDs = [genreIDsAndFrequency allKeys];
    NSNumber *totalGenreOccurences = [[genreIDsAndFrequency allValues] valueForKeyPath:@"@sum.self"];
    
    for(int i = 0; i < selectedMovieGenreIDs.count; i++) {
        NSString *correspondingAnimeGenreName = [movieGenreToAnimeGenre objectForKey:[genreOptions objectForKey:selectedMovieGenreIDs[i]]];
        
        if(correspondingAnimeGenreName != nil && ![correspondingAnimeGenreName isEqualToString:@"None"]) { // If there is a matching anime genre to this movie genre
            // Calculate the number of recommendations to retrive from this genre based on its frequency
            NSNumber *genreFrequency = [genreIDsAndFrequency objectForKey:selectedMovieGenreIDs[i]];
            double roundedLimitDouble = round(([genreFrequency doubleValue] / [totalGenreOccurences doubleValue])  * kAnimeRecLimit);
            NSNumber *roundedLimit = [NSNumber numberWithDouble:roundedLimitDouble];
            
            NSString *correspondingAnimeGenreID = [[self.animeGenres allKeysForObject:correspondingAnimeGenreName] lastObject];
            __weak __typeof(self) weakSelf = self;
            [[SUKAPIManager shared] fetchAnimeFromGenre:correspondingAnimeGenreID withLimit:roundedLimit completion:^(NSArray<SUKAnime *> *animes, NSError *error) {
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
