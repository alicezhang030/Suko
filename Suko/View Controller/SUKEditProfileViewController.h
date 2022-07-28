//
//  SUKEditProfileViewController.h
//  Suko
//
//  Created by Alice Zhang on 7/12/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFUser.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SUKEditProfileDelegate
- (void)userFinishedEditingProfile;
@end

@interface SUKEditProfileViewController : UIViewController
@property (nonatomic, weak) id<SUKEditProfileDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
