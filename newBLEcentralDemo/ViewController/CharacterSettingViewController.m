//
//  CharacterSettingViewController.m
//  newBLEcentralDemo
//
//  Created by LeonDeng on 2019/1/19.
//  Copyright © 2019 Ivan_deng. All rights reserved.
//

#import "CharacterSettingViewController.h"

// Helpers
#import <Masonry/Masonry.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLECentralManager.h"

@interface CharacterSettingViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) CBCharacteristic *characteristic;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *currentValueLabel;
@property (nonatomic, strong) UITextField *writeValueTextView;
@property (nonatomic, strong) UIButton *actionButton;

@property (nonatomic, assign, getter = isSaveable) BOOL saveable;

@end

static CGFloat const viewHeight = 260;
static CGFloat const viewWidth = 340;

@implementation CharacterSettingViewController

- (instancetype)initWithCharacteristic:(CBCharacteristic *)characteristic {
    self = [super initWithSize:CGSizeMake(viewWidth, viewHeight)];
    if (self) {
        _characteristic = characteristic;
    }
    return self;
}

- (void)setSaveable:(BOOL)saveable {
    _saveable = saveable;
    self.actionButton.selected = self.isSaveable;
}

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupContents];
    [self.view setNeedsUpdateConstraints];
}

- (void)setupContents {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = self.characteristic.description;
    _titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
    _titleLabel.numberOfLines = 0;
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    _currentValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _currentValueLabel.textAlignment = NSTextAlignmentCenter;
    _currentValueLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    _currentValueLabel.textColor = [UIColor blueColor];
    _currentValueLabel.text = [[NSString alloc] initWithData:self.characteristic.value encoding:NSUTF8StringEncoding];
    _currentValueLabel.numberOfLines = 0;
    _currentValueLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    _writeValueTextView = [[UITextField alloc] initWithFrame:CGRectZero];
    _writeValueTextView.placeholder = localizedString(@"ChaaracteristicSettingViewController.writeValueTextView.placeHolder");
    _writeValueTextView.clearButtonMode = UITextFieldViewModeWhileEditing;
    _writeValueTextView.layer.cornerRadius = 10;
    _writeValueTextView.layer.borderWidth = 0.5;
    _writeValueTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _writeValueTextView.delegate = self;
    // 只有属性为可写时才能对属性进行写入
    switch (self.characteristic.properties) {
        case CBCharacteristicPropertyWrite:
        case CBCharacteristicPropertyWriteWithoutResponse:
        case CBCharacteristicPropertyAuthenticatedSignedWrites:
            _writeValueTextView.hidden = NO;
            break;
            
        default:
            _writeValueTextView.hidden = YES;
            break;
    }
    
    _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_actionButton addTarget:self action:@selector(actionButtonDidTappedAction) forControlEvents:UIControlEventTouchUpInside];
    [_actionButton setTitle:localizedString(@"ChaaracteristicSettingViewController.actionButton.title.cancel") forState:UIControlStateNormal];
    [_actionButton setTitle:localizedString(@"ChaaracteristicSettingViewController.actionButton.title.save") forState:UIControlStateSelected];
    [_actionButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.currentValueLabel];
    [self.view addSubview:self.writeValueTextView];
    [self.view addSubview:self.actionButton];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
    }];
    
    [self.currentValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(10);
    }];
    
    [self.writeValueTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.currentValueLabel.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(@44);
    }];
    
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.writeValueTextView.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];
}

- (void)viewDidLayoutSubviews {
    // 子视图布局完毕
    [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.actionButton.mas_bottom).offset(10);
    }];
    [super viewDidLayoutSubviews];
}

#pragma mark - Actions

- (void)actionButtonDidTappedAction {
    if (self.isSaveable && self.writeValueTextView.text.length > 0) {
        // 执行写入操作
    }
    [self hideWithCompletion:nil];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.saveable = YES;
}

@end
