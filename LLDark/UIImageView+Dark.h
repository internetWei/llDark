//
//  UIImageView+Dark.h
//  LLDark <https://github.com/internetWei/llDark>
//
//  Created by LL on 2020/11/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSInteger, LLDarkStyle) {/**< 深色主题图片适配样式*/
    LLDarkStyleUndefined = 0,/**< 不适配深色主题*/
    LLDarkStyleMask = 1,/** 使用蒙层适配深色主题*/
    LLDarkStyleSaturation = 2,/**< 降低饱合度适配深色主题*/
};

@interface UIImageView (Dark)

/**
 设置深色主题下网络图片的适配方式
 
 如果使用`LLDarkStyleSaturation`第3个参数需要传递一个唯一标识符(通常是图片名称/地址)
 
 样例代码
 
 UIImageView *imageView = [UIImageView new];
 
 // 添加蒙层的方式适配深色主题，浮点值聚范围(0~1.0)，数值越低透明度越低。
 
 imageView.darkStyle(LLDarkStyleMask, 0.5, nil);
 
 // 通过降低饱合度的方式适配深色主题，浮点值聚范围(0~2.0)，数值越低饱合度越低；需要传递一个唯一标识符，通常是图片的名称/地址。
 
 imageView.darkStyle(LLDarkStyleSaturation, 0.8, @"http://www.baidu.com/image");
 */
- (void (^) (LLDarkStyle, CGFloat, NSString * _Nullable))darkStyle;






#pragma mark ----------分割线----------

- (void)refreshImageDarkStyle;

@end

NS_ASSUME_NONNULL_END
