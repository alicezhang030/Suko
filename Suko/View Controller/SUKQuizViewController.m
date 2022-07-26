//
//  SUKQuizViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/20/22.
//

#import "SUKQuizViewController.h"
#import "SUKMovie.h"
#import "SUKAnime.h"
#import "SUKAPIManager.h"
#import "SUKMovieToAnimeCollectionViewCell.h"
#import "SUKAnimeListViewController.h"

@interface SUKQuizViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<SUKMovie *> *movies;
@property (nonatomic, strong) NSMutableArray<SUKMovie *> *selectedMovies;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSString *> *movieGenres;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (nonatomic, strong) NSMutableArray<SUKAnime *> *animeRecommendations;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *animeRecommendationIDs;
@end

@implementation SUKQuizViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.movies = [NSArray new];
    self.selectedMovies = [NSMutableArray new];
    self.animeRecommendations = [NSMutableArray new];
    self.animeRecommendationIDs = [NSMutableArray new];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.allowsMultipleSelection = YES;
    
    self.spinner.hidesWhenStopped = YES;
    self.spinner.layer.cornerRadius = 10;
    [self.spinner setCenter:CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0)];
    
    [self topMovies];
}

#pragma mark - Collection View

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SUKMovieToAnimeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SUKMovieToAnimeCollectionViewCell" forIndexPath:indexPath];
    [cell setMovie:self.movies[indexPath.row]];
    
    if([self.collectionView.indexPathsForSelectedItems containsObject:indexPath]) {
        cell.movieTitleLabel.textColor = [UIColor colorWithRed: 169.0/255.0 green:120.0/255.0 blue:228/255.0 alpha:1.0];
    } else {
        cell.movieTitleLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SUKMovieToAnimeCollectionViewCell *tappedCell = (SUKMovieToAnimeCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    tappedCell.movieTitleLabel.textColor = [UIColor colorWithRed: 169.0/255.0 green:120.0/255.0 blue:228/255.0 alpha:1.0];
    [self.selectedMovies addObject:tappedCell.movie];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    SUKMovieToAnimeCollectionViewCell *tappedCell = (SUKMovieToAnimeCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    tappedCell.movieTitleLabel.textColor = [UIColor blackColor];
    [self.selectedMovies removeObject:tappedCell.movie];
}

#pragma mark - Fetching Data
- (void)topMovies {
    [self.spinner startAnimating];
    __weak __typeof(self) weakSelf = self;
    [[SUKAPIManager shared] fetchPopularMovieList:^(NSArray<SUKMovie *> *movies, NSError *error) {
        __strong __typeof(self) strongSelf = weakSelf;
        if(movies != nil) {
            strongSelf.movies = movies;
            [self.collectionView reloadData];
            [self.spinner stopAnimating];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
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

#pragma mark - Gestures
- (IBAction)tapSubmit:(id)sender {
    [self.spinner startAnimating];
    [self.animeRecommendations removeAllObjects];
    [self.animeRecommendationIDs removeAllObjects];
    NSMutableDictionary<NSNumber *, NSNumber *> *genreCount = [self countGenreOfSelectedMovies:self.selectedMovies];
    NSArray<NSNumber *> *sortedMovieGenreIDs = [self sortMovieGenreIDsBySelectionCount:genreCount];
    [self animeRecommendationsGivenMovieGenreIDs:sortedMovieGenreIDs];
}

#pragma mark - Helpers
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
                [strongSelf performSegueWithIdentifier:@"QuizToListSegue" sender:self.animeRecommendations];
            }
        }];
    }];
}

- (void) animeRecsGivenMovieGenreIDs:(NSArray<NSNumber *> *) movieGenreIDs withMovieGenreOptions:(NSMutableDictionary<NSNumber *, NSString *> *) genreOptions completion:(void(^)(NSError *error)) completion {
    
    NSDictionary<NSString *,NSString *> *movieGenreToAnimeGenre = @{@"Family":@"Kids", @"Adventure":@"Adventure", @"Romance":@"Romance", @"Drama":@"Drama", @"Mystery":@"Mystery", @"Crime":@"Organized Crime", @"War":@"Military", @"Action":@"Action", @"Science Fiction":@"Sci-Fi", @"Music":@"Music", @"Western":@"None", @"History":@"Historical", @"Documentary":@"None", @"Comedy":@"Comedy", @"Fantasy":@"Fantasy", @"TV Movie":@"None", @"Animation":@"None", @"Thriller":@"Suspense", @"Horror":@"Horror"};
    
    for(int i = 0; i < movieGenreIDs.count; i++) {
        NSString *correspondingAnimeGenreName = [movieGenreToAnimeGenre objectForKey:[genreOptions objectForKey:movieGenreIDs[i]]];
        NSLog(@"%@", correspondingAnimeGenreName); // TO BE DELETED
        
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
                    completion(nil);
                }
            }];
            
            [NSThread sleepForTimeInterval:1.0];
        }
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString: @"QuizToListSegue"]) {
        SUKAnimeListViewController *listVC = [segue destinationViewController];
        listVC.listTitle = @"Recommendations";
        listVC.arrOfAnime = sender;
    }
}

@end
