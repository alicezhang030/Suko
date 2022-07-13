//
//  UsersLists.h
//  Suko
//
//  Created by Alice Zhang on 7/11/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUKUsersLists : PFObject<PFSubclassing>

@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) NSArray *wantToWatchArr;
@property (nonatomic, strong) NSArray *watchingArr;
@property (nonatomic, strong) NSArray *watchedArr;

typedef NS_ENUM(NSInteger, DefaultLists) {DefaultListsRemoveFromLists, DefaultListsWantToWatch, DefaultListsWatching, DefaultListsWatched};

+ (void) postUsersLists: (PFUser * _Nullable) user defaultList:(DefaultLists) list malId:(NSNumber *) malID withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
