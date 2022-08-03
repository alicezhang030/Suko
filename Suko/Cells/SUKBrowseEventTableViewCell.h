//
//  SUKBrowseEventTableViewCell.h
//  Suko
//
//  Created by Alice Zhang on 7/19/22.
//

#import <UIKit/UIKit.h>
#import "SUKEvent.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Custom TableViewCell used within the browse events view that displays an event's information.
 */
@interface SUKBrowseEventTableViewCell : UITableViewCell

/**
 * Internally configure this cell's subviews given this event.
 *
 * @param event The event that the cell will use to configure its subviews.
 */
- (void)configureCellWithEvent:(SUKEvent *)event;

@end

NS_ASSUME_NONNULL_END
