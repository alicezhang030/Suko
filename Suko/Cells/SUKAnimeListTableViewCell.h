//
//  SUKAnimeListTableViewCell.h
//  Suko
//
//  Created by Alice Zhang on 7/7/22.
//

#import <UIKit/UIKit.h>
#import "SUKAnime.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Custom TableViewCell that displays an anime's poster, title, and number of episodes
 */
@interface SUKAnimeListTableViewCell : UITableViewCell

/**
 * Internally configure this cell's subviews given this anime.
 *
 * @param anime The anime that the cell will use to configure its subviews.
 */
- (void)configureCellWithAnime:(SUKAnime *) anime;

@end

NS_ASSUME_NONNULL_END
