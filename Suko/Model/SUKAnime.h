//
//  Anime.h
//  Suko
//
//  Created by Alice Zhang on 7/7/22.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
NS_ASSUME_NONNULL_BEGIN

/**
 * Model used to represent an anime.
 */
@interface SUKAnime : NSObject <NSCopying>

/** Corresponding MyAnimeList ID */
@property (nonatomic) int malID;

/** The title of the anime (ex. "One Piece") */
@property (nonatomic) NSString *title;

/** The URL for the poster of the anime */
@property (nonatomic) NSString *posterURL;

/** The anime synopsis */
@property (nonatomic) NSString *synopsis;

/** Episode count */
@property (nonatomic) int numEpisodes;

/**
 * Initializes and returns an array of SUKAnime objects using the information provided in each dictionary
 *
 * @param arrOfDictionaries Array of dictionaries where each dictionary contains an anime's information
 */
+ (NSMutableArray<SUKAnime *> *)animesWithArrayOfDictionaries:(NSArray<NSDictionary *> *)arrOfDictionaries;

/**
 * Initializes and returns a SUKAnime object using the information provided in the dictionary
 *
 * @param dictionary A dictionary that contains an anime's information
 */
+ (SUKAnime *)animeWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
