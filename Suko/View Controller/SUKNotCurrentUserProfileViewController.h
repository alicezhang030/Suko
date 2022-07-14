//
//  SUKNotCurrentUserProfileViewController.h
//  Suko
//
//  Created by Alice Zhang on 7/14/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface SUKNotCurrentUserProfileViewController : UIViewController
@property (nonatomic, strong) PFUser *userToDisplay;

@end

NS_ASSUME_NONNULL_END
