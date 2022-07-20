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

@protocol SUKBrowseEventTableViewCellDelegate;

@interface SUKBrowseEventTableViewCell : UITableViewCell

@property (nonatomic, strong) SUKEvent *event;
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (nonatomic, weak) id<SUKBrowseEventTableViewCellDelegate> delegate;

@end

@protocol SUKBrowseEventTableViewCellDelegate
- (void)profileDoneLoading:(SUKBrowseEventTableViewCell *) cell;
@end

NS_ASSUME_NONNULL_END
