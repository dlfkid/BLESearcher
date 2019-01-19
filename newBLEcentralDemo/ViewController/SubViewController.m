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

@interface SubViewController ()

@property (nonatomic, assign) NSInteger viewHeight;
@property (nonatomic, assign) NSInteger viewWidth;

@end

@implementation SubViewController

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:CGRectZero];
    self.view.layer.cornerRadius = 10;
    self.view.userInteractionEnabled = YES;
    self.view.clipsToBounds = YES;
}

- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        _viewHeight = size.height;
        _viewWidth = size.width;
    }
    return self;
}

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    [self.view.heightAnchor constraintEqualToConstant:self.viewHeight].active = YES;
    [self.view.widthAnchor constraintEqualToConstant:self.viewWidth].active = YES;
}

@end
