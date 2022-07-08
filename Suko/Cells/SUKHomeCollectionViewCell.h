//
//  SUKHomeCollectionViewCell.h
//  Suko
//
//  Created by Alice Zhang on 7/5/22.
//

#import <UIKit/UIKit.h>
#import "Anime.h"

NS_ASSUME_NONNULL_BEGIN

@interface SUKHomeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *animePosterImageView;
@property (weak, nonatomic) IBOutlet UILabel *animeTitleLabel;

@property (strong, nonatomic) Anime *anime;

@end

NS_ASSUME_NONNULL_END
