//
//  NSMutableAttributedString+Dark.h
//  LLDark
//
//  Created by LL on 2020/11/18.
//

#import <Foundation/Foundation.h>

#import "LLDarkConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (Refresh)

/// 遍历并刷新attributes
- (void)refreshAttributes:(LLUserInterfaceStyle)userInterfaceStyle;

/// 遍历并刷新YYAttributes
- (void)refreshYYAttributes:(LLUserInterfaceStyle)userInterfaceStyle;

@end

NS_ASSUME_NONNULL_END
