//
//  SUKHomeTableViewCell.h
//  Suko
//
//  Created by Alice Zhang on 7/5/22.
//

#import <UIKit/UIKit.h>
#import "SUKAnime.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SUKHomeTableViewCellDelegate;

@interface SUKHomeCollectionView : UICollectionView
@property (nonatomic, strong) NSIndexPath *indexPath;
@end

@interface SUKHomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet SUKHomeCollectionView *collectionView; 
@property (weak, nonatomic) IBOutlet UILabel *rowHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *seeAllLabel;
@property (nonatomic, strong) NSArray<SUKAnime*> *arrOfAnime; // the animes being displayed in this cell's collection view
@property (nonatomic, weak) id<SUKHomeTableViewCellDelegate> delegate;

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath;

@end

@protocol SUKHomeTableViewCellDelegate
- (void)segueSUKHomeTableViewCell:(SUKHomeTableViewCell *) cell;
@end

NS_ASSUME_NONNULL_END
