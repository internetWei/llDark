//
//  LLDarkManager.h
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

@interface LLDarkManager : NSObject

/// APP当前深色模式状态
@property (nonatomic, readonly, class) BOOL isDarkMode;

/// 系统当前深色模式状态
@property (nonatomic, readonly, class) BOOL isSystemDarkMode API_AVAILABLE(ios(13.0));

/// get方法获取APP的主题模式，set方法设置APP的主题模式
@property (nonatomic, class) LLUserInterfaceStyle userInterfaceStyle;

/// 系统当前的主题模式
@property (nonatomic, class, readonly) LLUserInterfaceStyle systemInterfaceStyle API_AVAILABLE(ios(13.0));

@end

NS_ASSUME_NONNULL_END
