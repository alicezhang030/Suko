//
//  SUKMovieToAnimeCollectionViewCell.m
//  Suko
//
//  Created by Alice Zhang on 7/22/22.
//

#import "SUKMovieToAnimeCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation SUKMovieToAnimeCollectionViewCell

- (void)setMovie:(SUKMovie *)movie {
    _movie = movie;
    self.movieTitleLabel.text = movie.title;
    NSString *moviePosterString = movie.posterURL;
    NSURL *url = [NSURL URLWithString:moviePosterString];
    if (url != nil) {
        [self.posterView setImageWithURL:url];
    }
}

@end
