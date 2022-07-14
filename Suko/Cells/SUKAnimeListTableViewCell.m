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
    
    // Remove the gray highlight after you select a cell
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
