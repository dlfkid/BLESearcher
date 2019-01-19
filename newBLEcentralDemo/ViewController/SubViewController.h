//
//  SubViewController.h
//  newBLEcentralDemo
//
//  Created by LeonDeng on 2019/1/19.
//  Copyright © 2019 Ivan_deng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SubViewController : UIViewController

@property (nonatomic, assign) CGSize size;

- (instancetype)initWithSize:(CGSize)size;

- (void)hideWithCompletion:(nullable void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END
