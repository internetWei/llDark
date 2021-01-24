//
//  NSMutableAttributedString+Dark.h
//  LLDark <https://github.com/internetWei/llDark>
//
//  Created by LL on 2020/11/18.
//

#import <Foundation/Foundation.h>

#if __has_include(<LLDark/LLDarkConfig.h>)
#import <LLDark/LLDarkConfig.h>
#else
#import "LLDarkConfig.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (Refresh)

/// 遍历并刷新attributes
- (void)refreshAttributes:(LLUserInterfaceStyle)userInterfaceStyle;


/// 遍历并刷新YYAttributes
- (void)refreshYYAttributes:(LLUserInterfaceStyle)userInterfaceStyle;

@end

NS_ASSUME_NONNULL_END
