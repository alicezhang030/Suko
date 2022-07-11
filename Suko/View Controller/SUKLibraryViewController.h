//
//  SUKLibraryViewController.h
//  Suko
//
//  Created by Alice Zhang on 7/8/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUKLibraryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

typedef NS_ENUM(NSInteger, DefaultLibraryLists) {DefaultLibraryListsWantToWatch, DefaultLibraryListsWatching, DefaultLibraryListsWatched};

@end

NS_ASSUME_NONNULL_END
