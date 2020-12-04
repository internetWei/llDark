//
//  LLDarkDefine.h
//  LLDark
//
//  Created by LL on 2020/11/17.
//

#ifndef LLDarkDefine_h
#define LLDarkDefine_h

#import <UIKit/UIKit.h>
#import "LLDarkManager.h"
#import <CoreText/CTStringAttributes.h>

NS_ASSUME_NONNULL_BEGIN

// 在主线程中执行一段代码并返回对象
#define ll_RCodeSync(x) ({\
    id __block temp;\
    if ([NSThread isMainThread]) {\
        temp = x;\
    } else {\
        dispatch_semaphore_t signal = dispatch_semaphore_create(0);\
        dispatch_async(dispatch_get_main_queue(), ^{\
            temp = x;\
            dispatch_semaphore_signal(signal);\
        });\
        dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);\
    }\
    temp;\
})

// 在主线程中执行一段代码
#define ll_CodeSync(x) ({\
    if ([NSThread isMainThread]) {\
        x;\
    } else {\
        dispatch_semaphore_t signal = dispatch_semaphore_create(0);\
        dispatch_async(dispatch_get_main_queue(), ^{\
            x;\
            dispatch_semaphore_signal(signal);\
        });\
        dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);\
    }\
})

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

/// 获取APP的主要Window
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

/// 获取正确的对象，传递2个对象，返回指定模式下对应的对象。
static inline id correctObj(id lightObj, id darkObj) {
    return LLDarkManager.isDarkMode ? darkObj : lightObj;
}

/// 获取当前Scales
static inline NSArray<NSNumber *> * preferredScales(void) {
    static NSArray<NSNumber *> *scales = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat screenScale = [UIScreen mainScreen].scale;
        if (screenScale <= 1) {
            scales = @[@1, @2, @3];
        } else if (screenScale <= 2) {
            scales = @[@2, @3, @1];
        } else {
            scales = @[@3, @2, @1];
        }
    });
    return scales;
}

/// 拼接样式：string@scalex，例如@"name"->@"name@2x"
static inline NSString * _Nullable stringByAppendingNameScale(NSString *string, CGFloat scale) {
    if (![string isKindOfClass:NSString.class]) return nil;
    if (string.length == 0 || [string hasPrefix:@"/"]) return string;
    return [string stringByAppendingFormat:@"@%@x", @(scale)];
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
