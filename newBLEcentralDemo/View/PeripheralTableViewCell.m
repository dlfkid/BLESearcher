//
//  PeripheralTableViewCell.m
//  newBLEcentralDemo
//
//  Created by Ivan_deng on 2018/12/19.
//  Copyright © 2018 Ivan_deng. All rights reserved.
//

#import "PeripheralTableViewCell.h"

// View
#import <Masonry/Masonry.h>

// helper
#import <CoreBluetooth/CoreBluetooth.h>

@interface PeripheralTableViewCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;

@end

@implementation PeripheralTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
    self.accessoryType = UITableViewCellAccessoryDetailButton;
  }
  return self;
}

- (UILabel *)titleLabel {
  if (!_titleLabel) {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
  }
  return _titleLabel;
}

- (UILabel *)subtitleLabel {
  if (!_subtitleLabel) {
    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _subtitleLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    _subtitleLabel.textColor = [UIColor lightGrayColor];
  }
  return _subtitleLabel;
}

- (void)setPeripheral:(CBPeripheral *)peripheral {
  if (_peripheral != peripheral) {
    _peripheral = peripheral;
    self.titleLabel.text = peripheral.name ? peripheral.name : localizedString(@"MainViewController.tableView.cell.title.default");
    self.subtitleLabel.text = peripheral.identifier.UUIDString;
  }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(@10);
    make.left.equalTo(@10);
  }];
  [self.subtitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
    make.left.equalTo(self.titleLabel.mas_left);
  }];
}

+ (CGFloat)rowHeight {
  return 60;
}

@end
