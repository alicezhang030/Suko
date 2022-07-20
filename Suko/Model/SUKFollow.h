//
//  SUKFollow.h
//  Suko
//
//  Created by Alice Zhang on 7/18/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUKFollow : PFObject<PFSubclassing>
@property (nonatomic, strong) PFUser *follower;
@property (nonatomic, strong) PFUser *userBeingFollowed;

+ (void) postFollowWithFollower:(PFUser*) follower userBeingFollowed:(PFUser*) followed withCompletion: (PFBooleanResultBlock  _Nullable)completion;
+ (void) deleteFollow: (SUKFollow * _Nullable) follow;

@end

NS_ASSUME_NONNULL_END
