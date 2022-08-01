//
//  SUKFollow.h
//  Suko
//
//  Created by Alice Zhang on 7/18/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Model used to represent a follow relationship between two users.
 */
@interface SUKFollow : PFObject<PFSubclassing>

/** The user who is doing the following */
@property (nonatomic, strong) PFUser *follower;

/** The user who is being followed */
@property (nonatomic, strong) PFUser *userBeingFollowed;

/**
 * Creates a SUKFollow object using the information provided by the parameters and posts the SUKFollow to the app's Parse server.
 *
 * @param follower The user who is doing the following
 * @param followed The user who is being followed
 * @param completion Completion block
 */
+ (void)postFollowWithFollower:(PFUser *)follower userBeingFollowed:(PFUser *)followed withCompletion:(PFBooleanResultBlock  _Nullable)completion;

/**
 * Deletes the SUKFollow from the database.
 *
 * @param follow The SUKFollow object to be deleted from the database.
 */
+ (void)deleteFollow:(SUKFollow * _Nullable)follow;

@end

NS_ASSUME_NONNULL_END
