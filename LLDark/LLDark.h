//
//  LLDark.h
//  LLDark <https://github.com/internetWei/llDark>
//
//  Created by LL on 2020/11/17.
//

#ifndef LLDark_h
#define LLDark_h

#import <Foundation/Foundation.h>

#if __has_include(<LLDark/LLDark.h>)

FOUNDATION_EXPORT double LLDarkVersionNumber;
FOUNDATION_EXPORT const unsigned char LLDarkVersionString[];

#import <LLDark/LLDarkManager.h>
#import <LLDark/UIImageView+Dark.h>
#import <LLDark/NSObject+Dark.h>
#import <LLDark/UIColor+Dark.h>
#import <LLDark/UIImage+Dark.h>
#import <LLDark/UIView+Dark.h>
#import <LLDark/LLDarkSource.h>
#import <LLDark/LLLaunchScreen.h>

#import <LLDark/LLDarkWindow.h>
#import <LLDark/NSObject+Expand.h>
#import <LLDark/CALayer+Refresh.h>
#import <LLDark/NSMutableAttributedString+Refresh.h>
#import <LLDark/NSMutableDictionary+Refresh.h>
#import <LLDark/NSObject+Refresh.h>
#import <LLDark/UIView+Refresh.h>
#import <LLDark/CAGradientLayer+Dark.h>
#import <LLDark/CALayer+Dark.h>
#import <LLDark/CAShapeLayer+Dark.h>
#import <LLDark/CATextLayer+Dark.h>
#import <LLDark/UITabBarItem+Dark.h>
#import <LLDark/LLDarkDefine.h>

#else

#import "LLDarkManager.h"
#import "UIImageView+Dark.h"
#import "NSObject+Dark.h"
#import "UIColor+Dark.h"
#import "UIImage+Dark.h"
#import "UIView+Dark.h"
#import "LLDarkSource.h"
#import "LLLaunchScreen.h"

#import "LLDarkWindow.h"
#import "NSObject+Expand.h"
#import "CALayer+Refresh.h"
#import "NSMutableAttributedString+Refresh.h"
#import "NSMutableDictionary+Refresh.h"
#import "NSObject+Refresh.h"
#import "UIView+Refresh.h"
#import "CAGradientLayer+Dark.h"
#import "CALayer+Dark.h"
#import "CAShapeLayer+Dark.h"
#import "CATextLayer+Dark.h"
#import "UITabBarItem+Dark.h"
#import "LLDarkDefine.h"

#endif

#endif /* LLDark_h */
