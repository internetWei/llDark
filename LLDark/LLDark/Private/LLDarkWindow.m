//
//  LLDarkWindow.m
//  LLDark
//
//  Created by LL on 2020/11/17.
//

#import "LLDarkWindow.h"

#import "LLDarkDefine.h"
#import "AppDelegate.h"
#if __has_include("SceneDelegate.h")
#import "SceneDelegate.h"
#endif
#import "LLLaunchScreen.h"
#import "LLDarkManager.h"
#import "UIView+Refresh.h"
#import "NSObject+Refresh.h"

#import <objc/runtime.h>

@implementation LLDarkWindow

+ (instancetype)sharedInstance {
    static LLDarkWindow *shareWindow = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareWindow = [[self alloc] init];
        shareWindow.frame = UIScreen.mainScreen.bounds;
        if (@available(iOS 13.0, *)) {
            ll_CodeSync({
                _oldUserInterfaceStyle = (LLUserInterfaceStyle)UITraitCollection.currentTraitCollection.userInterfaceStyle;
                _userInterfaceStyle = _oldUserInterfaceStyle;
            });
        }
        shareWindow.userInteractionEnabled = NO;
        shareWindow.windowLevel = UIWindowLevelAlert + 1;
        shareWindow.hidden = NO;
        shareWindow.opaque = NO;
        shareWindow.backgroundColor = [UIColor clearColor];
        shareWindow.layer.backgroundColor = [UIColor clearColor].CGColor;
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(windowDidBecomeVisible:) name:UIWindowDidBecomeVisibleNotification object:nil];
    });
    return shareWindow;
}

/// 重写系统方法禁止设置该Window的模式状态。
- (void)setOverrideUserInterfaceStyle:(UIUserInterfaceStyle)overrideUserInterfaceStyle {}

static LLUserInterfaceStyle _userInterfaceStyle;
+ (LLUserInterfaceStyle)userInterfaceStyle {
    return _userInterfaceStyle;
}

static LLUserInterfaceStyle _oldUserInterfaceStyle;
+ (LLUserInterfaceStyle)oldUserInterfaceStyle {
    return _oldUserInterfaceStyle;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if (@available(iOS 13.0, *)) {
        if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
            _oldUserInterfaceStyle = _userInterfaceStyle;
            _userInterfaceStyle = (LLUserInterfaceStyle)self.traitCollection.userInterfaceStyle;
            [NSNotificationCenter.defaultCenter postNotificationName:SystemThemeDidChangeNotification object:@(_userInterfaceStyle)];
        }
    }
}

/// 当Window即将可见时设置正确的模式状态以及刷新它的子视图UI样式。
+ (void)windowDidBecomeVisible:(NSNotification *)noti {
    UIWindow *window = (UIWindow *)noti.object;
    
    if (@available(iOS 13.0, *)) {
        window.overrideUserInterfaceStyle = (UIUserInterfaceStyle)LLDarkManager.userInterfaceStyle;
    }
    for (UIView *view in window.subviews) {
        if (![view isMemberOfClass:NSClassFromString(@"UITransitionView")]) {
            [view refresh];
        }
    }
}

@end


#if __has_include("SceneDelegate.h")

@implementation SceneDelegate (Theme)

+ (void)load {
    if (@available(iOS 13.0, *)) {
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(scene:willConnectToSession:options:)), class_getInstanceMethod(self, @selector(ll_scene:willConnectToSession:options:)));
    }
}

- (void)ll_scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions API_AVAILABLE(ios(13.0)) {
    [LLLaunchScreen initialization];
    
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    LLDarkWindow *themeWindow = LLDarkWindow.sharedInstance;
    themeWindow.windowScene = windowScene;
    [themeWindow makeKeyAndVisible];
    [self ll_scene:scene willConnectToSession:session options:connectionOptions];
}

@end

#endif


@implementation AppDelegate (Theme)

+ (void)load {
#if __has_include("SceneDelegate.h")
    if (UIDevice.currentDevice.systemVersion.floatValue < 13.0) {
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(application:didFinishLaunchingWithOptions:)), class_getInstanceMethod(self, @selector(ll_application:didFinishLaunchingWithOptions:)));
    }
#else
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(application:didFinishLaunchingWithOptions:)), class_getInstanceMethod(self, @selector(ll_application:didFinishLaunchingWithOptions:)));
#endif
    
}

- (BOOL)ll_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [LLLaunchScreen initialization];
    
    LLDarkWindow *themeWindow = LLDarkWindow.sharedInstance;
    [themeWindow setRootViewController:[UIViewController new]];
    [themeWindow makeKeyAndVisible];
    BOOL status = [self ll_application:application didFinishLaunchingWithOptions:launchOptions];
    return status;
}

@end
