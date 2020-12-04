//
//  UIImageView+Dark.m
//  LLDark
//
//  Created by LL on 2020/11/19.
//

#import "UIImageView+Dark.h"

#import <objc/runtime.h>

#import "UIImage+Dark.h"
#import "LLDarkManager.h"
#import "UIView+Dark.h"
#import "LLDarkDefine.h"

static char * const ll_dark_theme_style_identifer = "ll_dark_theme_style_identifer";
static char * const ll_dark_theme_value_identifer = "ll_dark_theme_value_identifer";
static char * const ll_dark_theme_identifer = "ll_dark_theme_identifer";
static char * const ll_dark_theme_layer_identifer = "ll_dark_theme_layer_identifer";
static char * const ll_dark_normalImage_identifer = "ll_dark_normalImage_identifer";
static char * const ll_dark_isSpecialImage_identifer = "ll_dark_isSpecialImage_identifer";
static char * const ll_dark_maskFrame_identifer = "ll_dark_maskFrame_identifer";

@interface UIImageView ()

@property (nonatomic) LLDarkStyle darkThemeStyle;

@property (nonatomic) CGFloat themeValue;

@property (nonatomic, strong) NSString *themeIdentifer;

@property (nonatomic, nullable) CALayer *maskThemeLayer;

/// 正常的图片
@property (nonatomic, nullable) UIImage *normalImage;

/// 降低了饱合度的图片
@property (nonatomic, nullable) UIImage *specialImage;

/// YES：是降低了饱合度的图片，NO：是正常图片
@property (nonatomic, assign) BOOL isSpecialImage;

/// 透明蒙层的Frame
@property (nonatomic, assign) CGRect maskFrame;

@end

@implementation UIImageView (Dark)

- (void (^)(LLDarkStyle, CGFloat, NSString * _Nullable))darkStyle {
    return ^(LLDarkStyle style, CGFloat value, NSString *identifier) {
        self.darkThemeStyle = style;
        self.themeValue = value;
        self.themeIdentifer = identifier;
        [self set_darkThemeStyle];
    };
}

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(layoutSubviews)), class_getInstanceMethod(self, @selector(ll_imageViewlayoutSubviews)));
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setImage:)), class_getInstanceMethod(self, @selector(ll_setImage:)));
}

- (void)ll_imageViewlayoutSubviews {
    [self ll_imageViewlayoutSubviews];
    if (self.darkThemeStyle == LLDarkStyleMask) {
        self.maskFrame = [self _maskFrame];
    }
    [self set_darkThemeStyle];
}

- (void)ll_setImage:(UIImage *)image {
    [self ll_setImage:image];
    self.normalImage = image;
    self.isSpecialImage = NO;
    [self set_darkThemeStyle];
}

- (void)refreshImageDarkStyle {
    [self set_darkThemeStyle];
}

- (void)set_darkThemeStyle {
    if (!self.image ||
        CGRectEqualToRect(self.bounds, CGRectZero)) {
        return;
    }
    
    switch (self.darkThemeStyle) {
        case LLDarkStyleMask:
        {
            [self set_darkThemeStyleFromMask];
        }
            break;
        case LLDarkStyleSaturation:
        {
            [self set_darkThemeStyleFromSaturation];
        }
            break;
        default:
            break;
    }
}

/// 设置饱合度
- (void)set_darkThemeStyleFromSaturation {
    self.maskThemeLayer.hidden = YES;
    
    if (self.isSpecialImage != LLDarkManager.isDarkMode) {
        if (LLDarkManager.isDarkMode) {
            self.isSpecialImage = YES;
            [self _specialImage:^(UIImageView *obj, UIImage *specialImage) {
                [obj ll_setImage:specialImage];
            }];
        } else {
            self.isSpecialImage = NO;
            [self ll_setImage:self.normalImage];
        }
    }
}

