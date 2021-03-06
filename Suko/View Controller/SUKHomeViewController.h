//
//  SUKHomeViewController.h
//  Suko
//
//  Created by Alice Zhang on 7/5/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUKHomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

extern NSString *const kHomeToAnimeListSegueIdentifier;
extern NSString *const kHomeCollectionCellToDetailsSegueIdentifier;
extern NSNumber *const kNumOfRows;

@end

NS_ASSUME_NONNULL_END
