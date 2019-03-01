//
//  SubViewController.m
//  newBLEcentralDemo
//
//  Created by LeonDeng on 2019/1/19.
//  Copyright © 2019 Ivan_deng. All rights reserved.
//

#import "SubViewController.h"

// Helpers
#import <Masonry/Masonry.h>
#import "ControllerAnimationManager.h"

@interface SubViewController ()

@end

@implementation SubViewController

#ifdef DEBUG
- (void)dealloc {
    NSLog(@"%@, has been dealloced", self);
}
#endif

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:CGRectZero];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.cornerRadius = 10;
    self.view.userInteractionEnabled = YES;
    self.view.clipsToBounds = YES;
}

- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        _size = size;
    }
    return self;
}

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
}

#pragma mark - Actions
-(void)hideWithCompletion:(void (^)(void))completion {
    [[ControllerAnimationManager sharedManager] hideViewController];
    !completion ?: completion();
}

@end
