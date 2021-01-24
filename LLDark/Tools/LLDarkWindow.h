//
//  LLDarkWindow.h
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

@interface LLDarkWindow : UIWindow

@property (nonatomic, readonly, class) LLDarkWindow *sharedInstance;

/// 系统上一次的主题模式
@property (nonatomic, readonly, class) LLUserInterfaceStyle oldUserInterfaceStyle API_AVAILABLE(ios(13.0));

@end

NS_ASSUME_NONNULL_END
