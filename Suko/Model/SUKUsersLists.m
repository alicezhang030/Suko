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

+ (void) postUsersLists: (PFUser * _Nullable) user defaultList:(DefaultLists) list malId:(NSNumber *) malID withCompletion: (PFBooleanResultBlock  _Nullable)completion {

     PFQuery *query = [PFQuery queryWithClassName:@"SUKUsersLists"];
     [query whereKey:@"user" equalTo:[PFUser currentUser]];
          
     [query findObjectsInBackgroundWithBlock:^(NSArray<SUKUsersLists*> *usersLists, NSError *error) {
         if (usersLists != nil) {
            if(usersLists.count > 1) {
                NSLog(@"More than one entry for this user in the database");
            } else if (usersLists.count == 1){ // User has added animes to lists before
                SUKUsersLists *usersListObj = [usersLists objectAtIndex:0];

                switch(list) {
                    case DefaultListsRemoveFromLists:
                        if([usersListObj.wantToWatchArr containsObject:malID]) {
                            NSMutableArray *wantToWatchArrMutable = [usersListObj.wantToWatchArr mutableCopy];
                            [wantToWatchArrMutable removeObject:malID];
                            usersListObj.wantToWatchArr = [wantToWatchArrMutable copy];
                        } else if([usersListObj.watchingArr containsObject:malID]) {
                            NSMutableArray *watchingArrMutable = [usersListObj.watchingArr mutableCopy];
                            [watchingArrMutable removeObject:malID];
                            usersListObj.watchingArr = [watchingArrMutable copy];
                        } else if([usersListObj.watchedArr containsObject:malID]) {
                            NSMutableArray *watchedArrMutable = [usersListObj.watchedArr mutableCopy];
                            [watchedArrMutable removeObject:malID];
                            usersListObj.watchedArr = [watchedArrMutable copy];
                        }
                        break;
                    case DefaultListsWantToWatch:
                        if(![usersListObj.wantToWatchArr containsObject:malID]) {
                            NSMutableArray *wantToWatchArrMutable = [usersListObj.wantToWatchArr mutableCopy];
                            [wantToWatchArrMutable addObject:malID];
                            usersListObj.wantToWatchArr = [wantToWatchArrMutable copy];
                        }

                        if([usersListObj.watchingArr containsObject:malID]) {
                            NSMutableArray *watchingArrMutable = [usersListObj.watchingArr mutableCopy];
                            [watchingArrMutable removeObject:malID];
                            usersListObj.watchingArr = [watchingArrMutable copy];
                        } else if([usersListObj.watchedArr containsObject:malID]) {
                            NSMutableArray *watchedArrMutable = [usersListObj.watchedArr mutableCopy];
                            [watchedArrMutable removeObject:malID];
                            usersListObj.watchedArr = [watchedArrMutable copy];
                        }
                        
                        break;
                    case DefaultListsWatching:
                         if(![usersListObj.watchingArr containsObject:malID]) {
                             NSMutableArray *watchingArrMutable = [usersListObj.watchingArr mutableCopy];
                             [watchingArrMutable addObject:malID];
                             usersListObj.watchingArr = [watchingArrMutable copy];
                         }
                        
                        if([usersListObj.wantToWatchArr containsObject:malID]) {
                            NSMutableArray *wantToWatchArrMutable = [usersListObj.wantToWatchArr mutableCopy];
                            [wantToWatchArrMutable removeObject:malID];
                            usersListObj.wantToWatchArr = [wantToWatchArrMutable copy];
                        } else if([usersListObj.watchedArr containsObject:malID]) {
                            NSMutableArray *watchedArrMutable = [usersListObj.watchedArr mutableCopy];
                            [watchedArrMutable removeObject:malID];
                            usersListObj.watchedArr = [watchedArrMutable copy];
                        }
                        
                        break;
                    case DefaultListsWatched:
                         if(![usersListObj.watchedArr containsObject:malID]) {
                            NSMutableArray *watchedArrMutable = [usersListObj.watchedArr mutableCopy];
                             [watchedArrMutable addObject:malID];
                            usersListObj.watchedArr = [watchedArrMutable copy];
                         }
                        
                        if([usersListObj.watchingArr containsObject:malID]) {
                            NSMutableArray *watchingArrMutable = [usersListObj.watchingArr mutableCopy];
                            [watchingArrMutable removeObject:malID];
                            usersListObj.watchingArr = [watchingArrMutable copy];
                        } else if([usersListObj.wantToWatchArr containsObject:malID]) {
                            NSMutableArray *wantToWatchArrMutable = [usersListObj.wantToWatchArr mutableCopy];
                            [wantToWatchArrMutable removeObject:malID];
                            usersListObj.wantToWatchArr = [wantToWatchArrMutable copy];
                        }
                        
                        break;
                    default:
                        break;
                }
     
                [usersListObj saveInBackgroundWithBlock: completion];
                
            } else { // User has not added anything to a list before
                 SUKUsersLists *newUsersList = [SUKUsersLists new];
                 
                 // Set up the columns
                 newUsersList.user = user;
                 newUsersList.wantToWatchArr = [[NSArray alloc] init];
                 newUsersList.watchingArr = [[NSArray alloc] init];
                 newUsersList.watchedArr = [[NSArray alloc] init];
                 
                 // Add anime to list
                 NSMutableArray *listWithAnimeAdded = [[NSMutableArray alloc] init];
                 [listWithAnimeAdded addObject:malID];
                 
                 switch(list) {
                     case DefaultListsRemoveFromLists:
                         break;
                     case DefaultListsWantToWatch:
                         newUsersList.wantToWatchArr = [listWithAnimeAdded copy];
                         break;
                     case DefaultListsWatching:
                         newUsersList.watchingArr = [listWithAnimeAdded copy];
                         break;
                     case DefaultListsWatched:
                         newUsersList.watchedArr = [listWithAnimeAdded copy];
                         break;
                     default:
                         break;
                 }
     
                [newUsersList saveInBackgroundWithBlock: completion];
            }
         } else {
             NSLog(@"%@", error.localizedDescription);
         }
     }];

}


@end
