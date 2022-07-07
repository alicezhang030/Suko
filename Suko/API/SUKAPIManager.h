//
//  SUKAPIManager.h
//  Suko
//
//  Created by Alice Zhang on 6/29/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUKAPIManager : NSObject
+ (instancetype)shared;
- (void)fetchTopAnime:(void(^)(NSArray *genres, NSError *error))completion;
- (void)fetchGenreAnime:(NSString *) genre completion:(void(^)(NSArray *genres, NSError *error))completion;
- (void)fetchGenreList:(void(^)(NSArray *genres, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
