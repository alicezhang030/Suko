//
//  SUKQuizViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/20/22.
//

#import "SUKQuizViewController.h"
#import "SUKMovie.h"
#import "SUKAPIManager.h"
#import "SUKMovieToAnimeCollectionViewCell.h"

@interface SUKQuizViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<SUKMovie *> *movies;
@property (nonatomic, strong) NSArray<NSDictionary *> *movieGenres;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSNumber *> *genreCount;
@end

@implementation SUKQuizViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.genreCount = [NSMutableDictionary new];
    self.movies = [NSArray new];
    self.movieGenres = [NSArray new];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.allowsMultipleSelection = YES;
    
    [self topAnime];
}

#pragma mark - Collection View

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SUKMovieToAnimeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SUKMovieToAnimeCollectionViewCell" forIndexPath:indexPath];
    [cell setMovie:self.movies[indexPath.row]];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SUKMovieToAnimeCollectionViewCell *tappedCell = (SUKMovieToAnimeCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    tappedCell.movieTitleLabel.textColor = [UIColor colorWithRed: 169.0/255.0 green:120.0/255.0 blue:228/255.0 alpha:1.0];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    SUKMovieToAnimeCollectionViewCell *tappedCell = (SUKMovieToAnimeCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    tappedCell.movieTitleLabel.textColor = [UIColor blackColor];
}

#pragma mark - Fetching Data
- (void)topAnime {
    __weak __typeof(self) weakSelf = self;
    [[SUKAPIManager shared] fetchPopularMovieList:^(NSArray<SUKMovie *> *movies, NSError *error) {
        __strong __typeof(self) strongSelf = weakSelf;
        if(movies != nil) {
            strongSelf.movies = movies;
            [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)movieGenreList {
    __weak __typeof(self) weakSelf = self;
    [[SUKAPIManager shared] fetchMovieGenreList:^(NSArray<NSDictionary *> *genres, NSError *error) {
        __strong __typeof(self) strongSelf = weakSelf;
        if(genres != nil) {
            strongSelf.movieGenres = genres;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

#pragma mark - Gestures
- (IBAction)tapSubmit:(id)sender {
    NSMutableArray<SUKMovie *> *selectedMovies = [NSMutableArray new];
    for(NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems) {
        SUKMovieToAnimeCollectionViewCell *selectedCell = (SUKMovieToAnimeCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        [selectedMovies addObject:selectedCell.movie];
    }
    
    [self countGenreOfSelectedMovies:selectedMovies];
}

#pragma mark - Helpers
- (void)countGenreOfSelectedMovies:(NSArray<SUKMovie *> *) selectedMovies {
    for(SUKMovie *selectedMovie in selectedMovies) {
        for(NSNumber *genreID in selectedMovie.genreIDs) {
            NSLog(@"%@", genreID);
            
            if([self.genreCount objectForKey:genreID] == nil) {
                [self.genreCount setObject:@1 forKey:genreID];
            } else {
                int updatedCountInt = [[self.genreCount objectForKey:genreID] intValue] + 1;
                [self.genreCount setObject:[NSNumber numberWithInt:updatedCountInt] forKey:genreID];
            }
        }
    }
    
    NSArray *movieGenresSortedBySelectionCount = [self.genreCount keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
        if ([obj1 intValue] > [obj2 intValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        } else if ([obj1 intValue] < [obj2 intValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
}

@end
