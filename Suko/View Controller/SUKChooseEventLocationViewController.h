//
//  SUKChooseEventLocationViewController.h
//  Suko
//
//  Created by Alice Zhang on 7/19/22.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUKChooseEventLocationViewController : UIViewController
@property (nonatomic, strong) NSString *eventName;
@property (nonatomic, strong) NSString *eventDescription;
@property (nonatomic, strong) NSDate *eventStartDate;
@property (nonatomic, strong) NSDate *eventEndDate;

@end

NS_ASSUME_NONNULL_END
