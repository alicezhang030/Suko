//
//  SUKMovie.h
//  Suko
//
//  Created by Alice Zhang on 7/22/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Model used to represent a movie
 */
@interface SUKMovie : NSObject

/** The ID of the movie */
@property (nonatomic, readonly) NSNumber *ID;

/** The title of the movie */
@property (nonatomic, readonly) NSString *title;

/** The IDs of the genres this movie fits into */
@property (nonatomic, readonly) NSArray<NSNumber *> *genreIDs;

/** The URL of this movie's poster */
@property (nonatomic, readonly) NSString *posterURL;

/** The synopsis of the movie */
@property (nonatomic, readonly) NSString *synopsis;

/**
 *  Creates an array of SUKMovie objects using the information provided in each dictionary and returns it.
 *
 *  @param arrOfDictionaries Array of dictionaries where each dictionary contains a movie's information
 */
+ (NSArray<SUKMovie *> *)moviesWithArrayOfDictionaries:(NSArray<NSDictionary *> *)arrOfDictionaries;

@end

NS_ASSUME_NONNULL_END
