//
//  SUKFollow.m
//  Suko
//
//  Created by Alice Zhang on 7/18/22.
//

#import "SUKFollow.h"

@implementation SUKFollow

@dynamic follower;
@dynamic userBeingFollowed;

+ (nonnull NSString *)parseClassName {
    return @"SUKFollow";
}

+ (void) postFollowWithFollower:(PFUser*) follower userBeingFollowed:(PFUser*) followed withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    SUKFollow *newFollow = [SUKFollow new];
    
    newFollow.follower = follower;
    newFollow.userBeingFollowed = followed;
    
    [newFollow saveInBackgroundWithBlock: completion];
}

+ (void) deleteFollow: (SUKFollow * _Nullable) follow {
    [follow deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Successfully deleted the follow");
        } else {
            NSLog(@"Failed to delete the follow: %@", error.localizedDescription);
        }
    }];
}

@end
