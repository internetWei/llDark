//
//  CALayer+Dark.h
//  LLDark <https://github.com/internetWei/llDark>
//
//  Created by LL on 2020/11/19.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (Dark)

@property (nonatomic, assign) BOOL isDarkMode;

@property (nonatomic, nullable) UIColor *borderThemeColor;

@property (nonatomic, nullable) UIColor *backgroundThemeColor;

@property (nonatomic, nullable) UIColor *shadowThemeColor;

@property (nonatomic, nullable) UIImage *contentImage;

@end

NS_ASSUME_NONNULL_END
