//
//  SUKHomeTableViewCell.h
//  Suko
//
//  Created by Alice Zhang on 7/5/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUKHomeCollectionView : UICollectionView
@property (nonatomic, strong) NSIndexPath *indexPath;
@end

@interface SUKHomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet SUKHomeCollectionView *collectionView;

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
