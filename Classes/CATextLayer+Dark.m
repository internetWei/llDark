//
//  CATextLayer+Dark.m
//  LLDark
//
//  Created by LL on 2020/11/19.
//

#import "CATextLayer+Dark.h"

#import <objc/runtime.h>

#import "UIColor+Dark.h"

static char * const ll_foregroundThemeColor_identifier = "ll_foregroundThemeColor_identifier";

@implementation CATextLayer (Dark)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setForegroundColor:)), class_getInstanceMethod(self, @selector(setForegoundThemeColor:)));
}

- (void)setForegoundThemeColor:(id)foregoundThemeColor {
    if ([foregoundThemeColor isKindOfClass:UIColor.class]) {
        [self setForegoundThemeColor:(id)[foregoundThemeColor CGColor]];
        if ([foregoundThemeColor isTheme]) {
            objc_setAssociatedObject(self, &ll_foregroundThemeColor_identifier, foregoundThemeColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    } else {
        [self setForegoundThemeColor:foregoundThemeColor];
    }
}

- (UIColor *)foregoundThemeColor {
    return objc_getAssociatedObject(self, &ll_foregroundThemeColor_identifier);
}

@end
