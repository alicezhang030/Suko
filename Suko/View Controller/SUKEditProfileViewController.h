//
//  SUKEditProfileViewController.h
//  Suko
//
//  Created by Alice Zhang on 7/12/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface SUKEditProfileViewController : UIViewController
@property (nonatomic, strong) PFUser *userToDisplay;

@end

NS_ASSUME_NONNULL_END
