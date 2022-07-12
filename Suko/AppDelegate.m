//
//  AppDelegate.m
//  Suko
//
//  Created by Alice Zhang on 6/28/22.
//

#import "AppDelegate.h"
#import "Parse/Parse.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (UIInterfaceOrientationMask)application:(UIApplication *)application
  supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ParseClientConfiguration *config = [ParseClientConfiguration  configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {

            configuration.applicationId = @"Hexd0aFnd5ohlldyN8xwgYdJpNzPPudtegq3aAse";
            configuration.clientKey = @"3vbl7feoOp8FaAG7pBSeGZ1TN3OYErOkKq2X4RR6";
            configuration.server = @"https://parseapi.back4app.com";
        }];

    [Parse initializeWithConfiguration:config];
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
