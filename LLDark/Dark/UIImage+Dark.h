//
//  UIImage+Dark.h
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

/// 所有方法返回的UIImage实例对象渲染模式均为UIImageRenderingModeAlwaysOriginal。
@interface UIImage (Dark)

/// 创建一个主题图片，并返回当前主题下的图片对象。
+ (UIImage * _Nullable (^) (NSString *lightImageName, NSString * _Nullable darkImageName))themeImage;

/// 和themeImage作用一致。方便全局替换`imageNamed:`
+ (nullable UIImage *)themeImage:(NSString *)lightImageName;

/// 删除主题属性，返回浅色状态下的图片
@property (nonatomic, readonly) UIImage *removeTheme;

/**
 通过图片名称/路径加载图像
 
 @discussion 优先使用imageWithContentsOfFile加载。
 */
+ (UIImage * _Nullable (^) (NSString *))imageNamed;

/// 返回使用指定渲染模式渲染的主题图片
- (UIImage * (^) (UIImageRenderingMode))renderingModeFrom;





#pragma mark ----------分割线----------

@property (nonatomic, readonly) BOOL isTheme;

@property (nonatomic, readonly) BOOL hasDarkImage;

/// 传递指定模式，并返回模式下对应的UIImage。
- (UIImage * (^) (LLUserInterfaceStyle))resolvedImage;

/// 传入图片的饱合度，在子线程中生成一张新饱合度的图片并在主线程中返回。
- (void)darkImage:(void (^) (UIImage *darkImage))complete saturation:(CGFloat)value;

/// 获取图片上某个点的RGB值(不包含alpha)。
- (nullable NSArray<NSNumber *> *)pixelColorFromPoint:(CGPoint)point;

- (UIImage *)resizeImageWithDirection:(BOOL)vertical;

@end

NS_ASSUME_NONNULL_END
