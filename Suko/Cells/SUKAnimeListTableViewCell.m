//
//  SUKAnimeListTableViewCell.m
//  Suko
//
//  Created by Alice Zhang on 7/7/22.
//

#import "SUKAnimeListTableViewCell.h"

@implementation SUKAnimeListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
