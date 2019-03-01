//
//  DeviceScreenAdaptor.h
//  ScreenAdapterDemo
//
//  Created by LeonDeng on 2019/1/25.
//  Copyright © 2019 LeonDeng. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define DSAdaptedValue(standardValue) (adaptedValue(standardValue))
#define DSStatusBarMargin (statusBarMargin())
#define DSBottomMargin (bottomMargin())

typedef NS_ENUM(NSInteger, DeviceScreenType) {
    /// 未知屏幕尺寸
    DeviceScreenTypeUnknown,
    
    /// 4s, 4, 3GS, 3G, 1, iPod Touch 4
    DeviceScreenType3_5,
    
    /// SE, 5s, 5c, 5, iPod Touch 5~6
    DeviceScreenType4_0,
    
    /// 6s, 6, 7, 8
    DeviceScreenType4_7,
    
    /// 6s Plus, 6 Plus, 7Plus, 8Plus
    DeviceScreenType5_5,
    
    /// X
    DeviceScreenType5_8,
    
    /// XR
    DeviceScreenType6_1,
    
    /// Xs max
    DeviceScreenType6_5,
    /// iPad Mini 2~4
    /// 它的分辨率与 iPad 一致, 可以忽略.
    //  IBLVersionDeviceSize7_9,
    
    /// iPad Pro, iPad Air 2, iPad Air, iPad 4, iPad 3
    DeviceScreenType9_7,
    
    DeviceScreenType10_5,
    
    /// iPad Pro
    DeviceScreenType11,
    
    /// iPad Pro
    DeviceScreenType12_9
};

typedef NS_ENUM(NSInteger,DeviceType) {
    
    Unknown = 0,
    Simulator = 1,
    IPhone_1G = 2,          //基本不用
    IPhone_3G = 3,          //基本不用
    IPhone_3GS = 4,         //基本不用
    IPhone_4 = 5,           //基本不用
    IPhone_4S = 6,          //基本不用
    IPhone_5 = 7,
    IPhone_5C = 8,
    IPhone_5S = 9,
    IPhone_SE = 10,
    IPhone_6 = 11,
    IPhone_6P = 12,
    IPhone_6S = 13,
    IPhone_6S_P = 14,
    IPhone_7 = 15,
    IPhone_7P = 16,
    IPhone_8 = 17,
    IPhone_8P = 18,
    IPhone_X = 19,
    IPhone_XS = 20,
    IPhone_XSMax = 21,
    IPhone_XR = 22,
};


@interface DeviceScreenAdaptor : NSObject

@property (nonatomic, assign, readonly) DeviceType deviceType;
@property (nonatomic, copy, readonly) NSString *deviceTypeString;
@property (nonatomic, assign, readonly) DeviceScreenType screenType;
@property (nonatomic, assign, readonly) BOOL isLandscape;
@property (nonatomic, assign, readonly) CGFloat statusBarMagin;
@property (nonatomic, assign, readonly) CGFloat bottomIndicatorMargin;

/**
 get singleton instance

 @return the shared screen adaptor
 */
+ (DeviceScreenAdaptor *)sharedAdaptor;


/**
 transfer the UI value to adapt other screen

 @param standardValue the value you used when coding with your develop iOS device.
 @return the transfered value when running in other screen type devices.
 */
+ (CGFloat)adaptedValue:(CGFloat)standardValue;


/**
 simply tell you wether the screen is in landscape.

 @return the screen is currently landscape or not
 */
+ (BOOL)isLandscape;


/**
 the screen type of current device

 @return predefined screen type enum
 */
+ (DeviceScreenType)screenType;


/**
 the type of the  current device

 @return predefined device type enum
 */
+ (DeviceType)deviceType;


/**
 the device type in string class

 @return device type string
 */
+ (NSString *)deviceTypeString;


/**
 return the height of statusBar, NAVIGATIONBAR HEIGHT NOT INCLUDED

 @return status bar height
 */
+ (CGFloat)statusBarMargin;


/**
 return the height of bottom indicator

 @return bottom indocator
 */
+ (CGFloat)bottomIndicatorMargin;


/**
 Set the screen type you are using when developing
 */
- (void)setDeveloperScreenType:(DeviceScreenType)type;

@end

CG_INLINE CGFloat adaptedValue(CGFloat standardValue) {
    return [DeviceScreenAdaptor adaptedValue:standardValue];
}

CG_INLINE CGFloat statusBarMargin() {
    return [DeviceScreenAdaptor statusBarMargin];
}

CG_INLINE CGFloat bottomMargin() {
    return [DeviceScreenAdaptor bottomIndicatorMargin];
}

NS_ASSUME_NONNULL_END
