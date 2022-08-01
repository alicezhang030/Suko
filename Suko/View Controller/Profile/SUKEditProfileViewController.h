//
//  SUKEditProfileViewController.h
//  Suko
//
//  Created by Alice Zhang on 7/12/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFUser.h"

NS_ASSUME_NONNULL_BEGIN

/** A delegate to handle when SUKEditProfileViewController is dismissed */
@protocol SUKEditProfileDelegate

/**
 * Called when the user saves its profile.
 */
- (void)userFinishedEditingProfile;

@end

/** A view controller for the page where users edit their profiles. */
@interface SUKEditProfileViewController : UIViewController

/** The SUKEditProfileDelegate for this view controller. */
@property (nonatomic, weak) id<SUKEditProfileDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
