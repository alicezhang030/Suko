//
//  SUKFollow.m
//  Suko
//
//  Created by Alice Zhang on 7/18/22.
//

#import "SUKFollow.h"

@interface SUKFollow ()
@property (nonatomic, strong, readwrite) PFUser *follower;
@property (nonatomic, strong, readwrite) PFUser *userBeingFollowed;
@end

@implementation SUKFollow

@dynamic follower;
@dynamic userBeingFollowed;

+ (nonnull NSString *)parseClassName {
    return @"SUKFollow";
}

+ (void)postFollowWithFollower:(PFUser *)follower userBeingFollowed:(PFUser *)followed withCompletion:(PFBooleanResultBlock  _Nullable)completion {
    SUKFollow *newFollow = [SUKFollow new];
    
    newFollow.follower = follower;
    newFollow.userBeingFollowed = followed;
    
    [newFollow saveInBackgroundWithBlock: completion];
}

+ (void)deleteFollow:(SUKFollow *)follow {
    [follow deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Failed to delete the follow: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully deleted the follow");
        }
    }];
}

@end
