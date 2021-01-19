//
//  CALayer+Dark.m
//  LLDark <https://github.com/internetWei/llDark>
//
//  Created by LL on 2020/11/19.
//

#import "CALayer+Dark.h"

#import <objc/runtime.h>

#import "UIColor+Dark.h"
#import "UIImage+Dark.h"
#import "LLDarkManager.h"

static char * const ll_borderThemeColor_identifier = "ll_borderThemeColor_identifier";
static char * const ll_backgroundThemeColor_identifier = "ll_backgroundThemeColor_identifier";
static char * const ll_shadowThemeColor_identifier = "ll_shadowThemeColor_identifier";
static char * const ll_contentThemeImage_identifier = "ll_contentThemeImage_identifier";
static char * const ll_layerDarkMode_identifier = "ll_layerDarkMode_identifier";

@implementation CALayer (Dark)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setBackgroundColor:)), class_getInstanceMethod(self, @selector(setBackgroundThemeColor:)));
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setBorderColor:)), class_getInstanceMethod(self, @selector(setBorderThemeColor:)));
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setShadowColor:)), class_getInstanceMethod(self, @selector(setShadowThemeColor:)));
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setContents:)), class_getInstanceMethod(self, @selector(setContentImage:)));
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(init)), class_getInstanceMethod(self, @selector(ll_init)));
}

#pragma mark - setter/getter
- (instancetype)ll_init {
    self.isDarkMode = LLDarkManager.isDarkMode;
    return [self ll_init];
}

- (void)setIsDarkMode:(BOOL)isDarkMode {
    objc_setAssociatedObject(self, &ll_layerDarkMode_identifier, @(isDarkMode), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isDarkMode {
    return [objc_getAssociatedObject(self, &ll_layerDarkMode_identifier) boolValue];
}

- (void)setBackgroundThemeColor:(id)backgroundThemeColor {
    if ([backgroundThemeColor isKindOfClass:UIColor.class]) {
        [self setBackgroundThemeColor:(id)[backgroundThemeColor CGColor]];
        if ([backgroundThemeColor isTheme]) {
            objc_setAssociatedObject(self, &ll_backgroundThemeColor_identifier, backgroundThemeColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    } else {
        [self setBackgroundThemeColor:backgroundThemeColor];
    }
}

- (UIColor *)backgroundThemeColor {
    return objc_getAssociatedObject(self, &ll_backgroundThemeColor_identifier);
}

- (void)setBorderThemeColor:(id)borderThemeColor {
    if ([borderThemeColor isKindOfClass:UIColor.class]) {
        [self setBorderThemeColor:(id)[borderThemeColor CGColor]];
        if ([borderThemeColor isTheme]) {
            objc_setAssociatedObject(self, &ll_borderThemeColor_identifier, borderThemeColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    } else {
        [self setBorderThemeColor:borderThemeColor];
    }
}

- (UIColor *)borderThemeColor {
    return objc_getAssociatedObject(self, &ll_borderThemeColor_identifier);
}

- (void)setShadowThemeColor:(UIColor *)shadowThemeColor {
    if ([shadowThemeColor isKindOfClass:UIColor.class]) {
        [self setShadowThemeColor:(id)[shadowThemeColor CGColor]];
        if ([shadowThemeColor isTheme]) {
            objc_setAssociatedObject(self, &ll_shadowThemeColor_identifier, shadowThemeColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    } else {
        [self setShadowThemeColor:shadowThemeColor];
    }
}

- (UIColor *)shadowThemeColor {
    return objc_getAssociatedObject(self, &ll_shadowThemeColor_identifier);
}

- (void)setContentImage:(id)contentImage {
    if ([contentImage isKindOfClass:UIImage.class]) {
        UIImage *image = (UIImage *)contentImage;
        [self setContentImage:(id)image.CGImage];
        if (image.isTheme) {
            objc_setAssociatedObject(self, &ll_contentThemeImage_identifier, contentImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    } else {
        [self setContentImage:contentImage];
    }
}

- (UIImage *)contentImage {
    return objc_getAssociatedObject(self, &ll_contentThemeImage_identifier);
}

@end
