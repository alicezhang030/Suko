//
//  SUKMovie.m
//  Suko
//
//  Created by Alice Zhang on 7/22/22.
//

#import "SUKMovie.h"

@interface SUKMovie ()
@property (nonatomic) NSNumber *ID;
@property (nonatomic) NSString *synopsis;
@end

@implementation SUKMovie

#pragma mark - Constants
NSString * const kMovieIDDictionaryKey = @"id";
NSString * const kMovieTitleDictionaryKey = @"title";
NSString * const kPosterBaseURL = @"https://image.tmdb.org/t/p/w500";
NSString * const kMoviePosterPathDictionaryKey = @"poster_path";
NSString * const kMovieOverviewDictionaryKey = @"overview";
NSString * const kMovieGenreIDsDictionaryKey = @"genre_ids";

#pragma mark - Initialization methods

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if(self) {
        self.ID = dictionary[kMovieIDDictionaryKey];
        self.title = dictionary[kMovieTitleDictionaryKey];
        self.posterURL = [kPosterBaseURL stringByAppendingString:dictionary[kMoviePosterPathDictionaryKey]];
        self.synopsis = dictionary[kMovieOverviewDictionaryKey];
        self.genreIDs = dictionary[kMovieGenreIDsDictionaryKey];
    }
    return self;
}

+ (NSArray<SUKMovie *> *)movieWithArrayOfDictionaries:(NSArray<NSDictionary *> *)dictionaries {
    NSMutableArray<SUKMovie *> *movies = [NSMutableArray new];
    for (NSDictionary *dictionary in dictionaries) {
        SUKMovie *movie = [[SUKMovie alloc] initWithDictionary:dictionary];
        [movies addObject:movie];
    }
    return [movies copy];
}

@end
