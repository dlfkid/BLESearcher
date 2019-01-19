//
//  ControllerAnimationManager.h
//  newBLEcentralDemo
//
//  Created by LeonDeng on 2019/1/19.
//  Copyright © 2019 Ivan_deng. All rights reserved.
//

@class SubViewController;

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ControllerAnimationManager : NSObject

@property (nonatomic, strong, nullable) UIViewController *baseViewController;
@property (nonatomic, strong, nullable) SubViewController *showingViewController;

+ (ControllerAnimationManager *)sharedManager;

+ (void)popUp:(SubViewController *)popingViewController InViewConrtroller:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END
