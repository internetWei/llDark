//
//  CAGradientLayer+Dark.m
//  LLDark <https://github.com/internetWei/llDark>
//
//  Created by LL on 2020/11/19.
//

#import "CAGradientLayer+Dark.h"

#import <objc/runtime.h>

#import "UIColor+Dark.h"
#import "NSObject+Dark.h"

@implementation CAGradientLayer (Dark)

+ (void)load {
    self.methodExchange(@selector(setColors:), @selector(setThemeColors:));
}

- (void)setThemeColors:(NSArray *)themeColors {
    NSMutableArray *t_arr = [NSMutableArray array];
    BOOL isThemeColor = NO;
    for (UIColor *color in themeColors) {
        if ([color isKindOfClass:UIColor.class]) {
            [t_arr addObject:(id)color.CGColor];
            if (color.isTheme) isThemeColor = YES;
        } else {
            [t_arr addObject:color];
        }
    }
    
    if (isThemeColor == YES) {
        objc_setAssociatedObject(self, @selector(themeColors), themeColors, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    [self setThemeColors:t_arr];
}

- (NSArray *)themeColors {
    return objc_getAssociatedObject(self, @selector(themeColors));
}

@end
