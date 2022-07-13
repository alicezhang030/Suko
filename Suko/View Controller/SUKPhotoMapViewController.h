//
//  SUKPhotoMapViewController.h
//  Suko
//
//  Created by Alice Zhang on 7/13/22.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUKPhotoMapViewController : UIViewController
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

NS_ASSUME_NONNULL_END
