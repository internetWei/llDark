//
//  LLDarkDefine.h
//  LLDark <https://github.com/internetWei/llDark>
//
//  Created by LL on 2020/11/17.
//

#ifndef LLDarkDefine_h
#define LLDarkDefine_h

#import <UIKit/UIKit.h>
#if __has_include(<LLDark/LLDarkManager.h>)
#import <LLDark/LLDarkManager.h>
#else
#import "LLDarkManager.h"
#endif

NS_ASSUME_NONNULL_BEGIN

// 空对象判断
#define ll_ObjectIsEmpty(object) !( \
([object respondsToSelector:@selector(length)] && [(NSData *)object length] > 0) || \
([object respondsToSelector:@selector(count)] && [(NSArray *)object count] > 0) || \
([object respondsToSelector:@selector(floatValue)] && [(id)object floatValue] != 0.0))


static inline NSString * NSStringFromInteger(NSInteger integer) {
    return [NSString stringWithFormat:@"%zd", integer];
}


static inline NSInteger NSIntegerFromNSString(NSString *string) {
    return [string integerValue];
}


static inline UIWindow * currentWindow(void) {
    if (@available(iOS 13.0, *)) {
        return UIApplication.sharedApplication.windows.firstObject;
    } else {
        return UIApplication.sharedApplication.keyWindow;
    }
}


static inline UIViewController * findCurrentShowingViewControllerFrom(UIViewController *vc) {
    UIViewController *currentShowingVC = nil;
    if ([vc presentedViewController]) {
        UIViewController *nextRootVC = [vc presentedViewController];
        currentShowingVC = findCurrentShowingViewControllerFrom(nextRootVC);
    } else if ([vc isKindOfClass:UITabBarController.class]) {
        UIViewController *nextRootVC = [(UITabBarController *)vc selectedViewController];
        currentShowingVC = findCurrentShowingViewControllerFrom(nextRootVC);
    } else if ([vc isKindOfClass:UINavigationController.class]) {
        UIViewController *nextRootVC = [(UINavigationController *)vc visibleViewController];
        currentShowingVC = findCurrentShowingViewControllerFrom(nextRootVC);
    } else {
        currentShowingVC = vc;
    }
    return currentShowingVC;
}


/// 获取当前显示的ViewController
static inline UIViewController * findCurrentShowingViewController(void) {
    UIViewController *vc = currentWindow().rootViewController;
    UIViewController *currentShowingVC =  findCurrentShowingViewControllerFrom(vc);
    return currentShowingVC;
}


/// 返回指定模式下对应的对象
static inline id correctObj(id lightObj, id darkObj) {
    return LLDarkManager.isDarkMode ? darkObj : lightObj;
}

/// 获取需要刷新的NSAttributedStringKey数组
static inline NSArray<NSString *> * attributedStringKey(void) {
    static NSArray<NSString *> *t_array = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        t_array = @[
            NSForegroundColorAttributeName, NSShadowAttributeName, NSBackgroundColorAttributeName,
            NSStrikethroughColorAttributeName, NSStrokeColorAttributeName, NSUnderlineColorAttributeName,
            NSAttachmentAttributeName
        ];
    });
    return t_array;
}

// 获取需要刷新的YYAttributedStringKey数组
static inline NSArray<NSString *> * yyAttributedStringKey(void) {
    static NSArray<NSString *> *t_array = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        t_array = @[
            @"YYTextUnderline", @"YYTextStrikethrough", @"YYTextShadow", @"YYTextInnerShadow",
            @"YYTextBorder", @"YYTextBackgroundBorder", @"YYTextBlockBorder", @"YYTextAttachment",
            @"YYTextHighlight"
        ];
    });
    return t_array;
}

/// 计算图片cost
static inline NSUInteger imageCost(UIImage *image) {
    CGImageRef cgImage = image.CGImage;
    if (!cgImage) return 1;
    CGFloat height = CGImageGetHeight(cgImage);
    size_t bytesPerRow = CGImageGetBytesPerRow(cgImage);
    NSUInteger cost = bytesPerRow * height;
    if (cost == 0) cost = 1;
    return cost;
}

/// 获取全局图片缓存池
static inline NSCache *imageCache() {
    static NSCache *imageCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageCache = [[NSCache alloc] init];
        imageCache.totalCostLimit = 1024 * 1024 * 30;
    });
    return imageCache;
}

NS_ASSUME_NONNULL_END

#endif /* LLDarkDefine_h */
