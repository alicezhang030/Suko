//
//  SUKHomeCollectionViewCell.m
//  Suko
//
//  Created by Alice Zhang on 7/5/22.
//

#import "SUKHomeCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface SUKHomeCollectionViewCell ()

/** The ImageView used to display the anime's poster */
@property (weak, nonatomic) IBOutlet UIImageView *posterView;

/** The label displaying the anime's title */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation SUKHomeCollectionViewCell

- (void)configureCellWithAnime:(SUKAnime *)anime {
    self.titleLabel.text = anime.title;
    
    NSString *animePosterURLString = anime.posterURL;
    NSURL *url = [NSURL URLWithString:animePosterURLString];
    if (url != nil) {
        [self.posterView setImageWithURL:url];
    }
}

@end
