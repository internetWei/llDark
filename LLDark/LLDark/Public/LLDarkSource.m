//
//  LLDarkSource.m
//  LLDark
//
//  Created by LL on 2020/11/17.
//

#import "LLDarkSource.h"

@interface LLDarkSource ()

/**
 深色颜色主题资源
 
 @discussion Key是浅色主题下的颜色，value是深色主题的颜色。
 
 样例代码
 
 @{
 
 // 浅色主题颜色     :  深色主题颜色
 
 [UIColor redColor] : [UIColor blueColor],
 
 }
 */
@property (nonatomic, readonly, class) NSMutableDictionary<UIColor *, UIColor *> *darkColorTheme;

/**
 深色图片主题资源
 
 @discussion Key是浅色主题下的图片名称，value是深色主题的图片名称。
 
 样例代码
 
 @{
 
 // 浅色主题图片名称     :  深色主题图片名称
 
 @"lightImageName" : @"darkImageName",
 
 }
 
 不用考虑倍图关系，@2x、@3x不用写。
 */
@property (nonatomic, readonly, class) NSMutableDictionary<NSString *, NSString *> *darkImageTheme;

/// 包含在此集合中的类名将会执行自定义刷新操作(例如YYLabel、YYTextView)。
@property (nonatomic, readonly, class) NSSet<NSString *> *thirdList;

@end

@implementation LLDarkSource

+ (UIColor * _Nonnull (^)(UIColor * _Nonnull))darkColorForKey {
    return ^(UIColor *key) {
        return [self.darkColorTheme objectForKey:key];
    };
}

+ (NSString * _Nonnull (^)(NSString * _Nonnull))darkImageForKey {
    return ^(NSString *key) {
        return [self.darkImageTheme objectForKey:key];
    };
}

+ (BOOL (^)(NSString * _Nonnull))thirdControlList {
    return ^(NSString *className) {
        return [self.thirdList containsObject:className];
    };
}

#pragma mark - getter/setter
+ (NSMutableDictionary<UIColor *, UIColor *> *)darkColorTheme {
    static NSMutableDictionary<UIColor *, UIColor *> *darkColorTheme = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *t_dict = @{
            /* 样例代码
            UIColor.redColor : UIColor.blueColor
             */
            kColorRGB(27, 27, 27) : UIColor.whiteColor,
            UIColor.whiteColor : kColorRGB(27, 27, 27),
            kColorRGB(240, 238, 245) : kColorRGB(39, 39, 39),
            kColorRGB(57, 56, 60) : kColorRGBA(255, 255, 255, 0.87),
            kColorRGB(176, 176, 176) : kColorRGBA(255, 255, 255, 0.6),
            kColorRGB(57, 56, 60) : kColorRGB(255, 255, 255),
            kColorRGB(241, 242, 241) : kColorRGB(39, 39, 39),
            kColorRGB(77, 77, 75) : kColorRGBA(255, 255, 255, 0.38),
        };
        darkColorTheme = [t_dict mutableCopy];
    });
    return darkColorTheme;
}

+ (NSMutableDictionary<NSString *,NSString *> *)darkImageTheme {
    static NSMutableDictionary<NSString *, NSString *> *darkImageTheme = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *t_dict = @{
            /* 样例代码
            @"lightImage" : @"darkImage",
            @"ligthPath" : @"darkPath",
             */
            @"background_light" : @"background_dark",
            @"durk_light" : @"durk_dark",
        };
        darkImageTheme = [t_dict mutableCopy];
    });
    return darkImageTheme;
}

+ (NSSet<NSString *> *)thirdList {
    static NSSet<NSString *> *_thirdList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 包含在集合中的类必须要在LLThird.m文件中实现对应的刷新方法，否则会发生运行时崩溃。\
        YYLabel和YYTextView已经实现了自定义刷新方法。
        NSArray *t_array = @[
            @"YYLabel", @"YYTextView"
        ];
        _thirdList = [NSSet setWithArray:t_array];
    });
    return _thirdList;
}

@end
