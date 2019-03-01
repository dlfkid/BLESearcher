//
//  UIImage+UIExtensionKit.m
//  UIColorExtensionDemo
//
//  Created by LeonDeng on 2019/2/1.
//  Copyright © 2019 LeonDeng. All rights reserved.
//

#import "UIImage+UIExtensionKit.h"

@implementation UIImage (UIExtensionKit)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)imageWithView:(UIView *)view Translucent:(BOOL)translucent {
    CGSize size = view.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(size, !translucent, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)subFittedImageFromImage:(UIImage *)image {
    CGSize imgSize =image.size;
    float minwidthFloat = imgSize.width;
    float minheightFloat = imgSize.height;
    UIImage* smallImage = image;
    if (minwidthFloat > [UIScreen mainScreen].bounds.size.width) {//320你自定义大小，想要弄多大，就弄多大
        minwidthFloat = [UIScreen mainScreen].bounds.size.width;
        minheightFloat = imgSize.height * minwidthFloat / imgSize.width;
        if (minheightFloat>[UIScreen mainScreen].bounds.size.height) {
            minheightFloat = [UIScreen mainScreen].bounds.size.width;
            minwidthFloat = imgSize.width*minheightFloat/imgSize.height;
        }
    }else{
        return smallImage;
    }
    smallImage = [self imageScaledFromImage:image Size:CGSizeMake(minwidthFloat, minheightFloat)];
    return smallImage;
}

+ (UIImage *)imageScaledFromImage:(UIImage *)image Size:(CGSize)size {
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

+ (UIImage *)drawColorInImage:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    //  [[UIColor colorWithRed:222./255 green:227./255 blue: 229./255 alpha:1] CGColor]) ;
    CGContextFillRect(context, rect);
    UIImage * imge;// = [[UIImage alloc] init];
    imge = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imge;
}

@end