/// 设置透明蒙层
- (void)set_darkThemeStyleFromMask {
    if (!self.maskThemeLayer) {
        self.maskThemeLayer = [CALayer layer];
        self.maskThemeLayer.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:self.themeValue].CGColor;
        self.maskThemeLayer.zPosition = 10000;
        [self.layer insertSublayer:self.maskThemeLayer atIndex:(unsigned)self.layer.sublayers.count];
    }
    self.maskThemeLayer.frame = self.maskFrame;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.maskThemeLayer.hidden = !LLDarkManager.isDarkMode;
    [CATransaction commit];
}

/// 计算蒙层的Frame
- (CGRect)_maskFrame {
    CGSize imageSize = self.image.size;
    // 图片宽高比
    CGFloat imageScale = imageSize.width / imageSize.height;
    
    CGSize controlSize = self.bounds.size;
    // 控件的宽高比
    CGFloat controlScale = controlSize.width / controlSize.height;
    
    CGFloat x, y, width, height;
    
    // 计算蒙层的Frame
    switch (self.contentMode) {
        case UIViewContentModeScaleAspectFit:
        {
            if (controlScale < imageScale) {
                width = controlSize.width;
                height = controlSize.width * imageSize.height / imageSize.width;
                if (height > controlSize.height) {
                    height = controlSize.height;
                }
                x = 0;
                y = (CGRectGetHeight(self.bounds) - height) / 2.0;

            } else {
                width = controlSize.height * imageSize.width / imageSize.height;
                if (width > controlSize.width) {
                    width = controlSize.width;
                }
                height = controlSize.height;
                x = (CGRectGetWidth(self.bounds) - width) / 2.0;
                y = 0;
            }
        }
            break;
        case UIViewContentModeCenter:
        {
            width = imageSize.width;
            height = imageSize.height;
            if (width > controlSize.width) {
                width = controlSize.width;
            }
            if (height > controlSize.height) {
                height = controlSize.height;
            }
            x = (CGRectGetWidth(self.bounds) - width) / 2.0;
            y = (CGRectGetHeight(self.bounds) - height) / 2.0;
        }
            break;
        case UIViewContentModeTop:
        {
            width = imageSize.width;
            height = imageSize.height;
            if (width > controlSize.width) {
                width = controlSize.width;
            }
            if (height > controlSize.height) {
                height = controlSize.height;
            }
            x = (CGRectGetWidth(self.bounds) - width) / 2.0;
            y = 0;
        }
            break;
        case UIViewContentModeBottom:
        {
            width = imageSize.width;
            height = imageSize.height;
            if (width > controlSize.width) {
                width = controlSize.width;
            }
            if (height > controlSize.height) {
                height = controlSize.height;
            }
            x = (CGRectGetWidth(self.bounds) - width) / 2.0;
            y = CGRectGetHeight(self.bounds) - height;
        }
            break;
        case UIViewContentModeLeft:
        {
            width = imageSize.width;
            height = imageSize.height;
            if (width > controlSize.width) {
                width = controlSize.width;
            }
            if (height > controlSize.height) {
                height = controlSize.height;
            }
            x = 0;
            y = (CGRectGetHeight(self.bounds) - height) / 2.0;
        }
            break;
        case UIViewContentModeRight:
        {
            width = imageSize.width;
            height = imageSize.height;
            if (width > controlSize.width) {
                width = controlSize.width;
            }
            if (height > controlSize.height) {
                height = controlSize.height;
            }
            x = CGRectGetWidth(self.bounds) - width;
            y = (CGRectGetHeight(self.bounds) - height) / 2.0;
        }
            break;
        case UIViewContentModeTopLeft:
        {
            width = imageSize.width;
            height = imageSize.height;
            if (width > controlSize.width) {
                width = controlSize.width;
            }
            if (height > controlSize.height) {
                height = controlSize.height;
            }
            x = 0;
            y = 0;
        }
            break;
        case UIViewContentModeTopRight:
        {
            width = imageSize.width;
            height = imageSize.height;
            if (width > controlSize.width) {
                width = controlSize.width;
            }
            if (height > controlSize.height) {
                height = controlSize.height;
            }
            x = CGRectGetWidth(self.bounds) - width;
            y = 0;
        }
            break;
        case UIViewContentModeBottomLeft:
        {
            width = imageSize.width;
            height = imageSize.height;
            if (width > controlSize.width) {
                width = controlSize.width;
            }
            if (height > controlSize.height) {
                height = controlSize.height;
            }
            x = 0;
            y = CGRectGetHeight(self.bounds) - height;
        }
            break;
        case UIViewContentModeBottomRight:
        {
            width = imageSize.width;
            height = imageSize.height;
            if (width > controlSize.width) {
                width = controlSize.width;
            }
            if (height > controlSize.height) {
                height = controlSize.height;
            }
            x = CGRectGetWidth(self.bounds) - width;
            y = CGRectGetHeight(self.bounds) - height;
        }
            break;

        default:
        {
            x = 0;
            y = 0;
            width = controlSize.width;
            height = controlSize.height;
        }
            break;
    }
    
    return CGRectMake(x, y, width, height);
}

