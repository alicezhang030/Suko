//
//  Anime.h
//  Suko
//
//  Created by Alice Zhang on 7/7/22.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
NS_ASSUME_NONNULL_BEGIN

@interface SUKAnime : NSObject

/** Corresponding MyAnimeList ID */
@property (nonatomic) int malID;
/** The title of the anime (ex. "One Piece") */
@property (nonatomic) NSString *title;
/** The URL for the poster of the anime */
@property (nonatomic) NSString *posterURL;
/** The anime synopsis */
@property (nonatomic) NSString *synopsis;
/** The genres this anime fit into */
@property (nonatomic) NSArray *genres;
/** Episode count */
@property (nonatomic) int episodes;
/** Airing status ("Finished Airing," "Currently Airing," "Not yet aired")*/
@property (nonatomic) NSString *status;

+ (NSMutableArray *)animesWithArrayOfDictionaries:(NSArray *)dictionaries;
+ (SUKAnime *)animeWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
