//
//  LLDarkWindow.m
//  LLDark
//
//  Created by LL on 2020/11/17.
//

#import "LLDarkWindow.h"

#import "LLDarkDefine.h"
#import "LLLaunchScreen.h"
#import "LLDarkManager.h"
#import "UIView+Refresh.h"
#import "NSObject+Refresh.h"

#import <objc/runtime.h>

@implementation LLDarkWindow

+ (void)load {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didFinishLaunching) name:UIApplicationDidFinishLaunchingNotification object:nil];
}

+ (void)didFinishLaunching {
    if (@available(iOS 13.0, *)) {
        ll_CodeSync({
            _oldUserInterfaceStyle = (LLUserInterfaceStyle)UITraitCollection.currentTraitCollection.userInterfaceStyle;
            _userInterfaceStyle = _oldUserInterfaceStyle;
        });
    }
}

+ (instancetype)sharedInstance {
    static LLDarkWindow *shareWindow = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareWindow = [[self alloc] init];
        shareWindow.frame = UIScreen.mainScreen.bounds;
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
