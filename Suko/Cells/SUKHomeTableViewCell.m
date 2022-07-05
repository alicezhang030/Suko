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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    // Set up horizontal CollectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 9, 10);
    layout.itemSize = CGSizeMake(158, 217);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    /*
    [self.collectionView registerClass: [SUKHomeCollectionViewCell class] forCellWithReuseIdentifier:HomeCollectionViewCellIdentifier];
    
    [self.contentView addSubview:self.collectionView];*/
    
    return self;
}

// Adjust the side of the collection view to fill the cell in
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
