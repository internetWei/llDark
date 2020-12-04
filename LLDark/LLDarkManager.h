//
//  LLDarkManager.h
//  LLDark
//
//  Created by LL on 2020/11/17.
//

#import <Foundation/Foundation.h>

#import "LLDarkConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLDarkManager : NSObject

/**
 YES表示深色模式，NO表示浅色模式。
 
 @discussion 只代表APP当前是否是深色模式，与系统是否是深色模式无关。
 
 如果APP设置是浅色模式，系统是深色模式，返回NO。
 */
@property (nonatomic, readonly, class) BOOL isDarkMode;

/**
 YES表示深色模式，NO表示浅色模式。
 
 @discussion 只代表系统当前是否是深色模式，与APP是否是深色模式无关。
 
 如果APP设置是浅色模式，系统是深色模式，返回YES。
 */
@property (nonatomic, readonly, class) BOOL isSystemDarkMode API_AVAILABLE(ios(13.0));

/**
 get获取APP的主题模式，set设置APP的主题模式。
 
 LLUserInterfaceStyleUnspecified仅在iOS13及以上能发挥作用，如果在iOS13以下传递LLUserInterfaceStyleUnspecified，
 内部会强制转化为LLUserInterfaceStyleLight
 */
@property (nonatomic, class) LLUserInterfaceStyle userInterfaceStyle;

/// 获取系统的主题模式，与APP主题模式无关。
@property (nonatomic, class, readonly) LLUserInterfaceStyle systemInterfaceStyle API_AVAILABLE(ios(13.0));

@end

NS_ASSUME_NONNULL_END
