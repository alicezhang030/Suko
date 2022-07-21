//
//  SUKAPIManager.m
//  Suko
//
//  Created by Alice Zhang on 6/29/22.
//

#import "SUKAPIManager.h"
#import "AFNetworking.h"
#import "SUKAnime.h"

static NSString * const baseURLString = @"https://api.jikan.moe/v4";

@interface SUKAPIManager ()
@property (strong, nonatomic) AFHTTPSessionManager *manager;
@end

@implementation SUKAPIManager
const NSNumber *knumOfAnimeDisplayedPerRow = @10;

+ (instancetype)shared {
    static SUKAPIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [self new];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    self.manager = [AFHTTPSessionManager manager];
    
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    [serializer setRemovesKeysWithNullValues:YES]; // Turn NULL to nil
    [self.manager setResponseSerializer:serializer];
    
    return self;
}

- (void)fetchSpecificAnimeByID:(NSNumber *) malID completion:(void(^)(SUKAnime* anime, NSError *error))completion {
    NSString *malIDString = [NSString stringWithFormat:@"%d",[malID intValue]];
    NSDictionary *params = @{@"id": malID};
    NSString *fullURLString = [baseURLString
                               stringByAppendingString:[@"/anime/"
                                                        stringByAppendingString:[malIDString stringByAppendingString:@"/full"]]];
    [self.manager GET:fullURLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *dataDictionary = responseObject;
        NSDictionary *animeInfoDict = dataDictionary[@"data"]; // array indices each contains a dictionary with info on an anime
        SUKAnime *animeObj = [SUKAnime animeWithDictionary:animeInfoDict]; // array indices each contain an Anime object
        
        completion(animeObj, nil);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)fetchGenreAnime:(NSString *) genre completion:(void(^)(NSArray<SUKAnime*> *arrofAnimeObjs, NSError *error))completion {
    NSDictionary *params = @{@"type": @"tv", @"limit": knumOfAnimeDisplayedPerRow, @"order_by": @"score", @"sort": @"desc", @"genres":genre};
    NSString *fullURLString = [baseURLString stringByAppendingString:@"/anime"];
    
    [self.manager GET:fullURLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *dataDictionary = responseObject;
        NSArray *arrOfAnimeDictionaries = dataDictionary[@"data"]; // array indices each contains a dictionary with info on an anime
        NSArray<SUKAnime*> *arrOfAnimeObjs = [SUKAnime animesWithArrayOfDictionaries:arrOfAnimeDictionaries]; // array indices each contain an Anime object
        
        completion(arrOfAnimeObjs, nil);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)fetchTopAnime:(void(^)(NSArray<SUKAnime*> *arrofAnimeObjs, NSError *error))completion {
    NSDictionary *params = @{@"type": @"tv", @"limit": knumOfAnimeDisplayedPerRow};
    NSString *fullURLString = [baseURLString stringByAppendingString:@"/top/anime"];
    
    [self.manager GET:fullURLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *dataDictionary = responseObject;
        NSArray<NSDictionary*> *arrOfAnimeDictionaries = dataDictionary[@"data"]; // array indices each contains a dictionary with info on an anime
        NSArray<SUKAnime*> *arrOfAnimeObjs = [SUKAnime animesWithArrayOfDictionaries:arrOfAnimeDictionaries]; // array indices each contain an Anime object
        
        completion(arrOfAnimeObjs, nil);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)fetchGenreList:(void(^)(NSArray<NSDictionary*> *genres, NSError *error))completion {
    NSString *fullURLString = [baseURLString stringByAppendingString:@"/genres/anime"];
    
    [self.manager GET:fullURLString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *dataDictionary = responseObject;
        NSArray<NSDictionary*> *genreList = dataDictionary[@"data"];
        completion(genreList, nil);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)fetchAnimeSearchBySearchQuery:(NSString *) query completion:(void(^)(NSArray<SUKAnime*> *arrofAnimeObjs, NSError *error))completion {
    NSDictionary *params = @{@"q": query, @"type": @"tv", @"sort": @"desc"};
    NSString *fullURLString = [baseURLString stringByAppendingString:@"/anime"];
    
    [self.manager GET:fullURLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *dataDictionary = responseObject;
        NSArray<NSDictionary*> *arrOfAnimeDictionaries = dataDictionary[@"data"]; // array indices each contains a dictionary with info on an anime
        
        // Currently, Jikan API returns data that has been deleted by MyAnimeList already
        // Ex. If you search "One Piece," you will receive 3 One Piece's, and only one of them has a valid URL and with information filled
        // I noticed that invalid data has a popularity field of 0, so this is my workaround for now.
        NSMutableArray<NSDictionary*> *arrOfAnimeDictionariesMutable = [NSMutableArray array];
        for(NSDictionary *animeDictionary in arrOfAnimeDictionaries) {
            if([animeDictionary[@"popularity"] intValue] != 0){
                [arrOfAnimeDictionariesMutable addObject:animeDictionary];
            }
        }
        
        arrOfAnimeDictionaries = (NSArray*)arrOfAnimeDictionariesMutable;
        
        NSArray<SUKAnime*> *arrOfAnimeObjs = [SUKAnime animesWithArrayOfDictionaries:arrOfAnimeDictionaries]; // array indices each contain an Anime object
        
        completion(arrOfAnimeObjs, nil);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
