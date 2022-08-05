//
//  SUKReviewTableViewCell.h
//  Suko
//
//  Created by Alice Zhang on 8/5/22.
//

#import <UIKit/UIKit.h>
#import "SUKReview.h"

NS_ASSUME_NONNULL_BEGIN

@interface SUKReviewTableViewCell : UITableViewCell
- (void)configureCellWithReview:(SUKReview *)review;
@end

NS_ASSUME_NONNULL_END
