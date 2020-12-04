//
//  UIImageView+Dark.h
//  LLDark
//
//  Created by LL on 2020/11/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSInteger, LLDarkStyle) {/**< 深色主题图片适配样式*/
    LLDarktyleUndefined = 0,/**< 不采取任何措施*/
    LLDarkStyleMask = 1,/** 蒙层样式，使用蒙层适配深色主题*/
    LLDarkStyleSaturation = 2,/**< 饱合度样式，降低饱合度适配深色主题*/
};

@interface UIImageView (Dark)

/**
 设置深色主题下网络图片的适配方式
 
 使用LLDarkStyleMask时不用传递第3个参数(唯一标识)，如果使用LLDarkStyleSaturation请在第3个参数传递一个唯一标识符，
 通常是网络图片的url字符串。
 
 样例代码
 
 UIImageView *imageView = [UIImageView new];
 
 imageView.darkStyle(LLDarkStyleMask, 0.5, nil);
 
 // 添加蒙层的方式适配深色主题，浮点值聚范围(0~1.0)，数值越低透明度越低。
 
 imageView.darkStyle(LLDarkStyleSaturation, 0.8, @"http://www.baidu.com/image");
 
 // 通过降低饱合度的方式适配深色主题，浮点值聚范围(0~2.0)，数值越低饱合度越低；需要传递一个唯一标识符，通常是图片的url。
 */
- (void (^) (LLDarkStyle, CGFloat, NSString * _Nullable))darkStyle;






#pragma mark ----------分割线----------

- (void)refreshImageDarkStyle;

@end

NS_ASSUME_NONNULL_END
