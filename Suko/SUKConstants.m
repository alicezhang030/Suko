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
NSString *kCreateListToAnimeListSegueIdentifier = @"CreateListToAnimeListSegue";

#pragma mark - MISC
NSString *kDefaultUserIconFileName = @"user-icon";
// Western, Documentary, TV Movie, and Animation don't match well into any anime genre
NSDictionary<NSString *, NSString *> *kMovieGenreTitleToAnimeGenreTitle = @{@"Family":@"Kids", @"Adventure":@"Adventure", @"Romance":@"Romance", @"Drama":@"Drama", @"Mystery":@"Mystery", @"Crime":@"Organized Crime", @"War":@"Military", @"Action":@"Action", @"Science Fiction":@"Sci-Fi", @"Music":@"Music", @"Western":@"Adventure", @"History":@"Historical", @"Documentary":@"Adventure", @"Comedy":@"Comedy", @"Fantasy":@"Fantasy", @"TV Movie":@"Action", @"Animation":@"Action", @"Thriller":@"Suspense", @"Horror":@"Horror"};
NSString *kStopWordsRegExPattern = @"(\\ba\\b)|(\\babout\\b)|(\\babove\\b)|(\\bacross\\b)|(\\bafter\\b)|(\\bagain\\b)|(\\bagainst\\b)|(\\ball\\b)|(\\balmost\\b)|(\\balone\\b)|(\\balong\\b)|(\\balready\\b)|(\\balso\\b)|(\\balthough\\b)|(\\balways\\b)|(\\bamong\\b)|(\\ban\\b)|(\\band\\b)|(\\banother\\b)|(\\bany\\b)|(\\banybody\\b)|(\\banyone\\b)|(\\banything\\b)|(\\banywhere\\b)|(\\bare\\b)|(\\barea\\b)|(\\bareas\\b)|(\\baround\\b)|(\\bas\\b)|(\\bask\\b)|(\\basked\\b)|(\\basking\\b)|(\\basks\\b)|(\\bat\\b)|(\\baway\\b)|(\\bb\\b)|(\\bback\\b)|(\\bbacked\\b)|(\\bbacking\\b)|(\\bbacks\\b)|(\\bbe\\b)|(\\bbecame\\b)|(\\bbecause\\b)|(\\bbecome\\b)|(\\bbecomes\\b)|(\\bbeen\\b)|(\\bbefore\\b)|(\\bbegan\\b)|(\\bbehind\\b)|(\\bbeing\\b)|(\\bbeings\\b)|(\\bbest\\b)|(\\bbetter\\b)|(\\bbetween\\b)|(\\bbig\\b)|(\\bboth\\b)|(\\bbut\\b)|(\\bby\\b)|(\\bc\\b)|(\\bcame\\b)|(\\bcan\\b)|(\\bcannot\\b)|(\\bcase\\b)|(\\bcases\\b)|(\\bcertain\\b)|(\\bcertainly\\b)|(\\bclear\\b)|(\\bclearly\\b)|(\\bcome\\b)|(\\bcould\\b)|(\\bd\\b)|(\\bdid\\b)|(\\bdiffer\\b)|(\\bdifferent\\b)|(\\bdifferently\\b)|(\\bdo\\b)|(\\bdoes\\b)|(\\bdone\\b)|(\\bdown\\b)|(\\bdown\\b)|(\\bdowned\\b)|(\\bdowning\\b)|(\\bdowns\\b)|(\\bduring\\b)|(\\be\\b)|(\\beach\\b)|(\\bearly\\b)|(\\beither\\b)|(\\bend\\b)|(\\bended\\b)|(\\bending\\b)|(\\bends\\b)|(\\benough\\b)|(\\beven\\b)|(\\bevenly\\b)|(\\bever\\b)|(\\bevery\\b)|(\\beverybody\\b)|(\\beveryone\\b)|(\\beverything\\b)|(\\beverywhere\\b)|(\\bf\\b)|(\\bface\\b)|(\\bfaces\\b)|(\\bfact\\b)|(\\bfacts\\b)|(\\bfar\\b)|(\\bfelt\\b)|(\\bfew\\b)|(\\bfind\\b)|(\\bfinds\\b)|(\\bfirst\\b)|(\\bfor\\b)|(\\bfour\\b)|(\\bfrom\\b)|(\\bfull\\b)|(\\bfully\\b)|(\\bfurther\\b)|(\\bfurthered\\b)|(\\bfurthering\\b)|(\\bfurthers\\b)|(\\bg\\b)|(\\bgave\\b)|(\\bgeneral\\b)|(\\bgenerally\\b)|(\\bget\\b)|(\\bgets\\b)|(\\bgive\\b)|(\\bgiven\\b)|(\\bgives\\b)|(\\bgo\\b)|(\\bgoing\\b)|(\\bgood\\b)|(\\bgoods\\b)|(\\bgot\\b)|(\\bgreat\\b)|(\\bgreater\\b)|(\\bgreatest\\b)|(\\bgroup\\b)|(\\bgrouped\\b)|(\\bgrouping\\b)|(\\bgroups\\b)|(\\bh\\b)|(\\bhad\\b)|(\\bhas\\b)|(\\bhave\\b)|(\\bhaving\\b)|(\\bhe\\b)|(\\bher\\b)|(\\bhere\\b)|(\\bherself\\b)|(\\bhigh\\b)|(\\bhigh\\b)|(\\bhigh\\b)|(\\bhigher\\b)|(\\bhighest\\b)|(\\bhim\\b)|(\\bhimself\\b)|(\\bhis\\b)|(\\bhow\\b)|(\\bhowever\\b)|(\\bi\\b)|(\\bif\\b)|(\\bimportant\\b)|(\\bin\\b)|(\\binterest\\b)|(\\binterested\\b)|(\\binteresting\\b)|(\\binterests\\b)|(\\binto\\b)|(\\bis\\b)|(\\bit\\b)|(\\bits\\b)|(\\bitself\\b)|(\\bj\\b)|(\\bjust\\b)|(\\bk\\b)|(\\bkeep\\b)|(\\bkeeps\\b)|(\\bkind\\b)|(\\bknew\\b)|(\\bknow\\b)|(\\bknown\\b)|(\\bknows\\b)|(\\bl\\b)|(\\blarge\\b)|(\\blargely\\b)|(\\blast\\b)|(\\blater\\b)|(\\blatest\\b)|(\\bleast\\b)|(\\bless\\b)|(\\blet\\b)|(\\blets\\b)|(\\blike\\b)|(\\blikely\\b)|(\\blong\\b)|(\\blonger\\b)|(\\blongest\\b)|(\\bm\\b)|(\\bmade\\b)|(\\bmake\\b)|(\\bmaking\\b)|(\\bman\\b)|(\\bmany\\b)|(\\bmay\\b)|(\\bme\\b)|(\\bmember\\b)|(\\bmembers\\b)|(\\bmen\\b)|(\\bmight\\b)|(\\bmore\\b)|(\\bmost\\b)|(\\bmostly\\b)|(\\bmr\\b)|(\\bmrs\\b)|(\\bmuch\\b)|(\\bmust\\b)|(\\bmy\\b)|(\\bmyself\\b)|(\\bn\\b)|(\\bnecessary\\b)|(\\bneed\\b)|(\\bneeded\\b)|(\\bneeding\\b)|(\\bneeds\\b)|(\\bnever\\b)|(\\bnew\\b)|(\\bnew\\b)|(\\bnewer\\b)|(\\bnewest\\b)|(\\bnext\\b)|(\\bno\\b)|(\\bnobody\\b)|(\\bnon\\b)|(\\bnoone\\b)|(\\bnot\\b)|(\\bnothing\\b)|(\\bnow\\b)|(\\bnowhere\\b)|(\\bnumber\\b)|(\\bnumbers\\b)|(\\bo\\b)|(\\bof\\b)|(\\boff\\b)|(\\boften\\b)|(\\bold\\b)|(\\bolder\\b)|(\\boldest\\b)|(\\bon\\b)|(\\bonce\\b)|(\\bone\\b)|(\\bonly\\b)|(\\bopen\\b)|(\\bopened\\b)|(\\bopening\\b)|(\\bopens\\b)|(\\bor\\b)|(\\border\\b)|(\\bordered\\b)|(\\bordering\\b)|(\\borders\\b)|(\\bother\\b)|(\\bothers\\b)|(\\bour\\b)|(\\bout\\b)|(\\bover\\b)|(\\bp\\b)|(\\bpart\\b)|(\\bparted\\b)|(\\bparting\\b)|(\\bparts\\b)|(\\bper\\b)|(\\bperhaps\\b)|(\\bplace\\b)|(\\bplaces\\b)|(\\bpoint\\b)|(\\bpointed\\b)|(\\bpointing\\b)|(\\bpoints\\b)|(\\bpossible\\b)|(\\bpresent\\b)|(\\bpresented\\b)|(\\bpresenting\\b)|(\\bpresents\\b)|(\\bproblem\\b)|(\\bproblems\\b)|(\\bput\\b)|(\\bputs\\b)|(\\bq\\b)|(\\bquite\\b)|(\\br\\b)|(\\brather\\b)|(\\breally\\b)|(\\bright\\b)|(\\bright\\b)|(\\broom\\b)|(\\brooms\\b)|(\\bs\\b)|(\\bsaid\\b)|(\\bsame\\b)|(\\bsaw\\b)|(\\bsay\\b)|(\\bsays\\b)|(\\bsecond\\b)|(\\bseconds\\b)|(\\bsee\\b)|(\\bseem\\b)|(\\bseemed\\b)|(\\bseeming\\b)|(\\bseems\\b)|(\\bsees\\b)|(\\bseveral\\b)|(\\bshall\\b)|(\\bshe\\b)|(\\bshould\\b)|(\\bshow\\b)|(\\bshowed\\b)|(\\bshowing\\b)|(\\bshows\\b)|(\\bside\\b)|(\\bsides\\b)|(\\bsince\\b)|(\\bsmall\\b)|(\\bsmaller\\b)|(\\bsmallest\\b)|(\\bso\\b)|(\\bsome\\b)|(\\bsomebody\\b)|(\\bsomeone\\b)|(\\bsomething\\b)|(\\bsomewhere\\b)|(\\bstate\\b)|(\\bstates\\b)|(\\bstill\\b)|(\\bstill\\b)|(\\bsuch\\b)|(\\bsure\\b)|(\\bt\\b)|(\\btake\\b)|(\\btaken\\b)|(\\bthan\\b)|(\\bthat\\b)|(\\bthe\\b)|(\\btheir\\b)|(\\bthem\\b)|(\\bthen\\b)|(\\bthere\\b)|(\\btherefore\\b)|(\\bthese\\b)|(\\bthey\\b)|(\\bthing\\b)|(\\bthings\\b)|(\\bthink\\b)|(\\bthinks\\b)|(\\bthis\\b)|(\\bthose\\b)|(\\bthough\\b)|(\\bthought\\b)|(\\bthoughts\\b)|(\\bthree\\b)|(\\bthrough\\b)|(\\bthus\\b)|(\\bto\\b)|(\\btoday\\b)|(\\btogether\\b)|(\\btoo\\b)|(\\btook\\b)|(\\btoward\\b)|(\\bturn\\b)|(\\bturned\\b)|(\\bturning\\b)|(\\bturns\\b)|(\\btwo\\b)|(\\bu\\b)|(\\bunder\\b)|(\\buntil\\b)|(\\bup\\b)|(\\bupon\\b)|(\\bus\\b)|(\\buse\\b)|(\\bused\\b)|(\\buses\\b)|(\\bv\\b)|(\\bvery\\b)|(\\bw\\b)|(\\bwant\\b)|(\\bwanted\\b)|(\\bwanting\\b)|(\\bwants\\b)|(\\bwas\\b)|(\\bway\\b)|(\\bways\\b)|(\\bwe\\b)|(\\bwell\\b)|(\\bwells\\b)|(\\bwent\\b)|(\\bwere\\b)|(\\bwhat\\b)|(\\bwhen\\b)|(\\bwhere\\b)|(\\bwhether\\b)|(\\bwhich\\b)|(\\bwhile\\b)|(\\bwho\\b)|(\\bwhole\\b)|(\\bwhose\\b)|(\\bwhy\\b)|(\\bwill\\b)|(\\bwith\\b)|(\\bwithin\\b)|(\\bwithout\\b)|(\\bwork\\b)|(\\bworked\\b)|(\\bworking\\b)|(\\bworks\\b)|(\\bwould\\b)|(\\bx\\b)|(\\by\\b)|(\\byear\\b)|(\\byears\\b)|(\\byet\\b)|(\\byou\\b)|(\\byoung\\b)|(\\byounger\\b)|(\\byoungest\\b)|(\\byour\\b)|(\\byours\\b)|(\\bz\\b)";

@end
