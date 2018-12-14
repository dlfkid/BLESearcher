//
//  Constants.h
//  newBLEcentralDemo
//
//  Created by Ivan_deng on 2018/12/14.
//  Copyright © 2018 Ivan_deng. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

typedef NS_ENUM (NSUInteger, APPLanguageType) {
  APPLanguageTypeChinese,
  APPLanguageTypeEnglish,
};

static inline NSString * localizedString(NSString *key) {
  NSString *string = NSLocalizedString(key, nil);
  
  if ([string isEqualToString:key]) {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Localizable" ofType:@"strings" inDirectory:nil forLocalization:@"en"];
    NSBundle *englishBundle = [[NSBundle alloc] initWithPath:[bundlePath stringByDeletingLastPathComponent]];
    
    string = NSLocalizedStringFromTableInBundle(key, nil, englishBundle, nil);
  }
  
  return string;
}

static inline APPLanguageType currentLanuageType {
  NSString *code = localizedString("com.misery.newBLEcentralDemo.language.type");
  return (APPLanguageType)code.integerValue
}

#endif /* Constants_h */
