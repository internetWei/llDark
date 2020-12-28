//
//  LLLaunchScreen.h
//  LLDark
//
//  Created by LL on 2020/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLLaunchScreen : NSObject

/// 启动图文件名称，如果是名称LaunchScreen则不用传递。
@property (nonatomic, class, nullable) NSString *launchScreenName;

/// 竖屏浅色启动图
@property (nonatomic, class, nullable) UIImage *verticalLightImage;

/// 竖屏深色启动图
@property (nonatomic, class, nullable) UIImage *verticalDarkImage API_AVAILABLE(ios(13.0));

/// 横屏浅色启动图
@property (nonatomic, class, nullable) UIImage *horizontalLightImage;

/// 横屏深色启动图
@property (nonatomic, class, nullable) UIImage *horizontalDarkImage API_AVAILABLE(ios(13.0));

/// 适配启动图
+ (void)launchImageAdaptation;

+ (void)initialization;

@end

NS_ASSUME_NONNULL_END
