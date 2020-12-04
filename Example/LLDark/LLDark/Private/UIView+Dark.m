//
//  UIView+Dark.m
//  LLDark
//
//  Created by LL on 2020/11/17.
//

#import "UIView+Dark.h"

#import <objc/runtime.h>

#import "LLDarkManager.h"
#import "UIView+Refresh.h"
#import "NSObject+Dark.h"

static char * const ll_appearanceBindUpdater_identifer = "ll_appearanceBindUpdater_identifer";
static char * const ll_backgroundColor_identifier = "ll_backgroundColor_identifier";
static char * const ll_view_darkMode_identifier = "ll_view_darkMode_identifier";

@interface UIView ()

@property (nonatomic, strong) UIColor *ll_backgroundColor;

@end

@implementation UIView (Dark)

+ (void)load {
    // 交换backgroundColor的set和get方法(因为backgroundColor有copy属性，导致每次赋值地址都发生改变)。
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setBackgroundColor:)), class_getInstanceMethod(self, @selector(setLl_backgroundColor:)));
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(backgroundColor)), class_getInstanceMethod(self, @selector(ll_backgroundColor)));

    // 交换didMoveToWindow方法，以实现在视图即将显示时刷新UI。
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(didMoveToWindow)), class_getInstanceMethod(self, @selector(ll_didMoveToWindow)));
    
    // 交换初始化方法，以实现在视图创建时记录View的主题模式。
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(initWithFrame:)), class_getInstanceMethod(self, @selector(ll_initWithFrame:)));
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(initWithCoder:)), class_getInstanceMethod(self, @selector(ll_initWithCoder:)));
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(layoutSubviews)), class_getInstanceMethod(self, @selector(ll_layoutSubviews)));
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
    objc_setAssociatedObject(self, &ll_backgroundColor_identifier, ll_backgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)ll_backgroundColor {
    return objc_getAssociatedObject(self, &ll_backgroundColor_identifier);
}

- (void)setIsDarkMode:(BOOL)isDarkMode {
    objc_setAssociatedObject(self, &ll_view_darkMode_identifier, @(isDarkMode), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isDarkMode {
    return [objc_getAssociatedObject(self, &ll_view_darkMode_identifier) boolValue];
}

- (void)setAppearanceBindUpdater:(void (^)(id _Nonnull))appearanceBindUpdater {
    objc_setAssociatedObject(self, &ll_appearanceBindUpdater_identifer, appearanceBindUpdater, OBJC_ASSOCIATION_COPY_NONATOMIC);
    !appearanceBindUpdater ?: appearanceBindUpdater(self);
}

- (void (^)(id _Nonnull))appearanceBindUpdater {
    return objc_getAssociatedObject(self, &ll_appearanceBindUpdater_identifer);
}

@end
