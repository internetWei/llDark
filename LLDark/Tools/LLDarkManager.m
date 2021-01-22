//
//  LLDarkManager.m
//  LLDark <https://github.com/internetWei/llDark>
//
//  Created by LL on 2020/11/17.
//

#import "LLDarkManager.h"

#import "LLDarkWindow.h"
#import "LLDarkDefine.h"
#import "UIView+Refresh.h"
#import "NSObject+Dark.h"
#import "NSObject+Refresh.h"

/// APP主题模式存储标识符
static NSString * const llDark_user_theme_identifier = @"llDark_user_theme_identifier";

@implementation LLDarkManager

+ (void)initialize {
    NSString *theme = [[NSUserDefaults standardUserDefaults] objectForKey:llDark_user_theme_identifier];
    
    _userInterfaceStyle = NSIntegerFromNSString(theme);
    if (!theme && UIDevice.currentDevice.systemVersion.floatValue < 13.0) {
        _userInterfaceStyle = LLUserInterfaceStyleLight;
    }
    
    if (@available(iOS 13.0, *)) {
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(systemThemeDidChange) name:SystemThemeDidChangeNotification object:nil];
    }
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(themeDidChange) name:ThemeDidChangeNotification object:nil];
}


/// APP主题发生改变
+ (void)themeDidChange {
    for (NSObject *obj in NSObject.themeTables) {
        !obj.themeDidChange ?: obj.themeDidChange(obj);
    }
}

/// 系统主题发生改变
+ (void)systemThemeDidChange API_AVAILABLE(ios(13.0)) {
    if (self.userInterfaceStyle == LLUserInterfaceStyleUnspecified) {
        // 上次暗黑状态
        BOOL originDark = [self isDarkMode:LLDarkWindow.oldUserInterfaceStyle];
        // 当前暗黑状态
        BOOL currentDark = self.isDarkMode;
        
        if (originDark != currentDark) {
            [self refreshDisplayedView];
            [NSNotificationCenter.defaultCenter postNotificationName:ThemeDidChangeNotification object:@(_userInterfaceStyle)];
        }
    }
    
    for (NSObject *obj in NSObject.systemThemeTables) {
        !obj.systemThemeDidChange ?: obj.systemThemeDidChange(obj);
    }
}


/// 刷新当前正在显示的视图
+ (void)refreshDisplayedView {
    // 1.刷新window上的视图，例如window上的弹窗
    [self refreshWindow];
    
    // 2.刷新视图控制器上的视图
    [self refreshViewController];
}

/// 刷新window上的视图，例如window上的弹窗
+ (void)refreshWindow {
    if (currentWindow().userInterfaceStyle != LLUserInterfaceStyleUnspecified) return;
    
    for (UIView *view in currentWindow().subviews) {
        if ([view isMemberOfClass:NSClassFromString(@"UITransitionView")] == YES) continue;
        [view refresh];
    }
}

/// 刷新视图控制器上的视图
+ (void)refreshViewController {
    UIViewController *vc = findCurrentShowingViewController();
    
    UINavigationController *nav = vc.navigationController;
    UITabBarController *tab = vc.tabBarController;
    
    [vc.view refresh];
    [nav.navigationBar refresh];
    [nav.toolbar refresh];
    [tab.tabBar refresh];
    
    if ([vc isKindOfClass:UISearchController.class]) {
        UISearchController *searchVC = (UISearchController *)vc;
        [searchVC.searchBar refresh];
    }
}


#pragma mark - setter/getter
static LLUserInterfaceStyle _userInterfaceStyle;
+ (LLUserInterfaceStyle)userInterfaceStyle {
    return _userInterfaceStyle;
}

+ (void)setUserInterfaceStyle:(LLUserInterfaceStyle)userInterfaceStyle {
    if (UIDevice.currentDevice.systemVersion.floatValue < 13.0 &&
        userInterfaceStyle == LLUserInterfaceStyleUnspecified) {
        userInterfaceStyle = LLUserInterfaceStyleLight;
    }
    
    if (userInterfaceStyle == _userInterfaceStyle) return;
    
    BOOL originDark = self.isDarkMode;
    _userInterfaceStyle = userInterfaceStyle;
    BOOL currentDark = self.isDarkMode;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        /// 1.修改系统的主题模式
        if (@available(iOS 13.0, *)) {
            for (UIWindow *window in UIApplication.sharedApplication.windows) {
                if (window.hidden == NO && window != LLDarkWindow.sharedInstance) {
                    window.overrideUserInterfaceStyle = (UIUserInterfaceStyle)userInterfaceStyle;
                }
            }
        }
        
        // 2.刷新当前可见的视图。
        if (originDark != currentDark) {
            [self refreshDisplayedView];
        }
        
        /// 3.保存主题模式并发送主题已改变通知
        [NSUserDefaults.standardUserDefaults setObject:NSStringFromInteger(userInterfaceStyle) forKey:llDark_user_theme_identifier];
        [NSNotificationCenter.defaultCenter postNotificationName:ThemeDidChangeNotification object:@(userInterfaceStyle)];
    });
}

+ (BOOL)isDarkMode:(LLUserInterfaceStyle)userInterfaceStyle {
    if (@available(iOS 13.0, *)) {
        if (_userInterfaceStyle == LLUserInterfaceStyleUnspecified) {
            return (userInterfaceStyle == LLUserInterfaceStyleDark);
        }
    }
    return (_userInterfaceStyle == LLUserInterfaceStyleDark);
}

+ (BOOL)isDarkMode {
    if (@available(iOS 13.0, *)) {
        return [self isDarkMode:self.systemInterfaceStyle];
    } else {
        return [self isDarkMode:kNilOptions];
    }
}

+ (LLUserInterfaceStyle)systemInterfaceStyle {
    return LLDarkWindow.userInterfaceStyle;
}

+ (BOOL)isSystemDarkMode {
    return (self.systemInterfaceStyle == LLUserInterfaceStyleDark);
}

@end
