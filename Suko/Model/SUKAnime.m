//
//  Anime.m
//  Suko
//
//  Created by Alice Zhang on 7/7/22.
//

#import "SUKAnime.h"

@implementation SUKAnime

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];

    if (self) {
        NSNumber *malIDNSNumber = dictionary[@"mal_id"];
        self.malID = [malIDNSNumber intValue];
        
        // MyAnimeList formats titles weirdly occasionally with "\" at the end, so we need to remove the formatting
        NSString *titleWithMALFormatting = dictionary[@"title"];
        self.title = [[titleWithMALFormatting componentsSeparatedByString:@"\\"] objectAtIndex:0];
        
        self.posterURL = dictionary[@"images"][@"jpg"][@"large_image_url"];
        
        self.synopsis = dictionary[@"synopsis"];
        self.genres = dictionary[@"genres"];
        
        NSNumber *episodesNSNumber = dictionary[@"episodes"];
        self.episodes = [episodesNSNumber intValue];
        
        self.status = dictionary[@"status"];
    }
    
    return self;
}

+ (NSMutableArray *)animesWithArrayOfDictionaries:(NSArray *)dictionaries {
    NSMutableArray *animes = [NSMutableArray array];
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
