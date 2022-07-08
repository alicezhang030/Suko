//
//  SUKDetailsViewController.h
//  Suko
//
//  Created by Alice Zhang on 7/8/22.
//

#import <UIKit/UIKit.h>
#import "SUKAnime.h"

NS_ASSUME_NONNULL_BEGIN

@interface SUKDetailsViewController : UIViewController
@property (nonatomic, strong) SUKAnime *animeToDisplay;

@end

NS_ASSUME_NONNULL_END
