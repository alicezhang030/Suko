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

+ (void) postFollow:(PFUser*) follower userBeingFollowed:(PFUser*) followed withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    SUKFollow *newFollow = [SUKFollow new];
    
    // Set up the columns
    newFollow.follower = follower;
    newFollow.userBeingFollowed = followed;
    
    [newFollow saveInBackgroundWithBlock: completion];
}

@end
