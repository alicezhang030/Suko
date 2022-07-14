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
    
    // Remove the gray highlight after you select a cell
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
