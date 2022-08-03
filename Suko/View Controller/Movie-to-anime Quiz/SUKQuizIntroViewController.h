//
//  SUKQuizIntroViewController.h
//  Suko
//
//  Created by Alice Zhang on 7/27/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** View controller for the quiz introduction page. */
@interface SUKQuizIntroViewController : UIViewController

/** The possible genres anime can be. Used for matching movie to anime by genre in the quiz. */
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *animeGenres;

@end

NS_ASSUME_NONNULL_END
