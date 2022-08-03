//
//  SUKMovie.m
//  Suko
//
//  Created by Alice Zhang on 7/22/22.
//

#import "SUKMovie.h"
#import "SUKConstants.h"

@interface SUKMovie ()
@property (nonatomic, readwrite) NSNumber *ID;
@property (nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) NSArray<NSNumber *> *genreIDs;
@property (nonatomic, readwrite) NSString *posterURL;
@property (nonatomic, readwrite) NSString *synopsis;
@end

@implementation SUKMovie

#pragma mark - Initialization methods

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if(self) {
        self.ID = dictionary[kMovieDBAPIMovieDictIDKey];
        self.title = dictionary[kMovieDBAPIMovieDictTitleKey];
        self.posterURL = [kMovieDBAPIPosterBaseURL stringByAppendingString:dictionary[kMovieDBAPIMovieDictPosterPathKey]];
        self.synopsis = dictionary[kMovieDBAPIMovieDictOverviewKey];
        self.genreIDs = dictionary[kMovieDBAPIMovieDictGenresKey];
    }
    return self;
}

+ (NSArray<SUKMovie *> *)moviesWithArrayOfDictionaries:(NSArray<NSDictionary *> *)dictionaries {
    NSMutableArray<SUKMovie *> *movies = [NSMutableArray new];
    for (NSDictionary *dictionary in dictionaries) {
        SUKMovie *movie = [[SUKMovie alloc] initWithDictionary:dictionary];
        [movies addObject:movie];
    }
    return [movies copy];
}

@end