- (void)_specialImage:(void (^) (UIImageView *obj, UIImage *specialImage))complete {
    UIImage *specialImage = self.specialImage;
    if (specialImage) {
        !complete ?: complete(self, specialImage);
    } else {
        __weak typeof(self) weakSelf = self;
        [self.normalImage darkImage:^(UIImage * _Nonnull darkImage) {
            weakSelf.specialImage = darkImage;
            !complete ?: complete(weakSelf, darkImage);
        } saturation:self.themeValue];
    }
}

#pragma mark - setter/getter
- (void)setDarkThemeStyle:(LLDarkStyle)darkThemeStyle {
    objc_setAssociatedObject(self, &ll_dark_theme_style_identifer, @(darkThemeStyle), OBJC_ASSOCIATION_ASSIGN);
}

- (LLDarkStyle)darkThemeStyle {
    return [objc_getAssociatedObject(self, &ll_dark_theme_style_identifer) integerValue];
}

- (void)setThemeValue:(CGFloat)themeValue {
    objc_setAssociatedObject(self, &ll_dark_theme_value_identifer, [NSNumber numberWithFloat:themeValue], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)themeValue {
    return [objc_getAssociatedObject(self, &ll_dark_theme_value_identifer) floatValue];
}

- (void)setThemeIdentifer:(NSString *)themeIdentifer {
    objc_setAssociatedObject(self, &ll_dark_theme_identifer, themeIdentifer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)themeIdentifer {
    return objc_getAssociatedObject(self, &ll_dark_theme_identifer);
}

- (void)setMaskThemeLayer:(CALayer *)maskThemeLayer {
    objc_setAssociatedObject(self, &ll_dark_theme_layer_identifer, maskThemeLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CALayer *)maskThemeLayer {
    return objc_getAssociatedObject(self, &ll_dark_theme_layer_identifer);
}

- (void)setNormalImage:(UIImage *)normalImage {
    objc_setAssociatedObject(self, &ll_dark_normalImage_identifer, normalImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)normalImage {
    return objc_getAssociatedObject(self, &ll_dark_normalImage_identifer);
}

- (void)setSpecialImage:(UIImage *)specialImage {
    [imageCache() setObject:specialImage forKey:self.themeIdentifer cost:imageCost(specialImage)];
}

- (UIImage *)specialImage {
    return [imageCache() objectForKey:self.themeIdentifer];
}

- (void)setIsSpecialImage:(BOOL)isSpecialImage {
    objc_setAssociatedObject(self, &ll_dark_isSpecialImage_identifer, @(isSpecialImage), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isSpecialImage {
    return [objc_getAssociatedObject(self, &ll_dark_isSpecialImage_identifer) boolValue];
}

- (void)setMaskFrame:(CGRect)maskFrame {
    objc_setAssociatedObject(self, &ll_dark_maskFrame_identifer, @(maskFrame), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)maskFrame {
    return [objc_getAssociatedObject(self, &ll_dark_maskFrame_identifer) CGRectValue];
}

@end
