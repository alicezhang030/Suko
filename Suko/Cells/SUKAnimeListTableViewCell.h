//
//  SUKAnimeListTableViewCell.h
//  Suko
//
//  Created by Alice Zhang on 7/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Custom TableViewCell that displays an anime's poster, title, and number of episodes
 */
@interface SUKAnimeListTableViewCell : UITableViewCell

/** The ImageView used to display the anime's poster */
@property (weak, nonatomic) IBOutlet UIImageView *posterView;

/** The label displaying the anime's title */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/** The label displaying the number of episodes this anime has */
@property (weak, nonatomic) IBOutlet UILabel *numOfEpLabel;

@end

NS_ASSUME_NONNULL_END
