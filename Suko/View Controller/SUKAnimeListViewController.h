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
@property (nonatomic, strong) NSString *listTitle; // the title of the list
@property (nonatomic, strong) NSMutableArray<SUKAnime*> *arrOfAnime; // the animes to display

typedef NS_ENUM(NSInteger, DefaultLibraryLists) {DefaultLibraryListsWantToWatch, DefaultLibraryListsWatching, DefaultLibraryListsWatched};


@end

NS_ASSUME_NONNULL_END
