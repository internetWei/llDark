//
//  CALayer+Refresh.h
//  LLDark
//
//  Created by LL on 2020/11/19.
//

#import <QuartzCore/QuartzCore.h>

#import "LLDarkConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (Refresh)

- (void)refresh;

- (void)refresh:(LLUserInterfaceStyle)userInterfaceStyle;

@end

NS_ASSUME_NONNULL_END
