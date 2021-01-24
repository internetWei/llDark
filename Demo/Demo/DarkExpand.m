//
//  Foundation.m
//  LLDark <https://github.com/internetWei/llDark>
//
//  Created by LL on 2020/12/2.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kColorRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define kColorRGB(r,g,b) kColorRGBA(r,g,b,1.0)

@implementation NSObject(Dark)
+ (NSDictionary<id, id> *)llDarkTheme {
    return @{
             kColorRGB(27, 27, 27) : UIColor.whiteColor,
             UIColor.whiteColor : kColorRGB(27, 27, 27),
             kColorRGB(240, 238, 245) : kColorRGB(39, 39, 39),
             kColorRGB(57, 56, 60) : kColorRGBA(255, 255, 255, 0.87),
             kColorRGB(176, 176, 176) : kColorRGBA(255, 255, 255, 0.6),
             kColorRGB(57, 56, 60) : kColorRGB(255, 255, 255),
             kColorRGB(241, 242, 241) : kColorRGB(39, 39, 39),
             kColorRGB(77, 77, 75) : kColorRGBA(255, 255, 255, 0.38),
             @"background_light" : @"background_dark",
             @"durk_light" : @"durk_dark",
    };
}

@end
