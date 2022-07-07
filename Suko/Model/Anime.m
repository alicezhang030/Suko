//
//  Anime.m
//  Suko
//
//  Created by Alice Zhang on 7/7/22.
//

#import "Anime.h"

@implementation Anime

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];

    if (self) {
        NSNumber *malIDNSNumber = dictionary[@"mal_id"];
        self.malID = [malIDNSNumber intValue];
        
        // MyAnimeList formats titles weirdly occasionally with "\" at the end, so we need to remove the formatting
        NSString *titleWithMALFormatting = dictionary[@"title"];
        self.title = [[titleWithMALFormatting componentsSeparatedByString:@"\\"] objectAtIndex:0];
        
        self.synopsis = dictionary[@"synopsis"];
        self.genres = dictionary[@"genres"];
        
        NSNumber *episodesNSNumber = dictionary[@"episodes"];
        self.episodes = [episodesNSNumber intValue];
        
        self.status = dictionary[@"status"];
    }
    
    return self;
}

@end
