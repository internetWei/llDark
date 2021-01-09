//
//  UITabBarItem+Dark.m
//  LLDark
//
//  Created by LL on 2021/1/9.
//

#import "UITabBarItem+Dark.h"

#import <objc/runtime.h>

#import "UIImage+Dark.h"

@implementation UITabBarItem (Dark)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setSelectedImage:)), class_getInstanceMethod(self, @selector(ll_setSelectedImage:)));
}

- (void)ll_setSelectedImage:(UIImage *)image {
    if (image.isTheme) {
        self.selectedDarkImage = image;
    }
    [self ll_setSelectedImage:image];
}

- (void)setSelectedDarkImage:(UIImage *)selectedDarkImage {
    objc_setAssociatedObject(self, @selector(selectedDarkImage), selectedDarkImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)selectedDarkImage {
    return objc_getAssociatedObject(self, @selector(selectedDarkImage));
}

@end
