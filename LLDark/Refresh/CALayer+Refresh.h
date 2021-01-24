//
//  CALayer+Refresh.h
//  LLDark <https://github.com/internetWei/llDark>
//
//  Created by LL on 2020/11/19.
//

#import <QuartzCore/QuartzCore.h>

#if __has_include(<LLDark/LLDarkConfig.h>)
#import <LLDark/LLDarkConfig.h>
#else
#import "LLDarkConfig.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (Refresh)

- (void)refresh;

- (void)refresh:(LLUserInterfaceStyle)userInterfaceStyle;

@end

NS_ASSUME_NONNULL_END
