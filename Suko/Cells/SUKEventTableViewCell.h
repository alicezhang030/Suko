//
//  SUKEventTableViewCell.h
//  Suko
//
//  Created by Alice Zhang on 7/19/22.
//

#import <UIKit/UIKit.h>
#import "SUKEvent.h"
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SUKEventTableViewCell : UITableViewCell

@property (nonatomic, strong) SUKEvent *event;
@property (weak, nonatomic) IBOutlet PFImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

NS_ASSUME_NONNULL_END
