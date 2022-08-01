//
//  SUKBrowseEventTableViewCell.h
//  Suko
//
//  Created by Alice Zhang on 7/19/22.
//

#import <UIKit/UIKit.h>
#import "SUKEvent.h"
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Custom TableViewCell used within the browse events view that displays an event's information.
 */
@interface SUKBrowseEventTableViewCell : UITableViewCell

/** The event to be displayed */
@property (nonatomic, strong) SUKEvent *event;

/** The profile image of the user who posted this event */
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;

/** Label displaying the username of the user who posted this event */
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

/** Label displaying the name of the event */
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;

/** Label displaying the date and time of the event */
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

NS_ASSUME_NONNULL_END
