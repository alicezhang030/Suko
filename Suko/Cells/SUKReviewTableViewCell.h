//
//  SUKReviewTableViewCell.h
//  Suko
//
//  Created by Alice Zhang on 8/5/22.
//

#import <UIKit/UIKit.h>
#import "SUKReview.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SUKReviewCellDelegate;

@interface SUKReviewTableViewCell : UITableViewCell
- (void)configureCellWithReview:(SUKReview *)review;
@property (nonatomic, weak) id<SUKReviewCellDelegate> delegate;
@end

@protocol SUKReviewCellDelegate
- (void)tappedUserProfileOnCell:(SUKReviewTableViewCell *)cell withReview:(SUKReview *) review;
@end

NS_ASSUME_NONNULL_END
