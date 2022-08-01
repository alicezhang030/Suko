//
//  SUKLibraryTableViewCell.h
//  Suko
//
//  Created by Alice Zhang on 7/8/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Custom TableViewCell within the library view that displays a list title.
 */
@interface SUKLibraryTableViewCell : UITableViewCell

/** Label that displays the title of the list */
@property (weak, nonatomic) IBOutlet UILabel *listTitleLabel;

@end

NS_ASSUME_NONNULL_END
