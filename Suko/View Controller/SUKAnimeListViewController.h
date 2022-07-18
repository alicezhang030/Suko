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
@property (nonatomic, strong) NSArray<SUKAnime*> *arrOfAnime; // the animes to display
@property (nonatomic, strong) NSArray<NSNumber*> *arrOfAnimeMALID; // the animes to display
@property (nonatomic, strong) PFUser *userToDisplay; // which user's want to watch, watching, and watched lists to display

typedef NS_ENUM(NSInteger, DefaultLibraryLists) {DefaultLibraryListsWantToWatch, DefaultLibraryListsWatching, DefaultLibraryListsWatched};

@end

NS_ASSUME_NONNULL_END
