//
//  SUKSwipeMovieViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/26/22.
//

#import "SUKSwipeMovieViewController.h"
#import "SUKAPIManager.h"
#import "SUKAnimeListViewController.h"
#import "SUKConstants.h"
#import "NaturalLanguage/NLEmbedding.h"

@interface SUKSwipeMovieViewController ()
@property (nonatomic, strong) NSMutableArray<SUKMovie *> *topMovies;
@property (nonatomic, strong) NSNumber *topMoviePageCount;

@property (nonatomic, strong) NSMutableArray<SUKMovie *> *selectedMovies;
//@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSString *>*selectedMoviesConglomerateSynopsisByGenreID; Commented out code
@property (nonatomic, strong) NSString *conglomerateSynopsis;

@property (nonatomic, strong) NSMutableSet<SUKAnime *> *animeRecommendations;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation SUKSwipeMovieViewController
CGFloat const kAnimeRecLimit = (CGFloat)15.0;

#pragma mark - UIViewController Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup Properties
    self.selectedMovies = [NSMutableArray new];
    self.animeRecommendations = [NSMutableSet new];
    self.conglomerateSynopsis = @"";
    //self.selectedMoviesConglomerateSynopsisByGenreID = [NSMutableDictionary new]; Commented out code
    
    // Spinner
    self.spinner.hidesWhenStopped = YES;
    self.spinner.layer.cornerRadius = 10;
    [self.spinner setCenter:CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0)];
    
    // Top Movie page Count
    self.topMoviePageCount = @1;
    [self topMoviesFromPage:self.topMoviePageCount];
}

# pragma mark - Fetch Data

- (void)topMoviesFromPage:(NSNumber *)page {
    __weak __typeof(self) weakSelf = self;
    [[SUKAPIManager shared] fetchTopMoviesFromPage:page completion:^(NSArray<SUKMovie *> *movies, NSError *error) {
        __strong __typeof(self) strongSelf = weakSelf;
        if(error != nil) {
            [strongSelf alertWithTitle:@"Unable to load movies" andMessage:[error.localizedDescription stringByAppendingString:@" Please try again."] andActionTitle:@"OK"];
            NSLog(@"Failed to retrive top movies: %@", error.localizedDescription);
        } else {
            strongSelf.topMovies = [movies mutableCopy];
            
            self.frontCardView = [self popMovieViewWithFrame:[self frontCardViewFrame]];
            [self.view addSubview:self.frontCardView];
            
            self.backCardView = [self popMovieViewWithFrame:[self backCardViewFrame]];
            [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        }
    }];
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

#pragma mark - MDCSwipeToChoose Methods

- (void)viewDidCancelSwipe:(UIView *)view { // When a user didn't fully swipe left or right.
    NSLog(@"You couldn't decide on %@.", self.currentMovie.title);
}

- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction { // When user swipes the view fully left or right.
    if (direction == MDCSwipeDirectionLeft) {
        NSLog(@"You disliked %@.", self.currentMovie.title);
    } else {
        NSLog(@"You liked %@.", self.currentMovie.title);
        [self.selectedMovies addObject:self.currentMovie];
        
        self.conglomerateSynopsis = [self.conglomerateSynopsis stringByAppendingString:self.currentMovie.synopsis];
    }
    
    self.frontCardView = self.backCardView;
    if ((self.backCardView = [self popMovieViewWithFrame:[self backCardViewFrame]])) {
        // Fade the back card into view.
        self.backCardView.alpha = 0.f;
        [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.backCardView.alpha = 1.f;
        } completion:nil];
    }
    
    if(self.frontCardView == nil && self.backCardView == nil) { // There are no more movies to display.
        [self noMoreMoviesView];
    }
}

- (void)setFrontCardView:(ChooseMovieView *)frontCardView {
    // Keep track of the movie currently being chosen.
    _frontCardView = frontCardView;
    self.currentMovie = frontCardView.movie;
}

- (ChooseMovieView *)popMovieViewWithFrame:(CGRect)frame {
    if ([self.topMovies count] == 0) {
        return nil;
    }
    
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
    
    ChooseMovieView *movieView = [[ChooseMovieView alloc] initWithFrame:frame movie:self.topMovies[0] options:options];
    [self.topMovies removeObjectAtIndex:0];
    
    UITapGestureRecognizer *cardTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTappedCard:)];
    cardTapRecognizer.numberOfTapsRequired = 2;
    [movieView addGestureRecognizer:cardTapRecognizer];
    
    return movieView;
}

#pragma mark - Tap Handlers

- (void)doubleTappedCard:(UITapGestureRecognizer *)sender {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionRight];
}

- (void)tappedLoadMore {
    self.topMoviePageCount = [NSNumber numberWithInt:([self.topMoviePageCount intValue] + 1)];
    [self topMoviesFromPage:self.topMoviePageCount];
    
    for(UIView *subView in self.view.subviews) { // Remove the no more movies subview
        if(subView.tag == 1000) {
            [subView removeFromSuperview];
        }
    }
}

