//
//  SUKMovie.m
//  Suko
//
//  Created by Alice Zhang on 7/22/22.
//

#import "SUKMovie.h"

@implementation SUKMovie

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];

    if(self) {
        self.ID = dictionary[@"id"];
        self.title = dictionary[@"title"];
        self.posterURL = [@"https://image.tmdb.org/t/p/w500" stringByAppendingString:dictionary[@"poster_path"]];
        self.synopsis = dictionary[@"overview"];
        self.genreIDs = dictionary[@"genre_ids"];
    }
    
    return self;
}

+ (NSMutableArray *)movieWithArrayOfDictionaries:(NSArray<NSDictionary *> *)dictionaries {
    NSMutableArray<SUKMovie *> *movies = [NSMutableArray new];
    for (NSDictionary *dictionary in dictionaries) {
        SUKMovie *movie = [[SUKMovie alloc] initWithDictionary:dictionary];
        [movies addObject:movie];
    }
    return movies;
}

@end
