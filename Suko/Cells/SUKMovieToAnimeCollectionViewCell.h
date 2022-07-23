//
//  SUKMovieToAnimeCollectionViewCell.h
//  Suko
//
//  Created by Alice Zhang on 7/22/22.
//

#import <UIKit/UIKit.h>
#import "SUKMovie.h"

NS_ASSUME_NONNULL_BEGIN

@interface SUKMovieToAnimeCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) SUKMovie *movie;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@end

NS_ASSUME_NONNULL_END
