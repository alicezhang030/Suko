//
//  SUKAPIManager.m
//  Suko
//
//  Created by Alice Zhang on 6/29/22.
//

#import "SUKAPIManager.h"
#import "AFNetworking.h"

static NSString * const baseURLString = @"https://api.jikan.moe/v4";

@interface SUKAPIManager ()
@property (strong, nonatomic) AFHTTPSessionManager *manager;
@end

@implementation SUKAPIManager

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
    return self;
}

/*
    Default: returns 25 animes
 */
- (void)fetchTopAnime:(void(^)(NSArray *animes, NSError *error))completion {
    NSString *fullURLString = [baseURLString stringByAppendingString:@"/top/anime"];
    NSDictionary *params = @{@"type": @"tv"};
    
    [self.manager GET:fullURLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dataDictionary = responseObject;
        NSArray *animeDictionaries = dataDictionary[@"data"];
        
        completion(animeDictionaries, nil);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
