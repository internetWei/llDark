//
//  OttoFPSButton.h
//  OttoFPSButtonDemo
//
//  Created by Otto on 2018/4/11.
//  Copyright © 2018年 otto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OttoFPSButton : UIButton

+ (instancetype)setTouchWithFrame:(CGRect)frame
                       titleFont:(UIFont *)titleFont
                 backgroundColor:(UIColor *)backgroundColor
                 backgroundImage:(UIImage *)backgroundImage;

@end
