//
//  SUKQuizViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/20/22.
//

#import "SUKQuizViewController.h"
#import "SUKMovie.h"
#import "SUKAPIManager.h"

@interface SUKQuizViewController ()
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSNumber *> *genreCount;
@end

@implementation SUKQuizViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.genreCount = [NSMutableDictionary new];
}

- (void)countGenreOfSelectedMovies:(NSArray<SUKMovie *> *) movies {
    for(SUKMovie *movie in movies) {
        for(NSNumber *genreID in movie.genreIDs) {
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
