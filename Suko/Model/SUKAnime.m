//
//  Anime.m
//  Suko
//
//  Created by Alice Zhang on 7/7/22.
//

#import "SUKAnime.h"
#import "SUKConstants.h"

@interface SUKAnime ()

/** The genres this anime fit into */
@property (nonatomic) NSArray<NSDictionary *> *genres;

/** Airing status ("Finished Airing," "Currently Airing," "Not yet aired")*/
@property (nonatomic) NSString *status;

@end

@implementation SUKAnime

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        NSNumber *malIDNSNumber = dictionary[kJikanAPIAnimeDictMALIDKey];
        self.malID = [malIDNSNumber intValue];
        
        // MyAnimeList formats titles occasionally with "\" at the end, so need to remove the formatting
        NSString *titleWithMALFormatting = dictionary[kJikanAPIAnimeDictTitleKey];
        self.title = [[titleWithMALFormatting componentsSeparatedByString:@"\\"] objectAtIndex:0];
        
        self.posterURL = dictionary[@"images"][@"jpg"][@"large_image_url"];
        self.synopsis = dictionary[kJikanAPIAnimeDictSynopsisKey];
        self.genres = dictionary[kJikanAPIAnimeDictGenresKey];
        self.status = dictionary[kJikanAPIAnimeDictStatusKey];

        NSNumber *episodesNSNumber = dictionary[kJikanAPIAnimeDictEpCountKey];
        self.numEpisodes = [episodesNSNumber intValue];
    }
    return self;
}

+ (NSMutableArray<SUKAnime *> *)animesWithArrayOfDictionaries:(NSArray<NSDictionary *> *)dictionaries {
    NSMutableArray<SUKAnime *> *animes = [NSMutableArray new];
    for (NSDictionary *dictionary in dictionaries) {
        SUKAnime *anime = [[SUKAnime alloc] initWithDictionary:dictionary];
        [animes addObject:anime];
    }
    return animes;
}

+ (SUKAnime *)animeWithDictionary:(NSDictionary *)dictionary {
    SUKAnime *anime = [[SUKAnime alloc] initWithDictionary:dictionary];
    return anime;
}

@end
