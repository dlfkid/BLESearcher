//
//  ControllerAnimationManager.m
//  newBLEcentralDemo
//
//  Created by LeonDeng on 2019/1/19.
//  Copyright © 2019 Ivan_deng. All rights reserved.
//

#import "ControllerAnimationManager.h"

// Controllers
#import "SubViewController.h"

// Helpers
#import <Masonry/Masonry.h>

@interface ControllerAnimationManager()

@property (nonatomic, strong) UIVisualEffectView *darkMaskView;
@property (nonatomic, assign) BOOL hasShowingController;

@end

@implementation ControllerAnimationManager

+ (ControllerAnimationManager *)sharedManager {
    static ControllerAnimationManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        sharedManager.hasShowingController = NO;
    });
    return sharedManager;
}

+ (void)popUp:(SubViewController *)popingViewController InViewConrtroller:(UIViewController *)controller {
    ControllerAnimationManager *manager = [ControllerAnimationManager sharedManager];
    manager.baseViewController = controller;
    manager.showingViewController = popingViewController;
    [manager popUpViewController];
}

- (UIVisualEffectView *)darkMaskView {
    if (!_darkMaskView) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _darkMaskView = [[UIVisualEffectView alloc] initWithEffect:blur];
        _darkMaskView.frame = [UIScreen mainScreen].bounds;
        _darkMaskView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(darkMaskViewDidTappedAction)];
        [_darkMaskView addGestureRecognizer:tap];
    }
    return _darkMaskView;
}

- (void)darkMaskViewDidTappedAction {
    [self hideViewController];
}

- (void)popUpViewController{
    if (self.hasShowingController) {
        return;
    }
    // 要在窗口上添加该遮罩，否则用户点击返回时会出现BUG
    [[UIApplication sharedApplication].keyWindow addSubview:self.darkMaskView];
    [self.darkMaskView.contentView addSubview:self.showingViewController.view];
    [self.showingViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.showingViewController.size.width);
        make.height.mas_equalTo(self.showingViewController.size.height);
        make.centerX.equalTo(@0);
        make.centerY.mas_equalTo([UIScreen mainScreen].bounds.size.height + 1000);
    }];
    
    [self.darkMaskView layoutIfNeeded];
    
    [self.showingViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.darkMaskView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hasShowingController = YES;
    }];
}

- (void)hideViewController {
    if (!self.hasShowingController) {
        return;
    }
    [self.showingViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo([UIScreen mainScreen].bounds.size.height + 1000);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self.darkMaskView layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [self.showingViewController.view removeFromSuperview];
            [self.darkMaskView removeFromSuperview];
            self.showingViewController = nil;
            self.baseViewController = nil;
            self.hasShowingController = NO;
        }
    }];
}

@end
