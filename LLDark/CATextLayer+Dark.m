//
//  CATextLayer+Dark.m
//  LLDark <https://github.com/internetWei/llDark>
//
//  Created by LL on 2020/11/19.
//

#import "CATextLayer+Dark.h"

#import <objc/runtime.h>

#import "UIColor+Dark.h"
#import "NSObject+Dark.h"

@implementation CATextLayer (Dark)

+ (void)load {
    self.methodExchange(@selector(setForegroundColor:), @selector(setForegroundThemeColor:));
}

- (void)setForegroundThemeColor:(id)foregroundThemeColor {
    if ([foregroundThemeColor isKindOfClass:UIColor.class]) {
        [self setForegroundThemeColor:(id)[foregroundThemeColor CGColor]];
        if ([foregroundThemeColor isTheme]) {
            objc_setAssociatedObject(self, @selector(foregroundThemeColor), foregroundThemeColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    } else {
        [self setForegroundThemeColor:foregroundThemeColor];
    }
}

- (UIColor *)foregroundThemeColor {
    return objc_getAssociatedObject(self, @selector(foregroundThemeColor));
}

@end
