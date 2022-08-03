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

/**
 * A CollectionView that displays a horizontal row of anime
 */
@interface SUKHomeCollectionView : UICollectionView

/** The indexPath of the TableView cell it is embedded within */
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

/**
 * Custom TableViewCell that displays a header label, a see more label, and a collection view of anime
 */
@interface SUKHomeTableViewCell : UITableViewCell

/** The CollectionView embedded within this cell */
@property (weak, nonatomic) IBOutlet SUKHomeCollectionView *collectionView;

/** The header label (ex. Top Anime) */
@property (weak, nonatomic) IBOutlet UILabel *rowHeaderLabel;

/** The anime being displayed in this cell's collection view */
@property (nonatomic, strong) NSArray<SUKAnime *> *arrOfAnime;

/** This cell's  SUKHomeTableViewCellDelegate delegate */
@property (nonatomic, weak) id<SUKHomeTableViewCellDelegate> delegate;

/**
 * Set the embedded CollectionView's delegate and data source
 *
 * @param dataSourceDelegate The delegate of the CollectionView (ex. SUKHomeViewController)
 * @param indexPath The indexPath of the TableView cell it is embedded within
 */
- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath;

@end

/**
 * A delegate to handle segue from SUKHomeTableViewCell to some other view controller (ex. SUKAnimeListViewController)
 */
@protocol SUKHomeTableViewCellDelegate

/**
 * Called when the See All label is tapped. Starts segue from home view to a list view containing the anime displayed within the collection view embedded within the TableView cell.
 *
 * @param cell The table view cell that contains the "see all" label that was tapped
 */
- (void)segueSUKHomeTableViewCell:(SUKHomeTableViewCell *)cell;
@end

NS_ASSUME_NONNULL_END
