//
//  NSObject+Dark.h
//  LLDark <https://github.com/internetWei/llDark>
//
//  Created by LL on 2020/11/17.
//

#import <Foundation/Foundation.h>

#import "LLDarkConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Dark)

@property (nonatomic, assign) LLUserInterfaceStyle userInterfaceStyle;

/**
 APP主题发生改变时回调。
 
 @discussion 详情请查阅`ThemeDidChangeNotification`通知。
 
 在通知执行后触发。
 
 在主线程中回调，不保证回调顺序。
 */
@property (nonatomic, copy) void(^themeDidChange)(id bindView);

/**
 系统主题发生改变时触发。
 
 @discussion 详情请查阅`SystemThemeDidChangeNotification`通知。
 
 在通知执行后触发。
 
 在主线程中回调，不保证回调顺序。
 */
@property (nonatomic, copy) void(^systemThemeDidChange)(id bindView) API_AVAILABLE(ios(13.0));






#pragma mark ----------分割线----------

/// themeDidChange的所有集合
@property (nonatomic, class, readonly) NSHashTable *themeTables;

/// systemThemeDidChange的所有集合
@property (nonatomic, class, readonly) NSHashTable *systemThemeTables;

/// 交换2个方法的实现
+ (void (^) (SEL sel1, SEL sel2))methodExchange;

@end

NS_ASSUME_NONNULL_END
