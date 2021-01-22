//
//  UIViewController+Refresh.m
//  LLDark <https://github.com/internetWei/llDark>
//
//  Created by LL on 2020/11/28.
//

#import <objc/runtime.h>

#import "NSObject+Dark.h"
#import "UIView+Refresh.h"

@implementation UIViewController (Refresh)

+ (void)load {
    self.methodExchange(@selector(viewDidLayoutSubviews), @selector(ll_viewDidLayoutSubviews));
}

- (void)ll_viewDidLayoutSubviews {
    [self ll_viewDidLayoutSubviews];
    
    [self forceRefresh];
}

- (void)forceRefresh {
    if (self.userInterfaceStyle == LLUserInterfaceStyleUnspecified) return;
    [self.view refresh:self.userInterfaceStyle];
    for (UIViewController *vc in self.childViewControllers) {
        vc.userInterfaceStyle = self.userInterfaceStyle;
        [vc forceRefresh];
    }
}

@end
