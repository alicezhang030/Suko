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

@interface SUKAPIManager : NSObject
+ (instancetype)shared;
- (void)cancelAllRequests;
- (void)fetchAnimeWithID:(NSNumber *) malID completion:(void(^)(SUKAnime* anime, NSError *error))completion;
- (void)fetchTopAnimeList:(void(^)(NSArray<SUKAnime *> *arrofAnime, NSError *error))completion;
- (void)fetchAnimeListWithGenre:(NSString *) genre completion:(void(^)(NSArray<SUKAnime *> *arrofAnime, NSError *error))completion;
- (void)fetchAnimeGenreList:(void(^)(NSArray<NSDictionary *> *genres, NSError *error))completion;
- (void)fetchAnimeSearchWithSearchQuery:(NSString *) query completion:(void(^)(NSArray<SUKAnime *> *arrofAnime, NSError *error))completion;

- (void)fetchMovieGenreList:(void(^)(NSArray<NSDictionary *> *genres, NSError *error))completion;
- (void)fetchPopularMovieList:(void(^)(NSArray<SUKMovie *> *movies, NSError *error))completion;
@end

NS_ASSUME_NONNULL_END
