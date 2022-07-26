//
//  SUKAnimeListViewController.h
//  Suko
//
//  Created by Alice Zhang on 7/7/22.
//

#import <UIKit/UIKit.h>
#import "SUKAnime.h"

NS_ASSUME_NONNULL_BEGIN

@interface SUKAnimeListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
/** The title of the list being displayed */
@property (nonatomic, strong) NSString *listTitle;
/** Array of anime in the list, with each anime stored as a SUKAnime object */
@property (nonatomic, strong) NSArray<SUKAnime *> *arrOfAnime;
/** Array of anime in the list, with each anime stored as its MyAnimeList ID */
@property (nonatomic, strong) NSArray<NSNumber *> *arrOfAnimeMALID;
@end

NS_ASSUME_NONNULL_END
