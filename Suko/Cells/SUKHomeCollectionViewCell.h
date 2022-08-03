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

/**
 * Internally configure this cell's subviews given this anime.
 *
 * @param anime The anime that the cell will use to configure its subviews.
 */
- (void)configureCellWithAnime:(SUKAnime *)anime;

@end

NS_ASSUME_NONNULL_END
