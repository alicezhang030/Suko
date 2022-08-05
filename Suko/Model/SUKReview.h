//
//  SUKReview.h
//  Suko
//
//  Created by Alice Zhang on 8/5/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUKReview : PFObject<PFSubclassing>

/** The user posting the review */
@property (nonatomic, strong, readonly) PFUser *author;

/** The content of the review */
@property (nonatomic, strong, readonly) NSString *reviewText;

/** The rating of the anime */
@property (nonatomic, strong, readonly) NSNumber *rating;

/** The anime being rated */
@property (nonatomic, strong, readonly) NSNumber *animeID;

/**
 * Creates a SUKReview object using the information provided by the parameters and posts the review to the app's Parse server.
 *
 * @param author The user who wrote this review
 * @param reviewText The content of the review
 * @param rating The rating of the anime
 * @param animeID The ID of the anime being reviewed
 * @param completion Completion block
 */
+ (void)postReviewWithAuthor:(PFUser *)author reviewContent:(NSString *)reviewText starRating:(NSNumber *)rating forAnimeWithID:(NSNumber *)animeID withCompletion:(PFBooleanResultBlock _Nonnull)completion;

@end

NS_ASSUME_NONNULL_END
