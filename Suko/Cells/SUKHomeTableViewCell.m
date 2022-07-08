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
    
    //remove the gray highlight after you select a cell
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITapGestureRecognizer *seeAllTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapSeeAll:)];
    [self.seeAllLabel addGestureRecognizer:seeAllTapGestureRecognizer];
    [self.seeAllLabel setUserInteractionEnabled:YES];
}

- (void) didTapSeeAll:(UITapGestureRecognizer *)sender{
    NSLog(@"Did tap see all");
    [self.delegate segueSUKHomeTableViewCell:self];
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
