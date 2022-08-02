//
//  SUKConstants.m
//  Suko
//
//  Created by Alice Zhang on 8/2/22.
//

#import "SUKConstants.h"

@implementation SUKConstants

#pragma mark - Jikan API's keys
NSString *kJikanBaseURLString = @"https://api.jikan.moe/v4";

NSString *kJikanResponseDataKey = @"data";

NSString *kJikanAPIAnimeDictMALIDKey = @"mal_id";
NSString *kJikanAPIAnimeDictTitleKey = @"title";
NSString *kJikanAPIAnimeDictSynopsisKey = @"synopsis";
NSString *kJikanAPIAnimeDictGenresKey = @"genres";
NSString *kJikanAPIAnimeDictStatusKey = @"status";
NSString *kJikanAPIAnimeDictEpCountKey = @"episodes";

#pragma mark - Movie Database API's keys
NSString *kMovieDBBaseURLString = @"https://api.themoviedb.org/3";

NSString *kMovieDBAPIPosterBaseURL = @"https://image.tmdb.org/t/p/w500";

NSString *kMovieDBAPIMovieDictIDKey = @"id";
NSString *kMovieDBAPIMovieDictTitleKey = @"title";
NSString *kMovieDBAPIMovieDictPosterPathKey = @"poster_path";
NSString *kMovieDBAPIMovieDictOverviewKey = @"overview";
NSString *kMovieDBAPIMovieDictGenresKey = @"genre_ids";

#pragma mark - PFUser Keys
NSString *kPFUserUsernameKey = @"username";
NSString *kPFUserProfileImageKey = @"profile_image";
NSString *kPFUserProfileBackdropKey = @"profile_backdrop";
NSString *kPFUserListTitlesKey = @"list_titles";
NSString *kPFUserListDataKey = @"list_data";
NSString *kPFUserFollowersKey = @"follower_arr";
NSString *kPFUserCurrentCoordinatesKey = @"current_coordinates";

#pragma mark - SUKEvent Keys
NSString *kSUKEventAttendeesKey = @"attendees";

#pragma mark - SUKFollow Keys
NSString *kSUKFollowFollowersKey = @"follower";
NSString *kSUKFollowUserBeingFollowedKey = @"userBeingFollowed";

#pragma mark - Segue Identifiers
NSString *kEventDetailsToNotCurrentUserProfileSegueIdentifier = @"EventDetailsToNotCurrentUserProfileSegue";
NSString *kHomeToAnimeListSegueIdentifier = @"HomeToAnimeListSegue";
NSString *kHomeCollectionCellToDetailsSegueIdentifier = @"HomeCollectionCellToDetailsSegue";
NSString *kUserMapToNotCurrentUserProfileSegueIdentifier = @"MapToNotCurrentUserProfileSegue";

#pragma mark - MISC
NSString *kDefaultUserIconFileName = @"user-icon";
@end
