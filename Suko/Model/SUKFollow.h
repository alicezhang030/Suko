//
//  SUKFollow.h
//  Suko
//
//  Created by Alice Zhang on 7/18/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUKFollow : PFObject<PFSubclassing>
/** The user who is doing the following */
@property (nonatomic, strong) PFUser *follower;
/** The user who is being followed */
@property (nonatomic, strong) PFUser *userBeingFollowed;

+ (void) postFollowWithFollower:(PFUser*) follower userBeingFollowed:(PFUser*) followed withCompletion: (PFBooleanResultBlock  _Nullable)completion;
+ (void) deleteFollow: (SUKFollow * _Nullable) follow;

@end

NS_ASSUME_NONNULL_END
