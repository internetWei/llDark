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
#import "NSObject+Dark.h"

@implementation CALayer (Dark)

+ (void)load {
    self.methodExchange(@selector(setBackgroundColor:), @selector(setBackgroundThemeColor:));
    self.methodExchange(@selector(setBorderColor:), @selector(setBorderThemeColor:));
    self.methodExchange(@selector(setShadowColor:), @selector(setShadowThemeColor:));
    self.methodExchange(@selector(setContents:), @selector(setContentImage:));
    self.methodExchange(@selector(init), @selector(llDark_init));
}

#pragma mark - setter/getter
- (instancetype)llDark_init {
    self.isDarkMode = LLDarkManager.isDarkMode;
    return [self llDark_init];
}

- (void)setIsDarkMode:(BOOL)isDarkMode {
    objc_setAssociatedObject(self, @selector(isDarkMode), @(isDarkMode), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isDarkMode {
    return [objc_getAssociatedObject(self, @selector(isDarkMode)) boolValue];
}

- (void)setBackgroundThemeColor:(id)backgroundThemeColor {
    if ([backgroundThemeColor isKindOfClass:UIColor.class]) {
        [self setBackgroundThemeColor:(id)[backgroundThemeColor CGColor]];
        if ([backgroundThemeColor isTheme]) {
            objc_setAssociatedObject(self, @selector(backgroundThemeColor), backgroundThemeColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    } else {
        [self setBackgroundThemeColor:backgroundThemeColor];
    }
}

- (UIColor *)backgroundThemeColor {
    return objc_getAssociatedObject(self, @selector(backgroundThemeColor));
}

- (void)setBorderThemeColor:(id)borderThemeColor {
    if ([borderThemeColor isKindOfClass:UIColor.class]) {
        [self setBorderThemeColor:(id)[borderThemeColor CGColor]];
        if ([borderThemeColor isTheme]) {
            objc_setAssociatedObject(self, @selector(borderThemeColor), borderThemeColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    } else {
        [self setBorderThemeColor:borderThemeColor];
    }
}

- (UIColor *)borderThemeColor {
    return objc_getAssociatedObject(self, @selector(borderThemeColor));
}

- (void)setShadowThemeColor:(UIColor *)shadowThemeColor {
    if ([shadowThemeColor isKindOfClass:UIColor.class]) {
        [self setShadowThemeColor:(id)[shadowThemeColor CGColor]];
        if ([shadowThemeColor isTheme]) {
            objc_setAssociatedObject(self, @selector(shadowThemeColor), shadowThemeColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    } else {
        [self setShadowThemeColor:shadowThemeColor];
    }
}

- (UIColor *)shadowThemeColor {
    return objc_getAssociatedObject(self, @selector(shadowThemeColor));
}

- (void)setContentImage:(id)contentImage {
    if ([contentImage isKindOfClass:UIImage.class]) {
        UIImage *image = (UIImage *)contentImage;
        [self setContentImage:(id)image.CGImage];
        if (image.isTheme) {
            objc_setAssociatedObject(self, @selector(contentImage), contentImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    } else {
        [self setContentImage:contentImage];
    }
}

- (UIImage *)contentImage {
    return objc_getAssociatedObject(self, @selector(contentImage));
}

@end
