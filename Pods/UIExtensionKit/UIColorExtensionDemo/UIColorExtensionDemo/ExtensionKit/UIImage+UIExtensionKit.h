//
//  UIImage+UIExtensionKit.h
//  UIColorExtensionDemo
//
//  Created by LeonDeng on 2019/2/1.
//  Copyright © 2019 LeonDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (UIExtensionKit)

/**
 Convert UIColor to UIImage
 
 @param color Color to transfer
 @return UImage
 */
+(UIImage*)imageWithColor:(UIColor*) color;

/**
 Convert UIView to UIImage
 
 @param view view to convert
 @return image from view
 */
+(UIImage*)imageWithView:(UIView*)view Translucent:(BOOL)translucent;

/**
 Return sub image from given image to adapt device's screen
 
 @param image resouce image
 @return subImage
 */
+(UIImage *)subFittedImageFromImage:(UIImage *)image;

/**
 Filled given image with color
 
 @param color which color you choosed to draw in picture
 @return UIImage
 */
+(UIImage *)drawColorInImage:(UIColor *)color;

/**
 Rescale images
 
 @param image original image
 @param size size you wanna scale to
 @return scaledImage
 */
+ (UIImage *)imageScaledFromImage:(UIImage *)image Size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
