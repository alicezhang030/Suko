//
//  SUKMovie.h
//  Suko
//
//  Created by Alice Zhang on 7/22/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUKMovie : NSObject
@property (nonatomic) NSNumber *ID;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *posterURL;
@property (nonatomic) NSString *synopsis;
@property (nonatomic) NSArray<NSNumber *> *genreIDs;

+ (NSMutableArray *)movieWithArrayOfDictionaries:(NSArray<NSDictionary *> *)dictionaries;
@end

NS_ASSUME_NONNULL_END
