//
//  ChooseMovieView.m
//  Suko
//
//  Created by Alice Zhang on 7/26/22.
//

#import "SUKChooseMovieView.h"
#import "UIImageView+AFNetworking.h"

@interface SUKChooseMovieView ()

/** Subview of  ChooseMovieView that actually displays the movie information */
@property (nonatomic, strong) UIView *informationView;

/** Label that displays the movie's title */
@property (nonatomic, strong) UILabel *movieNameLabel;

@end

@implementation SUKChooseMovieView

#pragma mark - Constants
CGFloat const kInfoViewBottomHeight = 60.f;
CGFloat const kMovieLabelLeftPadding = 12.f;
CGFloat const kMovieLabelTopPadding = 17.f;

#pragma mark - Object Lifecycle

- (instancetype)initWithFrame:(CGRect)frame movie:(SUKMovie *)movie options:(MDCSwipeToChooseViewOptions *)options {
    self = [super initWithFrame:frame options:options];
    if (self) {
        _movie = movie;
        
        NSString *moviePosterString = self.movie.posterURL;
        NSURL *url = [NSURL URLWithString:moviePosterString];
        if (url != nil) {
            [self.imageView setImageWithURL:url];
        }
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        self.imageView.autoresizingMask = self.autoresizingMask;

        [self constructInformationView];
    }
    return self;
}

#pragma mark - Internal Methods

- (void)constructInformationView {
    CGRect bottomFrame = CGRectMake(0,
                                    CGRectGetHeight(self.bounds) - kInfoViewBottomHeight,
                                    CGRectGetWidth(self.bounds),
                                    kInfoViewBottomHeight);
    _informationView = [[UIView alloc] initWithFrame:bottomFrame];
    _informationView.backgroundColor = [UIColor whiteColor];
    _informationView.clipsToBounds = YES;
    _informationView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                        UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_informationView];

    [self constructMovieNameLabel];
}

- (void)constructMovieNameLabel {
    CGRect frame = CGRectMake(kMovieLabelLeftPadding,
                              kMovieLabelTopPadding,
                              floorf(CGRectGetWidth(_informationView.frame) / 7 * 6),
                              CGRectGetHeight(_informationView.frame) - kMovieLabelTopPadding);
    _movieNameLabel = [[UILabel alloc] initWithFrame:frame];
    _movieNameLabel.text = [NSString stringWithFormat:@"%@", self.movie.title];
    [_informationView addSubview:_movieNameLabel];
}

@end
