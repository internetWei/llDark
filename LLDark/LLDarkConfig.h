//
//  LLDarkConfig.h
//  LLDark <https://github.com/internetWei/llDark>
//
//  Created by LL on 2020/11/17.
//

#ifndef LLDarkConfig_h
#define LLDarkConfig_h

/**
 通知观察者APP主题已发生改变，新的主题以NSNumber形式存储在通知的object参数中。
 
 不管是由于系统主题变化还是主动切换主题导致的变化，只要APP的主题发生了变化就会在主线程中发送通知。
 
 页面UI不一定会刷新，例如当前是“跟随系统”，系统是浅色模式，点击切换到浅色模式。
 */
static NSString * const ThemeDidChangeNotification = @"ThemeDidChangeNotification";

/**
 通知观察者系统主题已发生改变，新的主题以NSNumber形式存储在通知的object参数中。
 
 仅在iOS13及以上机型会发送该通知，只要系统主题发生变化就会在主线程发送通知。
 
 后台情况下也可能会触发该通知。
 */
static NSString * const SystemThemeDidChangeNotification = @"SystemThemeDidChangeNotification";

/**
 APP主题模式
 
 iOS13及以下机型使用LLUserInterfaceStyleUnspecified将被替换为LLUserInterfaceStyleLight。
 */
typedef NS_ENUM(NSInteger, LLUserInterfaceStyle) {
    LLUserInterfaceStyleUnspecified = 0,/**< 跟随系统*/
    LLUserInterfaceStyleLight = 1,/**< 浅色模式*/
    LLUserInterfaceStyleDark = 2,/**< 深色模式*/
};

#endif /* LLDarkConfig_h */
