//
//  LLLaunchScreen.h
//  LLDark
//
//  Created by LL on 2020/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLLaunchScreen : NSObject

/// 竖屏浅色启动图
@property (nonatomic, class, nullable) UIImage *verticalLightImage;

/// 竖屏深色启动图
@property (nonatomic, class, nullable) UIImage *verticalDarkImage;

/// 横屏浅色启动图
@property (nonatomic, class, nullable) UIImage *horizontalLightImage;

/// 横屏深色启动图
@property (nonatomic, class, nullable) UIImage *horizontalDarkImage;

/// 适配启动图
+ (void)launchImageAdaptation;

+ (void)initialization;

@end

NS_ASSUME_NONNULL_END
