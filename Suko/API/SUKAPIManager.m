//
//  SUKAPIManager.m
//  Suko
//
//  Created by Alice Zhang on 6/29/22.
//

#import "SUKAPIManager.h"
#import "AFNetworking.h"
#import "Anime.h"

static NSString * const baseURLString = @"https://api.jikan.moe/v4";

@interface SUKAPIManager ()
@property (strong, nonatomic) AFHTTPSessionManager *manager;
@end

@implementation SUKAPIManager
const NSNumber *knumOfAnimeDisplayedPerRow = @2;

+ (instancetype)shared {
    static SUKAPIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    self.manager = [AFHTTPSessionManager manager];
    
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    [serializer setRemovesKeysWithNullValues:YES]; //turn NULL to nil
    [self.manager setResponseSerializer:serializer];
    
    return self;
}

- (void)fetchGenreAnime:(NSString *) genre completion:(void(^)(NSArray *genres, NSError *error))completion {
    NSDictionary *params = @{@"type": @"tv", @"limit": knumOfAnimeDisplayedPerRow, @"order_by": @"score", @"sort": @"desc", @"genres":genre};
    NSString *fullURLString = [baseURLString stringByAppendingString:@"/anime"];
    
    [self.manager GET:fullURLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *dataDictionary = responseObject;
        NSArray *arrOfAnimeDictionaries = dataDictionary[@"data"]; // array indices each contains a dictionary with info on an anime
        NSArray *arrOfAnimeObjs = [Anime animesWithArray:arrOfAnimeDictionaries]; // array indices each contain an Anime object
        
        completion(arrOfAnimeObjs, nil);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)fetchTopAnime:(void(^)(NSArray *genres, NSError *error))completion {
    NSDictionary *params = @{@"type": @"tv", @"limit": knumOfAnimeDisplayedPerRow};
    NSString *fullURLString = [baseURLString stringByAppendingString:@"/top/anime"];
    
    [self.manager GET:fullURLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *dataDictionary = responseObject;
        NSArray *arrOfAnimeDictionaries = dataDictionary[@"data"]; // array indices each contains a dictionary with info on an anime
        NSArray *arrOfAnimeObjs = [Anime animesWithArray:arrOfAnimeDictionaries]; // array indices each contain an Anime object
        
        completion(arrOfAnimeObjs, nil);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)fetchGenreList:(void(^)(NSArray *genres, NSError *error))completion {
    NSString *fullURLString = [baseURLString stringByAppendingString:@"/genres/anime"];
    
    [self.manager GET:fullURLString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *dataDictionary = responseObject;
        NSArray *genreList = dataDictionary[@"data"];
        completion(genreList, nil);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
