//
//  AppDelegate.m
//  GoodLife
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "AppDelegate.h"
#import "ApplicationViewController.h"



#import "WMPageController.h"
#import "CategoryViewController.h"
#import "ColumnViewController.h"
#import "RankViewController.h"

@interface AppDelegate ()

@property (nonatomic,copy) NSArray *titles;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"update"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"top20"];
    
    self.titles = @[@"分类",@"精品",@"排行"];
    WMPageController *pageController = [self createPageViews];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pageController];
//    [nav.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed: @"nav-bg"] forBarMetrics:UIBarMetricsDefault];
    self.window.rootViewController = nav;
    return YES;
}
-(WMPageController *)createPageViews {
    NSMutableArray *pageViews = [[NSMutableArray alloc] init];
    Class vcClass = [CategoryViewController class];
    [pageViews addObject:vcClass];
    vcClass = [ColumnViewController class];
    [pageViews addObject:vcClass];
    vcClass = [RankViewController class];
    [pageViews addObject:vcClass];
    
    WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:pageViews andTheirTitles:self.titles];
    pageVC.pageAnimatable = YES;
    pageVC.menuItemWidth = 85;
    pageVC.postNotification = YES;
    return pageVC;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
