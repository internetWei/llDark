//
//  LLLaunchScreen.h
//  LLDark <https://github.com/internetWei/llDark>
//
//  Created by LL on 2020/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LLDarkLaunchImageType) {
    LLDarkLaunchImageTypeVerticalLight,   /**< 竖屏浅色启动图*/
    LLDarkLaunchImageTypeVerticalDark API_AVAILABLE(ios(13.0)) ,    /**< 竖屏深色启动图*/
    LLDarkLaunchImageTypeHorizontalLight, /**< 横屏浅色启动图*/
    LLDarkLaunchImageTypeHorizontalDark API_AVAILABLE(ios(13.0)),  /**< 横屏深色启动图*/
};

@interface LLLaunchScreen : NSObject


/**
 自定义暗黑启动图校验规则
 
 @discussion 默认情况下，通过获取图片右上角1×1像素单位的RGB值来判断该图片是不是暗黑系图片。
 如果实现了此方法，返回YES表示该图片是暗黑系图片，可以参考pixelColorFromPoint属性。
 */
@property (nonatomic, class) BOOL (^hasDarkImageBlock) (UIImage *image);


/**
 将所有启动图恢复为默认启动图
 
 @discussion 此操作具有破坏性，会丢失已修改的启动图。
 */
+ (void)restoreAsBefore;


/// 获取指定模式下的启动图对象
+ (nullable UIImage *)launchImageFromLaunchImageType:(LLDarkLaunchImageType)launchImageType;


/// 替换指定启动图
/// @param replaceImage 需要写入的图片，传入nil表示恢复为默认启动图。
/// @param launchImageType 替换的图片类型
/// @param quality 图片压缩比例，默认为0.8
/// @param validationBlock 自定义校验回调，返回YES表示替换，NO表示不替换。
+ (BOOL)replaceLaunchImage:(nullable UIImage *)replaceImage
           launchImageType:(LLDarkLaunchImageType)launchImageType
        compressionQuality:(CGFloat)quality
          validation:(BOOL (^ _Nullable) (UIImage *originImage, UIImage *replaceImage))validationBlock;


/// 替换所有竖屏启动图
+ (void)replaceVerticalLaunchImage:(nullable UIImage *)verticalImage;


/// 替换所有横屏启动图
+ (void)replaceHorizontalLaunchImage:(nullable UIImage *)horizontalImage;

@end

NS_ASSUME_NONNULL_END
