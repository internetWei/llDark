//
//  LLDarkSource.h
//  LLDark <https://github.com/internetWei/llDark>
//
//  Created by LL on 2020/11/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLDarkSource : NSObject

/// 更新深色资源文件
+ (void)updateDarkTheme:(NSDictionary *)darkTheme;


/// 获取深色主题下的Color对象
+ (nullable UIColor * (^) (UIColor *key))darkColorForKey;


/// 获取深色主题下的ImageName对象
+ (nullable NSString * (^) (NSString *key))darkImageForKey;


/// 需要单独刷新的第3方控件列表
+ (BOOL (^)(NSString *className))thirdControlList;

@end

NS_ASSUME_NONNULL_END
