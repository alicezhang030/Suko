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

@end

NS_ASSUME_NONNULL_END
