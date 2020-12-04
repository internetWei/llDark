//
//  NSObject+Dark.m
//  LLDark
//
//  Created by LL on 2020/11/17.
//

#import "NSObject+Dark.h"

#import <objc/runtime.h>

static char * const ll_themeDidChange_identifer = "ll_themeDidChange_identifer";
static char * const ll_systemThemeDidChange_identifer = "ll_systemThemeDidChange_identifer";

@implementation NSObject (Dark)

- (void)setThemeDidChange:(void (^)(id))themeDidChange {
    objc_setAssociatedObject(self, &ll_themeDidChange_identifer, themeDidChange, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [NSObject.themeTables addObject:self];
}

- (void (^)(id))themeDidChange {
    return objc_getAssociatedObject(self, &ll_themeDidChange_identifer);
}

- (void)setSystemThemeDidChange:(void (^)(id))systemThemeDidChange {
    objc_setAssociatedObject(self, &ll_systemThemeDidChange_identifer, systemThemeDidChange, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [NSObject.systemThemeTables addObject:self];
}

- (void (^)(id))systemThemeDidChange {
    return objc_getAssociatedObject(self, &ll_systemThemeDidChange_identifer);
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

/// 防止其他对象访问崩溃
- (BOOL)isTheme {return NO;}

@end
