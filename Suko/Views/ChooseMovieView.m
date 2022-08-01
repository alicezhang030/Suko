//
//  ChooseMovieView.m
//  Suko
//
//  Created by Alice Zhang on 7/26/22.
//

#import "ChooseMovieView.h"
#import "UIImageView+AFNetworking.h"

@interface ChooseMovieView ()

/** Subview of  ChooseMovieView that actually displays the movie information */
@property (nonatomic, strong) UIView *informationView;

/** Label that displays the movie's title */
@property (nonatomic, strong) UILabel *movieNameLabel;

@end

@implementation ChooseMovieView

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
    CGFloat bottomHeight = 60.f;
    CGRect bottomFrame = CGRectMake(0,
                                    CGRectGetHeight(self.bounds) - bottomHeight,
                                    CGRectGetWidth(self.bounds),
                                    bottomHeight);
    _informationView = [[UIView alloc] initWithFrame:bottomFrame];
    _informationView.backgroundColor = [UIColor whiteColor];
    _informationView.clipsToBounds = YES;
    _informationView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                        UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_informationView];

    [self constructMovieNameLabel];
}

- (void)constructMovieNameLabel {
    CGFloat leftPadding = 12.f;
    CGFloat topPadding = 17.f;
    CGRect frame = CGRectMake(leftPadding,
                              topPadding,
                              floorf(CGRectGetWidth(_informationView.frame) / 7 * 6),
                              CGRectGetHeight(_informationView.frame) - topPadding);
    _movieNameLabel = [[UILabel alloc] initWithFrame:frame];
    _movieNameLabel.text = [NSString stringWithFormat:@"%@", self.movie.title];
    [_informationView addSubview:_movieNameLabel];
}

@end
