//
//  UsersLists.m
//  Suko
//
//  Created by Alice Zhang on 7/11/22.
//

#import "SUKUsersLists.h"

@implementation SUKUsersLists

@dynamic user;
@dynamic wantToWatchArr;
@dynamic watchingArr;
@dynamic watchedArr;

+ (nonnull NSString *)parseClassName {
    return @"SUKUsersLists";
}

+ (void) postUsersLists: (PFUser * _Nullable) user defaultList:(DefaultLists) list malId:(NSNumber *) malId withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    SUKUsersLists *newUsersList = [SUKUsersLists new];
    
    // Set up the columns
    newUsersList.user = user;
    newUsersList.wantToWatchArr = [[NSArray init] alloc];
    newUsersList.watchingArr = [[NSArray init] alloc];
    newUsersList.watchedArr = [[NSArray init] alloc];
    
    // Add anime to list
    NSMutableArray *listWithAnimeAdded = [[NSMutableArray init] alloc];
    [listWithAnimeAdded addObject:malId];
    
    switch(list) {
        case DefaultListsWantToWatch:
            newUsersList.wantToWatchArr = [listWithAnimeAdded copy];
        case DefaultListsWatching:
            newUsersList.watchingArr = [listWithAnimeAdded copy];
        case DefaultListsWatched:
            newUsersList.watchedArr = [listWithAnimeAdded copy];
    }
    
    // Save to database
    [newUsersList saveInBackgroundWithBlock: completion];
}

@end
