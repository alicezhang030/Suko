//
//  Anime.h
//  Suko
//
//  Created by Alice Zhang on 7/7/22.
//

#import <Foundation/Foundation.h>
#import "Parse/PFImageView.h"
NS_ASSUME_NONNULL_BEGIN

@interface Anime : NSObject

@property (nonatomic) int malID; // MyAnimeList ID
@property (nonatomic) NSString *title; // The title of the anime (ex. "One Piece")
@property (nonatomic) NSString *posterURL; // The URL for the poster of the anime
@property (nonatomic) NSString *synopsis; // The anime synopsis
@property (nonatomic) NSArray *genres; // The genres this anime fit into

@property (nonatomic) int episodes; // Episode count
@property (nonatomic) NSString *status; // Airing status ("Finished Airing," "Currently Airing," "Not yet aired")

+ (NSMutableArray *)animesWithArray:(NSArray *)dictionaries;

@end

NS_ASSUME_NONNULL_END
