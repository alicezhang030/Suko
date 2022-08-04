//
//  ChooseMovieView.h
//  Suko
//
//  Created by Alice Zhang on 7/26/22.
//

#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "SUKMovie.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Reusable rectangular view used in the movies-to-anime feature. Displays movie poster and movie title.
 */
@interface SUKChooseMovieView : MDCSwipeToChooseView

/** The movie whose information will be displayed in this view */
@property (nonatomic, strong, readonly) SUKMovie *movie;

/**
 * Initializes and returns a ChooseMovieView using the provided frame, movie, and options
 *
 * @param frame  A CGRect frame that defines the size of the view
 * @param movie The movie whose information will be displayed in this view
 * @param options Options used to customize the behavior and appearance of the view
 */
- (instancetype)initWithFrame:(CGRect)frame movie:(SUKMovie *)movie options:(MDCSwipeToChooseViewOptions *)options;

@end

NS_ASSUME_NONNULL_END
