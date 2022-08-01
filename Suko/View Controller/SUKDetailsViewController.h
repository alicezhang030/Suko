//
//  SUKDetailsViewController.h
//  Suko
//
//  Created by Alice Zhang on 7/8/22.
//

#import <UIKit/UIKit.h>
#import "SUKAnime.h"
#import "MKDropdownMenu.h"

NS_ASSUME_NONNULL_BEGIN

/** A view controller for displaying the details of an anime. */
@interface SUKDetailsViewController : UIViewController

/** The anime whose details will be displayed. */
@property (nonatomic, strong) SUKAnime *animeToDisplay;

@end

NS_ASSUME_NONNULL_END
