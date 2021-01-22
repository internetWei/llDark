//
//  NSMutableDictionary+Dark.m
//  LLDark <https://github.com/internetWei/llDark>
//
//  Created by LL on 2020/11/18.
//

#import "NSMutableDictionary+Refresh.h"

#import "LLDarkDefine.h"
#import "UIColor+Dark.h"
#import "UIImage+Dark.h"
#import "NSObject+Expand.h"
#import "UIView+Refresh.h"
#import "CALayer+Refresh.h"

@implementation NSMutableDictionary (Refresh)

- (void)refreshAttributes:(LLUserInterfaceStyle)userInterfaceStyle {
    if (ll_ObjectIsEmpty(self)) return;
    
    for (NSString *key in attributedStringKey()) {
        id value = [self objectForKey:key];
        
        if (!value) continue;
        
        if ([value isKindOfClass:UIColor.class]) {
            UIColor *color = (UIColor *)value;
            if (color.isTheme) {
                color = color.resolvedColor(userInterfaceStyle);
                [self setValue:color forKey:key];
            }
            continue;
        }
        
        if ([value isKindOfClass:NSShadow.class]) {
            NSShadow *shadow = (NSShadow *)value;
            UIColor *shadowColor = shadow.shadowColor;
            if ([shadowColor isKindOfClass:UIColor.class] &&
                shadowColor.isTheme) {
                shadow.shadowColor = shadowColor.resolvedColor(userInterfaceStyle);
                [self setValue:shadow forKey:key];
            }
            continue;
        }
        
        if ([value isKindOfClass:NSTextAttachment.class]) {
            NSTextAttachment *attachment = (NSTextAttachment *)value;
            if (attachment.image.isTheme) {
                attachment.image = attachment.image.resolvedImage(userInterfaceStyle);
                [self setValue:attachment forKey:key];
            }
            continue;
        }
    }
}

- (void)refreshYYTextShadow:(id)textShadow userInterfaceStyle:(LLUserInterfaceStyle)userInterfaceStyle {
    Class yyTextShadow = NSClassFromString(@"YYTextShadow");
    if (![textShadow isKindOfClass:yyTextShadow]) return;
    
    UIColor *color = [textShadow ll_get:@"color"];
    if (color.isTheme) {
        [textShadow ll_set:@"setColor:" withObject:color.resolvedColor(userInterfaceStyle)];
    }
    id subTextShadow = [textShadow ll_get:@"subShadow"];
    color = [subTextShadow ll_get:@"color"];
    if (color.isTheme) {
        [subTextShadow ll_set:@"setColor:" withObject:color.resolvedColor(userInterfaceStyle)];
    }
}

- (void)refreshYYAttributes:(LLUserInterfaceStyle)userInterfaceStyle {
    if (ll_ObjectIsEmpty(self)) return;
    
    for (NSString *key in yyAttributedStringKey()) {
        id obj = [self objectForKey:key];
        
        if (!obj) continue;
        
        Class yyTextDecoration = NSClassFromString(@"YYTextDecoration");                
        if ([obj isKindOfClass:yyTextDecoration]) {
            UIColor *color = [self ll_get:@"color"];
            if (color.isTheme) {
                [obj ll_set:@"setColor:" withObject:color.resolvedColor(userInterfaceStyle)];
            }
            id textShadow = [obj ll_get:@"shadow"];
            [self refreshYYTextShadow:textShadow userInterfaceStyle:userInterfaceStyle];
            [self setObject:obj forKey:key];
            continue;
        }
        
        Class yyTextShadow = NSClassFromString(@"YYTextShadow");
        if ([obj isKindOfClass:yyTextShadow]) {
            [self refreshYYTextShadow:obj userInterfaceStyle:userInterfaceStyle];
            [self setObject:obj forKey:key];
            continue;
        }
        
        Class yyTextBorder = NSClassFromString(@"YYTextBorder");
        if ([obj isKindOfClass:yyTextBorder]) {
            UIColor *fillColor = [obj ll_get:@"fillColor"];
            if (fillColor.isTheme) {
                [obj ll_set:@"setFillColor:" withObject:fillColor.resolvedColor(userInterfaceStyle)];
            }
            UIColor *strokeColor = [obj ll_get:@"strokeColor"];
            if (strokeColor.isTheme) {
                [obj ll_set:@"setStrokeColor:" withObject:strokeColor.resolvedColor(userInterfaceStyle)];
            }
            id textShadow = [obj ll_get:@"shadow"];
            [self refreshYYTextShadow:textShadow userInterfaceStyle:userInterfaceStyle];
            [self setObject:obj forKey:key];
            continue;
        }
        
        
        Class yyYYTextAttachment = NSClassFromString(@"YYTextAttachment");
        if ([obj isKindOfClass:yyYYTextAttachment]) {
            id content = [obj ll_get:@"content"];
            
            if ([content isKindOfClass:UIImage.class]) {
                UIImage *image = (UIImage *)content;
                if (image.isTheme) {
                    [obj ll_set:@"setContent:" withObject:image.resolvedImage(userInterfaceStyle)];
                }
            } else if ([content isKindOfClass:CALayer.class]) {
                CALayer *layer = (CALayer *)content;
                [layer refresh];
                [obj ll_set:@"setContent:" withObject:layer];
            } else if ([content isKindOfClass:UIView.class]) {
                UIView *view = (UIView *)content;
                [view refresh];
                [obj ll_set:@"setContent:" withObject:view];
            }
            
            [self setObject:obj forKey:key];
            continue;
        }
    }
}

@end
