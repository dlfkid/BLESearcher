//
//  UIColor+UIExtensionKit.h
//  UIColorExtensionDemo
//
//  Created by LeonDeng on 2019/2/1.
//  Copyright © 2019 LeonDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (UIExtensionKit)


/**
 Get current tint color, if not setted, returns clear color.

 @return UIColor
 */
+ (UIColor *)tintColor;

/**
 Set current color as tint color
 */
- (void)setTintColor;

/**
 Set color as tint color
 @param color The tint color
 */
+ (void)setTintColor:(UIColor *)color;

/**
 Convert UIImage to UIColor
 
 @param pngName name of the Image
 @return UIColor
 */
+(UIColor *)colorWithImageName:(NSString *)pngName;

/**
 Convert hexString color into UIColor
 
 @param hexColor HexString of the color
 @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)hexColor;


/**
 Convert hexString color into UIColor

 @param hexColor HexString of the color
 @param alpha Alpha value of the color
 @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)hexColor Alpha:(CGFloat)alpha;


/**
 Get color with RGB Value

 @param RGBValue RGB value
 @return UIColor
 */
+ (UIColor *)colorWithRGB:(CGFloat)RGBValue;


/**
 Get color with RGB Value

 @param RGBValue RGB value
 @param alpha Alpha value
 @return UIColor
 */
+ (UIColor *)colorWithRGB:(CGFloat)RGBValue Alpha:(CGFloat)alpha;

/**
 Get color with RGB Value

 @param red Red value
 @param green Green value
 @param blue Blue value
 @return UIColor
 */
+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue;


/**
 Get color with RGB Value

 @param red Red value
 @param green Green value
 @param blue Blue value
 @param alpha Alpha value
 @return UIColor
 */
+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue Alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
