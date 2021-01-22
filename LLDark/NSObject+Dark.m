//
//  NSObject+Dark.m
//  LLDark <https://github.com/internetWei/llDark>
//
//  Created by LL on 2020/11/17.
//

#import "NSObject+Dark.h"

#import <objc/runtime.h>

@implementation NSObject (Dark)

- (void)setThemeDidChange:(void (^)(id))themeDidChange {
    objc_setAssociatedObject(self, @selector(themeDidChange), themeDidChange, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (themeDidChange) {
        [NSObject.themeTables addObject:self];
    } else {
        [NSObject.themeTables removeObject:self];
    }
}

- (void (^)(id))themeDidChange {
    return objc_getAssociatedObject(self, @selector(themeDidChange));
}

- (void)setSystemThemeDidChange:(void (^)(id))systemThemeDidChange {
    objc_setAssociatedObject(self, @selector(systemThemeDidChange), systemThemeDidChange, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (systemThemeDidChange) {
        [NSObject.systemThemeTables addObject:self];
    } else {
        [NSObject.systemThemeTables removeObject:self];
    }
}

- (void (^)(id))systemThemeDidChange {
    return objc_getAssociatedObject(self, @selector(systemThemeDidChange));
}

- (void)setUserInterfaceStyle:(LLUserInterfaceStyle)userInterfaceStyle {
    objc_setAssociatedObject(self, @selector(userInterfaceStyle), @(userInterfaceStyle), OBJC_ASSOCIATION_ASSIGN);
}

- (LLUserInterfaceStyle)userInterfaceStyle {
    return [objc_getAssociatedObject(self, @selector(userInterfaceStyle)) integerValue];
}

static NSHashTable *_themeTables;
+ (NSHashTable *)themeTables {
    if (!_themeTables) {
        _themeTables = [NSHashTable weakObjectsHashTable];
    }
    return _themeTables;
}

static NSHashTable *_systemThemeTables;
+ (NSHashTable *)systemThemeTables {
    if (!_systemThemeTables) {
        _systemThemeTables = [NSHashTable weakObjectsHashTable];
    }
    return _systemThemeTables;
}

+ (void (^)(SEL _Nonnull, SEL _Nonnull))methodExchange {
    return ^(SEL sel1, SEL sel2) {
        method_exchangeImplementations(class_getInstanceMethod(self, sel1), class_getInstanceMethod(self, sel2));
    };
}

/// 防止其他对象访问崩溃
- (BOOL)isTheme {return NO;}

@end
