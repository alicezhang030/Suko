//
//  SUKAPIManager.h
//  Suko
//
//  Created by Alice Zhang on 6/29/22.
//

#import <Foundation/Foundation.h>
#import "SUKAnime.h"

NS_ASSUME_NONNULL_BEGIN

@interface SUKAPIManager : NSObject
+ (instancetype)shared;
- (void)fetchSpecificAnimeByID:(NSNumber *) malID completion:(void(^)(SUKAnime* anime, NSError *error))completion;
- (void)fetchTopAnime:(void(^)(NSArray *arrofAnimeObjs, NSError *error))completion;
- (void)fetchGenreAnime:(NSString *) genre completion:(void(^)(NSArray *arrofAnimeObjs, NSError *error))completion;
- (void)fetchGenreList:(void(^)(NSArray *genres, NSError *error))completion;
- (void)fetchAnimeSearchBySearchQuery:(NSString *) query completion:(void(^)(NSArray *arrofAnimeObjs, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
