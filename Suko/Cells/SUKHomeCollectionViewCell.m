//
//  SUKHomeCollectionViewCell.m
//  Suko
//
//  Created by Alice Zhang on 7/5/22.
//

#import "SUKHomeCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation SUKHomeCollectionViewCell

- (void)setAnime:(SUKAnime *)anime {
    _anime = anime;
    self.animeTitleLabel.text = anime.title;
    
    NSString *animePosterURLString = anime.posterURL;
    NSURL *url = [NSURL URLWithString:animePosterURLString];
    if (url != nil) {
        [self.animePosterImageView setImageWithURL:url];
    }
}

@end
