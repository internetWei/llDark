//
//  LLDarkSource.m
//  LLDark <https://github.com/internetWei/llDark>
//
//  Created by LL on 2020/11/17.
//

#import "LLDarkSource.h"

#import "NSObject+Expand.h"

@interface LLDarkSource ()

/**
 深色Color主题资源
 
 @discussion key是浅色主题下的颜色，value是深色主题的颜色。
 
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
 
 不用考虑倍图关系，不用写@2x、@3x。
 */
@property (nonatomic, readonly, class) NSMutableDictionary<NSString *, NSString *> *darkImageTheme;


/// 包含在此集合中的类名将会执行自定义刷新操作(例如YYLabel、YYTextView)。
@property (nonatomic, readonly, class) NSSet<NSString *> *thirdList;

@end

@implementation LLDarkSource

static NSMutableDictionary<UIColor *, UIColor *> *_darkColorTheme;
static NSMutableDictionary<NSString *, NSString *> *_darkImageTheme;
static NSSet<NSString *> *_thirdList;
+ (void)initialize {
    _darkColorTheme = [NSMutableDictionary dictionary];
    _darkImageTheme = [NSMutableDictionary dictionary];
    NSDictionary *t_dict = [self ll_get:@"llDarkTheme"];
    for (id key in t_dict) {
        id value = [t_dict objectForKey:key];
        if ([key isKindOfClass:NSString.class]) {
            [_darkImageTheme setValue:value forKey:key];
            continue;
        }
        if ([key isKindOfClass:UIColor.class]) {
            [_darkColorTheme setValue:value forKey:key];
            continue;
        }
    }
    
    NSArray *t_array = @[@"YYLabel", @"YYTextView"];
    t_array = [t_array arrayByAddingObjectsFromArray:[self ll_get:@"thirdControlClassName"]];
    _thirdList = [NSSet setWithArray:t_array];
}

+ (void)updateDarkTheme:(NSDictionary *)darkTheme {
    for (id key in darkTheme) {
        id value = [darkTheme objectForKey:key];
        if ([key isKindOfClass:NSString.class]) {
            [_darkImageTheme setValue:value forKey:key];
            continue;
        }
        if ([key isKindOfClass:UIColor.class]) {
            [_darkColorTheme setValue:value forKey:key];
            continue;
        }
    }
}

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
    return _darkColorTheme;
}

+ (NSMutableDictionary<NSString *,NSString *> *)darkImageTheme {
    return _darkImageTheme;
}

+ (NSSet<NSString *> *)thirdList {
    return _thirdList;
}

@end
