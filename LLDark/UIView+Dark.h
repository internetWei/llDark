//
//  UIView+Dark.h
//  LLDark <https://github.com/internetWei/llDark>
//
//  Created by LL on 2020/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Dark)

/**
 View需要刷新时会回调。
 
 @discussion 不同于themeDidChange，
 仅当View需要刷新时才会回调(例如当前是“跟随系统”，系统主题是深色模式，手动切换到深色模式是不会刷新的)。
 */
@property (nonatomic, copy) void(^appearanceBindUpdater)(id bindView);

/// YES表示当前对象是深色模式，NO表示当前对象是浅色模式。
@property (nonatomic, assign) BOOL isDarkMode;

@end

NS_ASSUME_NONNULL_END
