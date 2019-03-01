#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSString+UIKitExtension.h"
#import "UIColor+UIExtensionKit.h"
#import "UIImage+UIExtensionKit.h"

FOUNDATION_EXPORT double UIExtensionKitVersionNumber;
FOUNDATION_EXPORT const unsigned char UIExtensionKitVersionString[];

