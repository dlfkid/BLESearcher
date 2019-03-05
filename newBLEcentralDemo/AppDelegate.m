//
//  AppDelegate.m
//  newBLEcentralDemo
//
//  Created by Ivan_deng on 2017/7/31.
//  Copyright © 2017年 Ivan_deng. All rights reserved.
//

#import "AppDelegate.h"


#import "MainViewController.h"

// helpers
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "BLECentralManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


#pragma mark - InitialSetup

- (void)setupWindow {
  self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
  [self.window makeKeyAndVisible];
  [self.window setBackgroundColor:[UIColor whiteColor]];
}

- (void)setupRootViewController {
  MainViewController *main = [[MainViewController alloc]init];
  UINavigationController *navMain = [[UINavigationController alloc]initWithRootViewController:main];
  [self.window setRootViewController:navMain];
}

#pragma mark - LifeCycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [[IQKeyboardManager sharedManager] setEnable:YES];
  [[BLECentralManager sharedManager] currentState];
  [self setupWindow];
  [self setupRootViewController];
  return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
  
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
  
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
  
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
  
}


- (void)applicationWillTerminate:(UIApplication *)application {
   
}


@end
