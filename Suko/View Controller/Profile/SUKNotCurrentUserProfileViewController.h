//
//  SUKNotCurrentUserProfileViewController.h
//  Suko
//
//  Created by Alice Zhang on 7/14/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

/** A view controller for the profile page of a user who is not the current user. */
@interface SUKNotCurrentUserProfileViewController : UIViewController

/** The user whose information will be displayed. */
@property (nonatomic, strong) PFUser *userToDisplay;

@end

NS_ASSUME_NONNULL_END
