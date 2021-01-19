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
 
 @discussion 与“ThemeDidChangeNotification”通知作用一致。
 
 在主线程中回调，不保证回调顺序。
 */
@property (nonatomic, copy) void(^themeDidChange)(id bindView);

/**
 系统主题发生改变时触发。
 
 @discussion 与“SystemThemeDidChangeNotification”通知作用一致。
 
 在主线程中回调，不保证回调顺序。
 */
@property (nonatomic, copy) void(^systemThemeDidChange)(id bindView);






#pragma mark ----------分割线----------

/// themeDidChange的所有集合
@property (nonatomic, class, readonly) NSHashTable *themeTables;

/// systemThemeDidChange的所有集合
@property (nonatomic, class, readonly) NSHashTable *systemThemeTables;

@end

NS_ASSUME_NONNULL_END
