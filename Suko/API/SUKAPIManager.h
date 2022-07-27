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
- (void)cancelAllJikanRequests;
- (void)fetchAnimeWithID:(NSNumber *)malID completion:(void(^)(SUKAnime* anime, NSError *error))completion;
- (void)fetchTopAnimeWithLimit:(NSNumber *)limit completion:(void(^)(NSArray<SUKAnime *> *arrofAnime, NSError *error))completion;
- (void)fetchAnimeFromGenre:(NSString *)genre withLimit:(NSNumber *)limit completion:(void(^)(NSArray<SUKAnime *> *arrofAnime, NSError *error))completion;
- (void)fetchAnimeGenres:(void(^)(NSArray<NSDictionary *> *genres, NSError *error))completion;
- (void)fetchAnimeSearchWithSearchQuery:(NSString *)query completion:(void(^)(NSArray<SUKAnime *> *arrofAnime, NSError *error))completion;

- (void)fetchMovieGenres:(void(^)(NSArray<NSDictionary *> *genres, NSError *error))completion;
- (void)fetchTopMoviesFromPage:(NSNumber *)page completion:(void(^)(NSArray<SUKMovie *> *movies, NSError *error))completion;
@end

NS_ASSUME_NONNULL_END