- (void)tappedRecommendAnimeButton {
    if(self.selectedMovies.count == 0) {
        [self alertWithTitle:@"Must select movies" andMessage:@"Please swipe right on at least one movie and try again" andActionTitle:@"OK"];
    } else {
        [self.view bringSubviewToFront:self.spinner];
        [self.spinner startAnimating];
        
        NSMutableDictionary<NSNumber *, NSNumber *> *genreCount = [self countGenreOfSelectedMovies:self.selectedMovies];
        
        __weak __typeof(self) weakSelf = self;
        [self movieGenreList:^(NSArray<NSDictionary *> *genres, NSError *error) {
            __strong __typeof(self) strongSelf = weakSelf;
            if(error != nil) {
                [strongSelf alertWithTitle:@"Something went wrong..." andMessage:[error.localizedDescription stringByAppendingString:@" Please try again."] andActionTitle:@"OK"];
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
                        [strongSelf performSegueWithIdentifier:@"SwipeQuizToListSegue" sender:[self.animeRecommendations allObjects]];
                    }
                }];
            }
        }];
    }
}

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

- (void)animeRecsGivenFrequencyOfGenresInSelectedMovies:(NSMutableDictionary<NSNumber *, NSNumber *> *) genreIDsAndFrequency withMovieGenreOptions:(NSMutableDictionary<NSNumber *, NSString *> *) movieGenreOptions completion:(void(^)(NSError *error)) completion {
    
    NSArray<NSNumber *> *selectedMovieGenreIDs = [genreIDsAndFrequency allKeys];
    NSNumber *totalGenreOccurences = [[genreIDsAndFrequency allValues] valueForKeyPath:@"@sum.self"];
    
    for(int i = 0; i < selectedMovieGenreIDs.count; i++) {
        // Movie genre
        NSNumber *movieGenreID = selectedMovieGenreIDs[i];
                        
        // Corresponding anime genre
        NSString *correspondingAnimeGenreID;
        if([movieGenreOptions objectForKey:movieGenreID] == nil) { // If this movie's genre ID isn't a possible movie genre ID
            correspondingAnimeGenreID = @"1"; // Default genre is action
        } else {
            NSString *correspondingAnimeGenreName = [kMovieGenreTitleToAnimeGenreTitle objectForKey:[movieGenreOptions objectForKey:selectedMovieGenreIDs[i]]];
            correspondingAnimeGenreID = [[self.animeGenres allKeysForObject:correspondingAnimeGenreName] lastObject];
        }
        
        // Number of recommendations to retrive from this genre based on frequency
        NSNumber *genreFrequency = [genreIDsAndFrequency objectForKey:selectedMovieGenreIDs[i]];
        double roundedLimitDouble = round(([genreFrequency doubleValue] / [totalGenreOccurences doubleValue])  * kAnimeRecLimit);
        NSNumber *roundedLimit = [NSNumber numberWithDouble:roundedLimitDouble];
        
        __weak __typeof(self) weakSelf = self;
        [[SUKAPIManager shared] fetchAnimeFromGenre:correspondingAnimeGenreID withLimit:roundedLimit completion:^(NSArray<SUKAnime *> *animes, NSError *error) {
            __strong __typeof(self) strongSelf = weakSelf;
            if(error != nil) {
                NSLog(@"Failed fo fetch top anime from genre with ID %@: %@", correspondingAnimeGenreID, error.localizedDescription);
            } else {
                [strongSelf.animeRecommendations addObjectsFromArray:animes];
            }
            
            if(i == selectedMovieGenreIDs.count - 1) {
                NSLog(@"Recommendation algorithm finished.");
                [strongSelf rankByTextSimilarityBetweenAnimeRecsAndConglomerateSynopsis];
                completion(nil);
            }
        }];
        
        [NSThread sleepForTimeInterval:1.0];
    }
}

- (NSArray<SUKAnime *> *)rankByTextSimilarityBetweenAnimeRecsAndConglomerateSynopsis {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kStopWordsRegExPattern options:NSRegularExpressionCaseInsensitive error:&error];
    NLEmbedding *embedding = [NLEmbedding sentenceEmbeddingForLanguage:NLLanguageEnglish];
    
    NSString *movieConglomerateSynopsisNoStopWords = [regex stringByReplacingMatchesInString:self.conglomerateSynopsis options:0 range:NSMakeRange(0,[self.conglomerateSynopsis length]) withTemplate:@""];
    
    NSMutableDictionary<SUKAnime *, NSNumber *> *animeDistances = [NSMutableDictionary new];
    
    for(SUKAnime *anime in self.animeRecommendations) {
        NSString *animeSynopsisNoStopwords = [regex stringByReplacingMatchesInString:anime.synopsis options:0 range:NSMakeRange(0,[anime.synopsis length]) withTemplate:@""];
        NLDistance distance = [embedding distanceBetweenString:movieConglomerateSynopsisNoStopWords andString:animeSynopsisNoStopwords distanceType:NLDistanceTypeCosine];
        
        [animeDistances setObject:[NSNumber numberWithDouble:distance] forKey:anime];
    }
    
    return [animeDistances keysSortedByValueUsingComparator:^(id first, id second) {
        return [first compare:second];
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString: @"SwipeQuizToListSegue"]) {
        SUKAnimeListViewController *listVC = [segue destinationViewController];
        listVC.listTitle = @"Recommendations";
        listVC.arrOfAnime = sender;
    }
}

#pragma mark - MISC

- (void)alertWithTitle:(NSString *)title andMessage:(NSString *)message andActionTitle:(NSString *)actionTitle {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{}];
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


@end
