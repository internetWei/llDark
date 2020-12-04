//
//  CAGradientLayer+Dark.m
//  LLDark
//
//  Created by LL on 2020/11/19.
//

#import "CAGradientLayer+Dark.h"

#import <objc/runtime.h>

#import "UIColor+Dark.h"

static char * const ll_themeColors_identifier = "ll_themeColors_identifier";

@implementation CAGradientLayer (Dark)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setColors:)), class_getInstanceMethod(self, @selector(setThemeColors:)));
}

- (void)setThemeColors:(NSArray *)themeColors {
    NSMutableArray *t_arr = [NSMutableArray array];
    BOOL status = NO;
    for (UIColor *color in themeColors) {
        if ([color isKindOfClass:UIColor.class]) {
            [t_arr addObject:(id)color.CGColor];
            if (color.isTheme) {
                status = YES;
            }
        } else {
            [t_arr addObject:color];
        }
    }
    
    if (status) {
        objc_setAssociatedObject(self, &ll_themeColors_identifier, themeColors, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    [self setThemeColors:t_arr];
}

- (NSArray *)themeColors {
    return objc_getAssociatedObject(self, &ll_themeColors_identifier);
}

@end
