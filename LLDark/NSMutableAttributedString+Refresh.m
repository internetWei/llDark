//
//  NSMutableAttributedString+Dark.m
//  LLDark
//
//  Created by LL on 2020/11/18.
//

#import "NSMutableAttributedString+Refresh.h"

#import "UIColor+Dark.h"
#import "UIImage+Dark.h"
#import "LLDarkDefine.h"
#import "NSObject+Expand.h"
#import "CALayer+Refresh.h"
#import "UIView+Refresh.h"
#import "NSMutableDictionary+Refresh.h"

@implementation NSMutableAttributedString (Refresh)

- (void)refreshAttributes:(LLUserInterfaceStyle)userInterfaceStyle {
    if (ll_ObjectIsEmpty(self)) return;
    
    [self enumerateAttributesInRange:NSMakeRange(0, self.length) options:kNilOptions usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        
        for (NSString *key in attributedStringKey()) {
            id obj = [attrs objectForKey:key];
            
            if (!obj) continue;
            
            if ([obj isKindOfClass:UIColor.class]) {
                UIColor *color = (UIColor *)obj;
                if (color.isTheme) {
                    color = color.resolvedColor(userInterfaceStyle);
                    [self addAttribute:key value:color range:range];
                    if ([key isEqualToString:NSForegroundColorAttributeName]) {
                        [self addAttribute:(id)kCTForegroundColorAttributeName value:(id)color.CGColor range:range];
                    }
                }
                continue;
            }
            
            if ([obj isKindOfClass:NSShadow.class]) {
                NSShadow *shadow = (NSShadow *)obj;
                UIColor *shadowColor = shadow.shadowColor;
                if ([shadowColor isKindOfClass:UIColor.class] &&
                    shadowColor.isTheme) {
                    shadow.shadowColor = shadowColor.resolvedColor(userInterfaceStyle);
                    [self addAttribute:key value:shadow range:range];
                }
                continue;
            }
            
            if ([obj isKindOfClass:NSTextAttachment.class]) {
                NSTextAttachment *attachment = (NSTextAttachment *)obj;
                if (attachment.image.isTheme) {
                    attachment.image = attachment.image.resolvedImage(userInterfaceStyle);
                    [self addAttribute:key value:attachment range:range];
                }
                continue;
            }
        }        
    }];
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
    
    [self enumerateAttributesInRange:NSMakeRange(0, self.length) options:kNilOptions usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        for (NSString *key in yyAttributedStringKey()) {
            id obj = [attrs objectForKey:key];
            
            if (!obj) continue;
            
            Class yyTextDecoration = NSClassFromString(@"YYTextDecoration");
            if ([obj isKindOfClass:yyTextDecoration]) {
                UIColor *color = [obj ll_get:@"color"];
                if (color.isTheme) {
                    [obj ll_set:@"setColor:" withObject:color.resolvedColor(userInterfaceStyle)];
                }
                id textShadow = [obj ll_get:@"shadow"];
                [self refreshYYTextShadow:textShadow userInterfaceStyle:userInterfaceStyle];
                [self addAttribute:key value:obj range:range];
                continue;
            }
            
            Class yyTextShadow = NSClassFromString(@"YYTextShadow");
            if ([obj isKindOfClass:yyTextShadow]) {
                [self refreshYYTextShadow:obj userInterfaceStyle:userInterfaceStyle];
                [self addAttribute:key value:obj range:range];
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
                [self addAttribute:key value:obj range:range];
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
                
                [self addAttribute:key value:obj range:range];
                continue;
            }
            
            Class yyTextHighlight = NSClassFromString(@"YYTextHighlight");
            if ([obj isKindOfClass:yyTextHighlight]) {
                NSMutableDictionary<NSString *, id> *t_attributes = [[obj ll_get:@"attributes"] mutableCopy];
                [t_attributes refreshAttributes:userInterfaceStyle];
                [t_attributes refreshYYAttributes:userInterfaceStyle];
                [obj ll_set:@"setAttributes:" withObject:t_attributes];
                [self addAttribute:key value:obj range:range];
            }
        }
    }];
}

@end
