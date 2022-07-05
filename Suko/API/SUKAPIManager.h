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
- (void)fetchTopAnime:(void(^)(NSArray *animes, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
