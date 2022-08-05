//
//  SUKConstants.h
//  Suko
//
//  Created by Alice Zhang on 8/2/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUKConstants : NSObject

#pragma mark - Jikan API's keys
extern NSString *kJikanBaseURLString;
extern NSString *kJikanResponseDataKey;

extern NSString *kJikanAPIAnimeDictMALIDKey;
extern NSString *kJikanAPIAnimeDictTitleKey;
extern NSString *kJikanAPIAnimeDictSynopsisKey;
extern NSString *kJikanAPIAnimeDictGenresKey;
extern NSString *kJikanAPIAnimeDictEpCountKey;

#pragma mark - Movie Database API's keys
extern NSString *kMovieDBBaseURLString;

extern NSString *kMovieDBAPIPosterBaseURL;

extern NSString *kMovieDBAPIMovieDictIDKey;
extern NSString *kMovieDBAPIMovieDictTitleKey;
extern NSString *kMovieDBAPIMovieDictPosterPathKey;
extern NSString *kMovieDBAPIMovieDictOverviewKey;
extern NSString *kMovieDBAPIMovieDictGenresKey;

#pragma mark - PFUser Keys
extern NSString *kPFUserUsernameKey;
extern NSString *kPFUserProfileImageKey;
extern NSString *kPFUserProfileBackdropKey;
extern NSString *kPFUserListTitlesKey;
extern NSString *kPFUserListDataKey;
extern NSString *kPFUserFollowersKey;
extern NSString *kPFUserCurrentCoordinatesKey;

#pragma mark - SUKEvent Keys
extern NSString *kSUKEventAttendeesKey;

#pragma mark - SUKFollow Keys
extern NSString *kSUKFollowFollowersKey;
extern NSString *kSUKFollowUserBeingFollowedKey;

#pragma mark - Segue Identifiers
extern NSString *kEventDetailsToNotCurrentUserProfileSegueIdentifier;
extern NSString *kHomeToAnimeListSegueIdentifier;
extern NSString *kHomeCollectionCellToDetailsSegueIdentifier;
extern NSString *kUserMapToNotCurrentUserProfileSegueIdentifier;
extern NSString *kCreateListToAnimeListSegueIdentifier;
extern NSString *kPFUserUserMapPrivacyKey;
extern NSString *kSwipeQuizToListSegueIdentifier;
extern NSString *kProfileToSettingsSegue;
extern NSString *kHomeToQuizSegue;
extern NSString *kDetailsToCreateReviewSegue;

#pragma mark - MISC
extern NSString *kDefaultUserIconFileName;
extern NSDictionary<NSString *, NSString *> *kMovieGenreTitleToAnimeGenreTitle;
extern NSString *kStopWordsRegExPattern;

@end

NS_ASSUME_NONNULL_END
