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
 当View对象需要刷新时回调
 
 @discussion 仅当UI需要刷新时才会回调
 
 例如以下情况不会触发回调：
 
 LLUserInterfaceStyleUnspecified(系统是深色模式)->LLUserInterfaceStyleDark
 */
@property (nonatomic, copy) void(^appearanceBindUpdater)(id bindView);

@property (nonatomic, assign) BOOL isDarkMode;

@end

NS_ASSUME_NONNULL_END
