//
//  SUKAnimeListTableViewCell.h
//  Suko
//
//  Created by Alice Zhang on 7/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUKAnimeListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfEpLabel;

@end

NS_ASSUME_NONNULL_END
