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
 
 @discussion 不管是系统主题变化还是手动切换主题变化，都会在主线程中发送通知。
 
 只要主题发生变化就会发送通知，不管页面UI是否刷新，例如从LLUserInterfaceStyleUnspecified(系统是深色模式)->LLUserInterfaceStyleDark也会发送通知。
 */
static NSString * const ThemeDidChangeNotification = @"ThemeDidChangeNotification";

/**
 通知观察者系统主题已发生改变，新的主题以NSNumber形式存储在通知的object参数中。
 
 仅在iOS13及以上机型会发送该通知，只要系统主题发生变化就会在主线程发送通知。
 
 后台情况下也可能会触发该通知。
 */

/**
 通知观察者系统主题已发生改变，新的主题以NSNumber形式存储在通知的object参数中。
 
 @discussion 只要系统主题发生变化就会在主线程中发送通知。
 
 后台情况也可能会触发通知，如有必要请做好前/后台判断逻辑。
 */
static NSString * const SystemThemeDidChangeNotification = @"SystemThemeDidChangeNotification";

/**
 APP主题模式
 
 iOS13及以下机型使用`LLUserInterfaceStyleUnspecified`将被解释为`LLUserInterfaceStyleLight`。
 */
typedef NS_ENUM(NSInteger, LLUserInterfaceStyle) {
    LLUserInterfaceStyleUnspecified = 0,/**< 跟随系统*/
    LLUserInterfaceStyleLight = 1,/**< 浅色模式*/
    LLUserInterfaceStyleDark = 2,/**< 深色模式*/
};

#endif /* LLDarkConfig_h */
