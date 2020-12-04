//
//  CAShapeLayer+Dark.m
//  LLDark
//
//  Created by LL on 2020/11/19.
//

#import "CAShapeLayer+Dark.h"

#import <objc/runtime.h>

#import "UIColor+Dark.h"

static char * const ll_fillThemeColor_identifier = "ll_fillThemeColor_identifier";
static char * const ll_strokeThemeColor_identifier = "ll_strokeThemeColor_identifier";

@implementation CAShapeLayer (Dark)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setFillColor:)), class_getInstanceMethod(self, @selector(setFillThemeColor:)));
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setStrokeColor:)), class_getInstanceMethod(self, @selector(setStrokeThemeColor:)));
}

- (void)setFillThemeColor:(id)fillThemeColor {
    if ([fillThemeColor isKindOfClass:UIColor.class]) {
        [self setFillThemeColor:(id)[fillThemeColor CGColor]];
        if ([fillThemeColor isTheme]) {
            objc_setAssociatedObject(self, &ll_fillThemeColor_identifier, fillThemeColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    } else {
        [self setFillThemeColor:fillThemeColor];
    }
}

- (UIColor *)fillThemeColor {
    return objc_getAssociatedObject(self, &ll_fillThemeColor_identifier);
}

- (void)setStrokeThemeColor:(id)strokeThemeColor {
    if ([strokeThemeColor isKindOfClass:UIColor.class]) {
        [self setStrokeThemeColor:(id)[strokeThemeColor CGColor]];
        if ([strokeThemeColor isTheme]) {
            objc_setAssociatedObject(self, &ll_strokeThemeColor_identifier, strokeThemeColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    } else {
        [self setStrokeThemeColor:strokeThemeColor];
    }
}

- (UIColor *)strokeThemeColor {
    return objc_getAssociatedObject(self, &ll_strokeThemeColor_identifier);
}

@end
