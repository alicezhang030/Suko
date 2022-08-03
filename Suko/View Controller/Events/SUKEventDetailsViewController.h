//
//  SUKEventDetailsViewController.h
//  Suko
//
//  Created by Alice Zhang on 7/19/22.
//

#import <UIKit/UIKit.h>
#import "SUKEvent.h"

NS_ASSUME_NONNULL_BEGIN

/** A view controller for displaying the details of an event. */
@interface SUKEventDetailsViewController : UIViewController

/** The event whose details will be displayed. */
@property (nonatomic, strong) SUKEvent *event;

@end

NS_ASSUME_NONNULL_END
