//
//  UIView+Dark.m
//  LLDark <https://github.com/internetWei/llDark>
//
//  Created by LL on 2020/11/17.
//

#import "UIView+Dark.h"

#import <objc/runtime.h>

#import "LLDarkManager.h"
#import "UIView+Refresh.h"
#import "NSObject+Dark.h"

@implementation UIView (Dark)

+ (void)load {
    // 交换backgroundColor的set和get方法(因为backgroundColor有copy属性，导致每次赋值地址都发生改变)。
    self.methodExchange(@selector(setBackgroundColor:), @selector(setLl_backgroundColor:));
    
    self.methodExchange(@selector(backgroundColor), @selector(ll_backgroundColor));
    self.methodExchange(@selector(didMoveToWindow), @selector(ll_didMoveToWindow));
    
    self.methodExchange(@selector(initWithFrame:), @selector(ll_initWithFrame:));
    self.methodExchange(@selector(initWithCoder:), @selector(ll_initWithCoder:));
    self.methodExchange(@selector(layoutSubviews), @selector(ll_layoutSubviews));
}

- (instancetype)ll_initWithFrame:(CGRect)rect {
    self.isDarkMode = LLDarkManager.isDarkMode;
    return [self ll_initWithFrame:rect];
}

- (instancetype)ll_initWithCoder:(NSCoder *)coder {
    self.isDarkMode = LLDarkManager.isDarkMode;
    return [self ll_initWithCoder:coder];
}

- (void)ll_didMoveToWindow {
    [self ll_didMoveToWindow];
    [self refresh];
}

- (void)ll_layoutSubviews {
    [self ll_layoutSubviews];
    [self forceRefresh];
}

- (void)forceRefresh {
    if (self.userInterfaceStyle != LLUserInterfaceStyleUnspecified) {
        [self forceRefreshView];
    }
}

- (void)forceRefreshView {
    [self refresh:self.userInterfaceStyle];
}

- (void)setLl_backgroundColor:(UIColor *)ll_backgroundColor {
    [self setLl_backgroundColor:ll_backgroundColor];
    objc_setAssociatedObject(self, @selector(ll_backgroundColor), ll_backgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)ll_backgroundColor {
    return objc_getAssociatedObject(self, @selector(ll_backgroundColor));
}

- (void)setIsDarkMode:(BOOL)isDarkMode {
    objc_setAssociatedObject(self, @selector(isDarkMode), @(isDarkMode), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isDarkMode {
    return [objc_getAssociatedObject(self, @selector(isDarkMode)) boolValue];
}

- (void)setAppearanceBindUpdater:(void (^)(id _Nonnull))appearanceBindUpdater {
    objc_setAssociatedObject(self, @selector(appearanceBindUpdater), appearanceBindUpdater, OBJC_ASSOCIATION_COPY_NONATOMIC);
    !appearanceBindUpdater ?: appearanceBindUpdater(self);
}

- (void (^)(id _Nonnull))appearanceBindUpdater {
    return objc_getAssociatedObject(self, @selector(appearanceBindUpdater));
}

@end
