//
//  PeripherialViewController.m
//  newBLEcentralDemo
//
//  Created by Ivan_deng on 2018/12/17.
//  Copyright © 2018 Ivan_deng. All rights reserved.
//

#import "PeripherialViewController.h"

@interface PeripherialViewController()

@property (nonatomic, strong) CBPeripheral *perpherial;

@end

@implementation PeripherialViewController

- (instancetype)initWithPerpherial:(CBPeripheral *)perpherial {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _perpherial = perpherial;
  }
  return self;
}

@end
