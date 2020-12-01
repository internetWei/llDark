//
//  UIView+Refresh.h
//  LLDark
//
//  Created by LL on 2020/11/17.
//

#import <UIKit/UIKit.h>

#import "LLDarkConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Refresh)

/// 递归刷新View以及subviews的UI样式。
- (void)refresh;

/// 按照指定类型进行刷新
- (void)refresh:(LLUserInterfaceStyle)userInterfaceStyle;

@end

NS_ASSUME_NONNULL_END
