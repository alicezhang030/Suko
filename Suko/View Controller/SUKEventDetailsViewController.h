//
//  SUKEventDetailsViewController.h
//  Suko
//
//  Created by Alice Zhang on 7/19/22.
//

#import <UIKit/UIKit.h>
#import "SUKEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface SUKEventDetailsViewController : UIViewController
@property (nonatomic, strong) SUKEvent *event;

- (void) setEvent:(SUKEvent*) event withHost:(PFUser *) user;

@end

NS_ASSUME_NONNULL_END
