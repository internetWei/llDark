//
//  LLDarkManager.m
//  LLDark
//
//  Created by LL on 2020/11/17.
//

#import "LLDarkManager.h"

#import "LLDarkWindow.h"
#import "LLDarkDefine.h"
#import "LLLaunchScreen.h"
#import "UIView+Refresh.h"
#import "NSObject+Dark.h"
#import "NSObject+Refresh.h"

#import <objc/runtime.h>

/// APP主题模式存储标识符
static NSString * const ll_user_theme_identifier = @"ll_user_theme_identifier";

@implementation LLDarkManager

+ (void)initialize {
    NSString *theme = [[NSUserDefaults standardUserDefaults] objectForKey:ll_user_theme_identifier];
    
    _userInterfaceStyle = NSIntegerFromNSString(theme);
    if (!theme && UIDevice.currentDevice.systemVersion.floatValue < 13.0) {
        _userInterfaceStyle = LLUserInterfaceStyleLight;
    }
    
    if (@available(iOS 13.0, *)) {
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(systemThemeDidChange) name:SystemThemeDidChangeNotification object:nil];
    }
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(themeDidChange) name:ThemeDidChangeNotification object:nil];
}


/// APP主题已发生改变
+ (void)themeDidChange {
    for (NSObject *obj in NSObject.themeTables) {
        !obj.themeDidChange ?: obj.themeDidChange(obj);
    }
}

/// 系统主题已发生改变
+ (void)systemThemeDidChange API_AVAILABLE(ios(13.0)) {
    if (self.userInterfaceStyle == LLUserInterfaceStyleUnspecified) {
        // 上次暗黑状态
        BOOL originDark = [self isDarkMode:LLDarkWindow.oldUserInterfaceStyle];
        // 当前的暗黑状态
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
    // ①.刷新window上的视图，例如弹窗。
    [self refreshWindow];
    
    // ②.刷新视图控制器上的视图
    [self refreshViewController];
}

/// 刷新UIWindow上的视图，例如弹窗
+ (void)refreshWindow {
    if (currentWindow().userInterfaceStyle != LLUserInterfaceStyleUnspecified) return;
    for (UIView *view in currentWindow().subviews) {
        if (![view isMemberOfClass:NSClassFromString(@"UITransitionView")]) {
            [view refresh];
        }
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
    /// ⓪.初始化启动图
    [LLLaunchScreen initialization];
    
    /// 判断LLUserInterfaceStyle是否合适。
    if (UIDevice.currentDevice.systemVersion.floatValue < 13.0 &&
        userInterfaceStyle == LLUserInterfaceStyleUnspecified) {
        userInterfaceStyle = LLUserInterfaceStyleLight;
    }
    
    if (userInterfaceStyle == _userInterfaceStyle) return;
    
    BOOL originDark = self.isDarkMode;
    _userInterfaceStyle = userInterfaceStyle;
    BOOL currentDark = self.isDarkMode;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        /// ①.修改系统的主题模式
        if (@available(iOS 13.0, *)) {
            currentWindow().overrideUserInterfaceStyle = (UIUserInterfaceStyle)userInterfaceStyle;
        }
        
        // ②.刷新当前可见的视图。
        if (originDark != currentDark) {
            [self refreshDisplayedView];
        }
        
        /// ③.保存主题模式并发送主题已改变通知
        [NSUserDefaults.standardUserDefaults setObject:NSStringFromInteger(userInterfaceStyle) forKey:ll_user_theme_identifier];
        [NSNotificationCenter.defaultCenter postNotificationName:ThemeDidChangeNotification object:@(userInterfaceStyle)];
        
        /// ④.修改启动图的主题模式
        [LLLaunchScreen modifyLaunchScreen];
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

+ (void)setLaunchScreenName:(NSString *)launchScreenName {
    objc_setAssociatedObject(self, @selector(launchScreenName), launchScreenName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (NSString *)launchScreenName {
    return objc_getAssociatedObject(self, @selector(launchScreenName));
}

+ (LLUserInterfaceStyle)systemInterfaceStyle {
    return LLDarkWindow.userInterfaceStyle;
}

+ (BOOL)isSystemDarkMode {
    return (self.systemInterfaceStyle == LLUserInterfaceStyleDark);
}

@end
