//
//  NSObject+Refresh.h
//  LLDark <https://github.com/internetWei/llDark>
//
//  Created by LL on 2020/11/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Refresh)

/// 遍历UIControlState所有类型并执行complete块。
- (void)forinUIControlState:(void (^)(UIControlState state, id obj))complete;


/// 遍历UIBarMetrics所有类型并执行complete块
- (void)forinUIBarMetrics:(void (^) (UIBarMetrics metrics, id obj))complete;


/// 遍历UIBarPosition所有类型并执行complete块
- (void)forinUIBarPosition:(void (^) (UIBarPosition position, id obj))complete;


/// 遍历UIBarButtonItemStyle所有类型并执行complete块
- (void)forinUIBarButtonItemStyle:(void (^) (UIBarButtonItemStyle style, id obj))complete;


/// 遍历UISearchBarIcon所有类型并执行complete块
- (void)forinUISearchBarIcon:(void (^) (UISearchBarIcon icon, id obj))complete;

@end

NS_ASSUME_NONNULL_END
