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

static ControllerAnimationManager *sharedManager = nil;

@implementation ControllerAnimationManager

+ (ControllerAnimationManager *)sharedManager {
    dispatch_once_t onceToken;
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
    [self.baseViewController.view addSubview:self.darkMaskView];
    [self.darkMaskView addSubview:self.showingViewController.view];
    [_showingViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
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
    [self.showingViewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@0);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self.darkMaskView layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [self.showingViewController.view removeFromSuperview];
            [self.darkMaskView removeFromSuperview];
            self.showingViewController = nil;
            self.baseViewController = nil;
        }
    }];
}

@end
