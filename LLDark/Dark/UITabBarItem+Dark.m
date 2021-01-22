//
//  UITabBarItem+Dark.m
//  LLDark <https://github.com/internetWei/llDark>
//
//  Created by LL on 2021/1/9.
//

#import "UITabBarItem+Dark.h"

#import <objc/runtime.h>

#import "UIImage+Dark.h"
#import "NSObject+Dark.h"

@implementation UITabBarItem (Dark)

+ (void)load {
    self.methodExchange(@selector(setSelectedImage:), @selector(ll_setSelectedImage:));
}

- (void)ll_setSelectedImage:(UIImage *)image {
    [self ll_setSelectedImage:image];
    if (image.isTheme) {
        self.selectedDarkImage = image;
    }
}

- (void)setSelectedDarkImage:(UIImage *)selectedDarkImage {
    objc_setAssociatedObject(self, @selector(selectedDarkImage), selectedDarkImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)selectedDarkImage {
    return objc_getAssociatedObject(self, @selector(selectedDarkImage));
}

@end
