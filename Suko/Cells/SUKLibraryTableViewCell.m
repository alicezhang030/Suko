//
//  SUKLibraryTableViewCell.m
//  Suko
//
//  Created by Alice Zhang on 7/8/22.
//

#import "SUKLibraryTableViewCell.h"

@implementation SUKLibraryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureCellWithListTitle:(NSString *) title {
    self.listTitleLabel.text = title;
}

@end
