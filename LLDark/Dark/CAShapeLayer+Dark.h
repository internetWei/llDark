//
//  CAShapeLayer+Dark.h
//  LLDark <https://github.com/internetWei/llDark>
//
//  Created by LL on 2020/11/19.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAShapeLayer (Dark)

@property (nonatomic, nullable) UIColor *fillThemeColor;

@property (nonatomic, nullable) UIColor *strokeThemeColor;

@end

NS_ASSUME_NONNULL_END
