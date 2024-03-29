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

@interface SUKHomeTableViewCell ()
/** The label that says "see all" */
@property (weak, nonatomic) IBOutlet UILabel *seeAllLabel;
@end

@implementation SUKHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITapGestureRecognizer *seeAllTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapSeeAll:)];
    [self.seeAllLabel addGestureRecognizer:seeAllTapGestureRecognizer];
    [self.seeAllLabel setUserInteractionEnabled:YES];
}

- (void)didTapSeeAll:(UITapGestureRecognizer *)sender {
    [self.delegate segueSUKHomeTableViewCell:self];
}

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath {
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
