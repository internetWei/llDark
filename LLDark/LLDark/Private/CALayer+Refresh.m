//
//  CALayer+Refresh.m
//  LLDark
//
//  Created by LL on 2020/11/19.
//

#import "CALayer+Refresh.h"

#import "CALayer+Dark.h"
#import "UIColor+Dark.h"
#import "UIImage+Dark.h"
#import "CATextLayer+Dark.h"
#import "CAShapeLayer+Dark.h"
#import "CAGradientLayer+Dark.h"
#import "NSMutableAttributedString+Refresh.h"
#import "LLDarkManager.h"
#import "NSObject+Dark.h"

@implementation CALayer (Refresh)

- (BOOL)isNeedRefresh {
    return (self.isDarkMode != LLDarkManager.isDarkMode);
}

- (void)refresh {
    if (![self isNeedRefresh]) return;
    
    [self refreshSingleLayer];
    for (CALayer *layer in self.sublayers) {
        if (![layer isNeedRefresh]) continue;
        [layer refresh];
    }
}

- (void)refresh:(LLUserInterfaceStyle)userInterfaceStyle {
    self.userInterfaceStyle = userInterfaceStyle;
    
    BOOL isNeedRefresh = YES;
    if (userInterfaceStyle == LLUserInterfaceStyleDark &&
        self.isDarkMode == YES) {
        isNeedRefresh = NO;
    }
    if (userInterfaceStyle == LLUserInterfaceStyleLight &&
        self.isDarkMode == NO) {
        isNeedRefresh = NO;
    }
    
    self.isDarkMode = (self.userInterfaceStyle == LLUserInterfaceStyleDark);
    
    if (isNeedRefresh) {
        [self refreshSingleLayer];
    }
    
    for (CALayer *layer in self.sublayers) {
        [layer refresh:userInterfaceStyle];
    }
}

/// 刷新单个Layer
- (void)refreshSingleLayer {
    if (self.userInterfaceStyle == LLUserInterfaceStyleUnspecified) {    
        self.isDarkMode = LLDarkManager.isDarkMode;
    }
        
    // 刷新通用属性
    UIColor *backgroundColor = self.backgroundThemeColor;
    if (backgroundColor.isTheme) {
        self.backgroundColor = backgroundColor.resolvedCGColor(self.userInterfaceStyle);
    }
    
    UIColor *borderColor = self.borderThemeColor;
    if (borderColor.isTheme) {
        self.borderColor = borderColor.resolvedCGColor(self.userInterfaceStyle);
    }
    
    UIColor *shadowColor = self.shadowThemeColor;
    if (shadowColor.isTheme) {
        self.shadowColor = shadowColor.resolvedCGColor(self.userInterfaceStyle);
    }
    
    UIImage *image = self.contentImage;
    if (image.isTheme) {
        self.contents = image.resolvedImage(self.userInterfaceStyle);
    }
    
    if ([self isKindOfClass:CATextLayer.class]) {
        CATextLayer *t_textLayer = (CATextLayer *)self;
        
        UIColor *foregroundColor = t_textLayer.foregoundThemeColor;
        if (foregroundColor.isTheme) {
            t_textLayer.foregroundColor = foregroundColor.resolvedCGColor(self.userInterfaceStyle);
        }
        
        if ([t_textLayer.string isKindOfClass:NSAttributedString.class]) {
            NSMutableAttributedString *t_attr = [t_textLayer.string mutableCopy];
            [t_attr refreshAttributes:self.userInterfaceStyle];
            t_textLayer.string = t_attr;
        }
        
        return;
    }
    
    if ([self isKindOfClass:CAShapeLayer.class]) {
        CAShapeLayer *t_shapeLayer = (CAShapeLayer *)self;
        
        UIColor *fillColor = t_shapeLayer.fillThemeColor;
        if (fillColor.isTheme) {
            t_shapeLayer.fillColor = fillColor.resolvedCGColor(self.userInterfaceStyle);
        }
        
        UIColor *strokeColor = t_shapeLayer.strokeThemeColor;
        if (strokeColor.isTheme) {
            t_shapeLayer.strokeColor = strokeColor.resolvedCGColor(self.userInterfaceStyle);
        }
        return;
    }
    
    if ([self isKindOfClass:CAGradientLayer.class]) {
        CAGradientLayer *t_gradientLayer = (CAGradientLayer *)self;
        
        NSArray *colors = t_gradientLayer.themeColors;
        [self.singletonArray removeAllObjects];
        for (id obj in colors) {
            if ([obj isKindOfClass:UIColor.class]) {
                if ([obj isTheme]) {
                    UIColor *color = (UIColor *)obj;
                    color = color.resolvedColor(self.userInterfaceStyle);
                    [self.singletonArray addObject:color];
                    continue;
                }
            }
            [self.singletonArray addObject:obj];
        }
        t_gradientLayer.colors = self.singletonArray;
        return;
    }
}

- (NSMutableArray *)singletonArray {
    static NSMutableArray *mutableArray = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mutableArray = [NSMutableArray array];
    });
    return mutableArray;
}

@end
