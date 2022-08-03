//
//  SUKAnimeListTableViewCell.m
//  Suko
//
//  Created by Alice Zhang on 7/7/22.
//

#import "SUKAnimeListTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface SUKAnimeListTableViewCell ()
/** The ImageView used to display the anime's poster */
@property (weak, nonatomic) IBOutlet UIImageView *posterView;

/** The label displaying the anime's title */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/** The label displaying the number of episodes this anime has */
@property (weak, nonatomic) IBOutlet UILabel *numOfEpLabel;
@end

@implementation SUKAnimeListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureCellWithAnime:(SUKAnime *)anime {
    self.titleLabel.text = anime.title;
    self.numOfEpLabel.text = [[NSString stringWithFormat:@"%d", anime.numEpisodes] stringByAppendingString:@" Episodes"];
    
    NSURL *url = [NSURL URLWithString:anime.posterURL];
    if (url != nil) {
        [self.posterView setImageWithURL:url];
    }
}

@end
