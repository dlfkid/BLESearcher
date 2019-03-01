//
//  UIColor+UIExtensionKit.m
//  UIColorExtensionDemo
//
//  Created by LeonDeng on 2019/2/1.
//  Copyright © 2019 LeonDeng. All rights reserved.
//

#import "UIColor+UIExtensionKit.h"

static UIColor *tintColor = nil;

@implementation UIColor (UIExtensionKit)

+ (UIColor *)tintColor {
    if (!tintColor) {
        return [UIColor clearColor];
    } else {
        return tintColor;
    }
}

- (void)setTintColor {
    tintColor = self;
}

+ (void)setTintColor:(UIColor *)color {
    tintColor = color;
}

+ (UIColor *)colorWithImageName:(NSString *)pngName {
    return [self colorWithPatternImage:[UIImage imageNamed:pngName]];
}

+ (UIColor *)colorWithHexString:(NSString *)hexColor {
    return [self colorWithHexString:hexColor Alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)hexColor Alpha:(CGFloat)alpha {
    NSString *cString = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}

+ (UIColor *)colorWithRGB:(CGFloat)RGBValue {
    return [self colorWithRGB:RGBValue Alpha:1.0f];
}

+ (UIColor *)colorWithRGB:(CGFloat)RGBValue Alpha:(CGFloat)alpha {
    return [self colorWithR:RGBValue G:RGBValue B:RGBValue Alpha:alpha];
}

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue {
    return [self colorWithR:red G:green B:blue Alpha:1.0f];
}

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue Alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((float) red / 255.0f) green:((float) green / 255.0f) blue:((float) blue / 255.0f) alpha:alpha];
}

@end
