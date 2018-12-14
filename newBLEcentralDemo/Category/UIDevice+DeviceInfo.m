//
//  UIDevice+DeviceInfo.m
//  newBLEcentralDemo
//
//  Created by Ivan_deng on 2018/12/14.
//  Copyright © 2018 Ivan_deng. All rights reserved.
//

#import "UIDevice+DeviceInfo.h"

@implementation UIDevice (DeviceInfo)

+ (DeviceScreenType)currentScreenType {
  CGFloat nativeHeight = [UIScreen mainScreen].nativeBounds.size.height;
  DeviceScreenType screenType;
  if (nativeHeight == 960) {
    screenType = DeviceScreenTypeiPhone4;
  } else if (nativeHeight == 1136) {
    screenType = DeviceScreenTypeiPhone5;
  } else if (nativeHeight == 1334) {
    screenType = DeviceScreenTypeiPhone6;
  } else if (nativeHeight == 1920) {
    screenType = DeviceScreenTypeiPhone6Plus;
  } else if (nativeHeight == 2436) {
    screenType = DeviceScreenTypeiPhoneX;
  } else if (nativeHeight == 2688) {
    screenType = DeviceScreenTypeiPhoneXsMax;
  } else if (nativeHeight == 1792) {
    screenType = DeviceScreenTypeiPhoneXR;
  } else {
    // 未知屏幕类型用6作为默认
    screenType = DeviceScreenTypeiPhone6;
  }
  return screenType;
}

+ (CGFloat)bottomIndicatior {
  DeviceScreenType type = [[self class] currentScreenType];
  switch (type) {
    case DeviceScreenTypeiPhone4:
    case DeviceScreenTypeiPhone5:
    case DeviceScreenTypeiPhone6:
    case DeviceScreenTypeiPhone6Plus:
      return 0;
      break;
    
    case DeviceScreenTypeiPhoneX:
    case DeviceScreenTypeiPhoneXR:
    case DeviceScreenTypeiPhoneXsMax:
      return 34;
      break;
      
    default:
      return 0;
      break;
  }
}

+ (CGFloat)statusBarHeight {
  DeviceScreenType type = [[self class] currentScreenType];
  switch (type) {
    case DeviceScreenTypeiPhone4:
    case DeviceScreenTypeiPhone5:
    case DeviceScreenTypeiPhone6:
    case DeviceScreenTypeiPhone6Plus:
      return 20;
      break;
      
    case DeviceScreenTypeiPhoneX:
    case DeviceScreenTypeiPhoneXR:
    case DeviceScreenTypeiPhoneXsMax:
      return 44;
      break;
      
    default:
      return 20;
      break;
  }
}

+ (CGFloat)navigationBarAndStatusBarHeight {
  return [[self class] statusBarHeight] + 44;
}

@end
