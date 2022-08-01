//
//  SUKChooseEventLocationViewController.h
//  Suko
//
//  Created by Alice Zhang on 7/19/22.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

/** View controller that displays a map for users to choose the event location. */
@interface SUKChooseEventLocationViewController : UIViewController

/** The event's name. */
@property (nonatomic, strong) NSString *eventName;

/** The event's description. */
@property (nonatomic, strong) NSString *eventDescription;

/** The event's start date and time. */
@property (nonatomic, strong) NSDate *eventStartDate;

/** The event's end date and time. */
@property (nonatomic, strong) NSDate *eventEndDate;

@end

NS_ASSUME_NONNULL_END
