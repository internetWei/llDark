//
//  UIColor+Dark.h
//  LLDark <https://github.com/internetWei/llDark>
//
//  Created by LL on 2020/11/17.
//

#import <UIKit/UIKit.h>

#if __has_include(<LLDark/LLDarkConfig.h>)
#import <LLDark/LLDarkConfig.h>
#else
#import "LLDarkConfig.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Dark)

/// 删除主题属性，并返回浅色状态下的颜色。
@property (nonatomic, readonly) UIColor *removeTheme;

/// 将一个themeColor转换成CGColor
@property (nonatomic, readonly) CGColorRef CGThemeColor;

/**
 创建一个主题颜色
 
 @discussion 传递指定深色颜色或者传递nil，传递nil将会从LLDarkSource中获取深色颜色。
 */
- (UIColor * (^) (UIColor * _Nullable darkColor))themeColor;

/**
 创建一个主题CGColor
 
 @discussion 传递指定深色颜色或者传递nil，传递nil将会从LLDarkSource中获取深色颜色。
 */
- (CGColorRef (^) (UIColor * _Nullable darkColor))themeCGColor;






#pragma mark ----------分割线----------

/// YES：是主题颜色，NO，不是主题颜色
@property (nonatomic, readonly) BOOL isTheme;

/// 传递指定模式，并返回模式下对应的UIColor。
- (UIColor * (^) (LLUserInterfaceStyle))resolvedColor;

/// 传递指定模式，并返回模式下对应的CGColor。
- (CGColorRef (^) (LLUserInterfaceStyle))resolvedCGColor;

@end

NS_ASSUME_NONNULL_END
