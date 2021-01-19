//
//  LLLaunchScreen.h
//  LLDark <https://github.com/internetWei/llDark>
//
//  Created by LL on 2020/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLLaunchScreen : NSObject

/// 启动图文件名称，如果是名称LaunchScreen则不用传递。
@property (nonatomic, class, nullable) NSString *launchScreenName;

/**
 自定义暗黑启动图校验规则
 
 @discussion 默认情况下，通过获取图片右上角1×1像素单位的RGB值来判断该图片是不是暗黑系图片。
 如果实现了此方法，返回YES表示该图片是暗黑系图片，可以参考pixelColorFromPoint属性。
 */
@property (nonatomic, class) BOOL (^hasDarkImageBlock) (UIImage *image);

/// 竖屏浅色启动图
@property (nonatomic, class, nullable) UIImage *verticalLightImage;

/// 竖屏深色启动图
@property (nonatomic, class, nullable) UIImage *verticalDarkImage API_AVAILABLE(ios(13.0));

/// 横屏浅色启动图
@property (nonatomic, class, nullable) UIImage *horizontalLightImage;

/// 横屏深色启动图
@property (nonatomic, class, nullable) UIImage *horizontalDarkImage API_AVAILABLE(ios(13.0));

/// 适配主题启动图，在主题切换时调用。
+ (void)launchImageAdaptation;

/// 初始化启动图信息，不会替换任何启动图。
+ (void)initialization;

/// 恢复启动图为初始状态，可以解决启动图显示异常的问题。
+ (void)restoreLaunchScreeen;

@end

NS_ASSUME_NONNULL_END
