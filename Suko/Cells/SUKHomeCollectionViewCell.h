//
//  SUKHomeCollectionViewCell.h
//  Suko
//
//  Created by Alice Zhang on 7/5/22.
//

#import <UIKit/UIKit.h>
#import "SUKAnime.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Custom CollectionViewCell that displays an anime's poster and title
 */
@interface SUKHomeCollectionViewCell : UICollectionViewCell

/** The anime being displayed by this cell */
@property (strong, nonatomic) SUKAnime *anime;

/** The ImageView used to display the anime's poster */
@property (weak, nonatomic) IBOutlet UIImageView *posterView;

/** The label displaying the anime's title */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
