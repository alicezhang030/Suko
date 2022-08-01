//
//  SUKAPIManager.h
//  Suko
//
//  Created by Alice Zhang on 6/29/22.
//

#import <Foundation/Foundation.h>
#import "SUKAnime.h"
#import "SUKMovie.h"

NS_ASSUME_NONNULL_BEGIN

/** An API manager for the app. */
@interface SUKAPIManager : NSObject

/**
 * Initializes and returns a shared instance of SUKAPIManager.
 */
+ (instancetype)shared;

/**
 * Cancels all requests currently being processed by the manager.
 */
- (void)cancelAllRequests;

/**
 * Fetches from the Jikan API information on the anime with the ID and creates a SUKAnime object with that information.
 *
 * @param malID The ID of the anime to be fetched
 * @param completion Completion block
 */
- (void)fetchAnimeWithID:(NSNumber *)malID completion:(void(^)(SUKAnime* anime, NSError *error))completion;

/**
 * Fetches from the Jikan API an array of information on the top anime and creates an array of SUKAnime objects with that information.
 *
 * @param limit The max number of animes to fetch
 * @param completion Completion block
 */
- (void)fetchTopAnimeWithLimit:(NSNumber *)limit completion:(void(^)(NSArray<SUKAnime *> *arrofAnime, NSError *error))completion;

/**
 * Fetches from the Jikan API an array of information on the top anime within this genre and creates an array of SUKAnime objects with that information.
 *
 * @param genre The genre of interest
 * @param limit The max number of anime to fetch
 * @param completion Completion block
 */
- (void)fetchAnimeFromGenre:(NSString *)genre withLimit:(NSNumber *)limit completion:(void(^)(NSArray<SUKAnime *> *arrofAnime, NSError *error))completion;

/**
 * Fetches from the Jikan API the genres that anime could fall into.
 *
 * @param completion Completion block
 */
- (void)fetchAnimeGenres:(void(^)(NSArray<NSDictionary *> *genres, NSError *error))completion;

/**
 * Fetches from the Jikan API an array of information on the search query's results and creates an array of SUKAnime objects with that information.
 *
 * @param query The search query
 * @param completion Completion block
 */
- (void)fetchAnimeSearchWithSearchQuery:(NSString *)query completion:(void(^)(NSArray<SUKAnime *> *arrofAnime, NSError *error))completion;

/**
 * Fetches from the Movie Database API the genres that movies could fall into.
 *
 * @param completion Completion block.
 */
- (void)fetchMovieGenres:(void(^)(NSArray<NSDictionary *> *genres, NSError *error))completion;

/**
 * Fetches from the Movie Database API an array of information on the top movies and creates an array of SUKMovie objects with that information.
 *
 * @param page The page to query
 * @param completion Completion block.
 */
- (void)fetchTopMoviesFromPage:(NSNumber *)page completion:(void(^)(NSArray<SUKMovie *> *movies, NSError *error))completion;
@end

NS_ASSUME_NONNULL_END
