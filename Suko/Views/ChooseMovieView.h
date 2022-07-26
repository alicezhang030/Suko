//
//  ChooseMovieView.h
//  Suko
//
//  Created by Alice Zhang on 7/26/22.
//

#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "SUKMovie.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChooseMovieView : MDCSwipeToChooseView
@property (nonatomic, strong, readonly) SUKMovie *movie;

- (instancetype)initWithFrame:(CGRect)frame movie:(SUKMovie *)movie options:(MDCSwipeToChooseViewOptions *)options;
@end

NS_ASSUME_NONNULL_END
