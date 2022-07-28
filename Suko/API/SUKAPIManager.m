//
//  SUKAPIManager.m
//  Suko
//
//  Created by Alice Zhang on 6/29/22.
//

#import "SUKAPIManager.h"
#import "AFNetworking.h"
#import "SUKAnime.h"

static NSString * const baseAnimeURLString = @"https://api.jikan.moe/v4";
static NSString *const baseMovieURLString = @"https://api.themoviedb.org/3";

@interface SUKAPIManager ()
@property (strong, nonatomic) AFHTTPSessionManager *manager;
@end

@implementation SUKAPIManager

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

- (void)cancelAllRequests {
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
}

- (void)fetchAnimeWithID:(NSNumber *)malID completion:(void(^)(SUKAnime* anime, NSError *error))completion {
    NSString *malIDString = [NSString stringWithFormat:@"%d",[malID intValue]];
    NSDictionary *params = @{@"id": malID};
    NSString *fullURLString = [baseAnimeURLString stringByAppendingString:[@"/anime/" stringByAppendingString:[malIDString stringByAppendingString:@"/full"]]];
    
    [self.manager GET:fullURLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *dataDictionary = responseObject;
        SUKAnime *animeObj = [SUKAnime animeWithDictionary:dataDictionary[@"data"]];
        completion(animeObj, nil);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)fetchAnimeFromGenre:(NSString *)genre withLimit:(NSNumber *)limit completion:(void(^)(NSArray<SUKAnime *> *arrofAnime, NSError *error))completion {
    NSDictionary *params = @{@"type": @"tv", @"limit": limit, @"order_by": @"score", @"sort": @"desc", @"genres":genre};
    NSString *fullURLString = [baseAnimeURLString stringByAppendingString:@"/anime"];
    
    [self.manager GET:fullURLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *dataDictionary = responseObject;
        NSArray<SUKAnime *> *arrOfAnimeObjs = [SUKAnime animesWithArrayOfDictionaries:dataDictionary[@"data"]];
        completion(arrOfAnimeObjs, nil);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)fetchTopAnimeWithLimit:(NSNumber *)limit completion:(void(^)(NSArray<SUKAnime *> *arrofAnime, NSError *error))completion {
    NSDictionary *params = @{@"type": @"tv", @"limit": limit};
    NSString *fullURLString = [baseAnimeURLString stringByAppendingString:@"/top/anime"];
    
    [self.manager GET:fullURLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *dataDictionary = responseObject;
        NSArray<SUKAnime *> *arrOfAnimeObjs = [SUKAnime animesWithArrayOfDictionaries:dataDictionary[@"data"]];
        completion(arrOfAnimeObjs, nil);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)fetchAnimeGenres:(void(^)(NSArray<NSDictionary *> *genres, NSError *error))completion {
    NSString *fullURLString = [baseAnimeURLString stringByAppendingString:@"/genres/anime"];
    
    [self.manager GET:fullURLString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *dataDictionary = responseObject;
        completion(dataDictionary[@"data"], nil);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }];
}

- (void)fetchAnimeSearchWithSearchQuery:(NSString *)query completion:(void(^)(NSArray<SUKAnime *> *arrofAnime, NSError *error))completion {
    NSDictionary *params = @{@"q": query, @"type": @"tv", @"sort": @"desc"};
    NSString *fullURLString = [baseAnimeURLString stringByAppendingString:@"/anime"];
    
    [self.manager GET:fullURLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *dataDictionary = responseObject;
        NSArray<NSDictionary *> *arrOfAnimeDictionaries = dataDictionary[@"data"];
        
        // Currently, Jikan API returns data that has been deleted by MyAnimeList already
        // Ex. If you search "One Piece," you will receive 3 One Piece's, and only one of them has a valid URL and with information filled
        // I noticed that invalid data has a popularity field of 0, so this is my workaround for now.
        NSMutableArray<NSDictionary *> *arrOfAnimeDictionariesMutable = [NSMutableArray new];
        for(NSDictionary *animeDictionary in arrOfAnimeDictionaries) {
            if([animeDictionary[@"popularity"] intValue] != 0){
                [arrOfAnimeDictionariesMutable addObject:animeDictionary];
            }
        }
                
        NSArray<SUKAnime *> *arrOfAnimeObjs = [SUKAnime animesWithArrayOfDictionaries:[arrOfAnimeDictionariesMutable copy]];
        completion(arrOfAnimeObjs, nil);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)fetchMovieGenres:(void(^)(NSArray<NSDictionary *> *genres, NSError *error))completion {
    NSString *movieAPIKey = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SUKKeys" ofType:@"plist"]] objectForKey:@"movie_api_key"];
    NSString *fullURLString = [baseMovieURLString stringByAppendingString:@"/genre/movie/list"];
    
    NSDictionary *params = @{@"api_key": movieAPIKey, @"language": @"en-US"};
    [self.manager GET:fullURLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *dataDictionary = responseObject;
        NSArray<NSDictionary *> *movieGenres = dataDictionary[@"genres"];
        completion(movieGenres, nil);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }];
}

- (void)fetchTopMoviesFromPage:(NSNumber *)page completion:(void(^)(NSArray<SUKMovie *> *movies, NSError *error))completion {
    NSString *movieAPIKey = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SUKKeys" ofType:@"plist"]] objectForKey:@"movie_api_key"];
    NSString *fullURLString = [baseMovieURLString stringByAppendingString:@"/movie/popular"];
    NSDictionary *params = @{@"api_key": movieAPIKey, @"language": @"en-US", @"page": page};
    [self.manager GET:fullURLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *dataDictionary = responseObject;
        NSArray<NSDictionary *> *topTwentyMovies = dataDictionary[@"results"];
        NSArray<SUKMovie *> *arrOfMovieObjs = [SUKMovie movieWithArrayOfDictionaries:topTwentyMovies];
        completion(arrOfMovieObjs, nil);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }];
}

@end
