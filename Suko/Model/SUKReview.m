//
//  SUKReview.m
//  Suko
//
//  Created by Alice Zhang on 8/5/22.
//

#import "SUKReview.h"

@interface SUKReview ()
@property (nonatomic, strong, readwrite) PFUser *author;
@property (nonatomic, strong, readwrite) NSString *reviewText;
@property (nonatomic, strong, readwrite) NSNumber *rating;
@property (nonatomic, strong, readwrite) NSNumber *animeID;
@end

@implementation SUKReview

@dynamic author;
@dynamic reviewText;
@dynamic rating;
@dynamic animeID;

+ (nonnull NSString *)parseClassName {
    return @"SUKReview";
}

+ (void)postReviewWithAuthor:(PFUser *)author reviewContent:(NSString *)reviewText starRating:(NSNumber *)rating forAnimeWithID:(NSNumber *)animeID withCompletion:(PFBooleanResultBlock _Nonnull)completion {
    SUKReview *newReview = [SUKReview new];
    
    newReview.author = author;
    newReview.reviewText = reviewText;
    newReview.rating = rating;
    newReview.animeID = animeID;

    [newReview saveInBackgroundWithBlock: completion];
}

@end
