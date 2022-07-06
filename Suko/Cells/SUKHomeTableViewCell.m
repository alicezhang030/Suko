//
//  SUKHomeTableViewCell.m
//  Suko
//
//  Created by Alice Zhang on 7/5/22.
//

#import "SUKHomeTableViewCell.h"
#import "SUKHomeCollectionViewCell.h"

@implementation SUKHomeCollectionView

@end

@implementation SUKHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

// Adjusts the collection view so that it fills the entire horizontal space
-(void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame = self.contentView.bounds;
}

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath{
    self.collectionView.dataSource = dataSourceDelegate;
    self.collectionView.delegate = dataSourceDelegate;
    self.collectionView.indexPath = indexPath;
    [self.collectionView setContentOffset:self.collectionView.contentOffset animated:NO];
    
    [self.collectionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
