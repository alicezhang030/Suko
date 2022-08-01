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

/** The title of the movie */
@property (nonatomic) NSString *title;

/** The IDs of the genres this movie fits into */
@property (nonatomic) NSArray<NSNumber *> *genreIDs;

/** The URL of this movie's poster */
@property (nonatomic) NSString *posterURL;

/**
 *  Creates an array of SUKMovie objects using the information provided in each dictionary and returns it.
 *
 *  @param arrOfDictionaries Array of dictionaries where each dictionary contains a movie's information
 */
+ (NSArray<SUKMovie *> *)movieWithArrayOfDictionaries:(NSArray<NSDictionary *> *)arrOfDictionaries;

@end

NS_ASSUME_NONNULL_END
