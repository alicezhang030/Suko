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

@interface SUKSwipeMovieViewController : UIViewController <MDCSwipeToChooseDelegate>
@property (nonatomic, strong) SUKMovie *currentMovie;
@property (nonatomic, strong) ChooseMovieView *frontCardView;
@property (nonatomic, strong) ChooseMovieView *backCardView;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *animeGenres;
@end

NS_ASSUME_NONNULL_END
