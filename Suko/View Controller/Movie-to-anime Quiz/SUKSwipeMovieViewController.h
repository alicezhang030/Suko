//
//  SUKSwipeMovieViewController.h
//  Suko
//
//  Created by Alice Zhang on 7/26/22.
//

#import <UIKit/UIKit.h>
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "ChooseMovieView.h"
#import "SUKMovie.h"

NS_ASSUME_NONNULL_BEGIN

/** The view controller for the page where users swipe on movies. */
@interface SUKSwipeMovieViewController : UIViewController <MDCSwipeToChooseDelegate>

/** The movie that the front card is displaying. */
@property (nonatomic, strong) SUKMovie *currentMovie;

/** The card that is at the very front. */
@property (nonatomic, strong) ChooseMovieView *frontCardView;

/** The card that is one behind the front card. */
@property (nonatomic, strong) ChooseMovieView *backCardView;

/** The possible genres anime can be. Used for matching movie to anime by genre in the quiz. */
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *animeGenres;

@end

NS_ASSUME_NONNULL_END
