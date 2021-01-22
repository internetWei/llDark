//
//  YYLabel+Dark.m
//  LLDark <https://github.com/internetWei/llDark>
//
//  Created by LL on 2020/11/22.
//

#import <Foundation/Foundation.h>

#import "NSObject+Expand.h"
#import "LLDarkDefine.h"
#import "UIColor+Dark.h"
#import "NSMutableAttributedString+Refresh.h"
#import "NSMutableDictionary+Refresh.h"

@implementation NSObject (OtherThird)

/// YYLabel
- (void)refreshYYLabel {
    NSMutableAttributedString *attributedText = [[self ll_get:@"attributedText"] mutableCopy];
    LLUserInterfaceStyle userInterfaceStyle = [[self ll_performSelectorWithArgs:@selector(userInterfaceStyle)] integerValue];
    [attributedText refreshAttributes:userInterfaceStyle];
    [attributedText refreshYYAttributes:userInterfaceStyle];
    
    if (!ll_ObjectIsEmpty(attributedText)) {
        [self ll_set:@"setAttributedText:" withObject:attributedText];
    } else {
        UIColor *textColor = [self ll_get:@"color"];
        if (textColor.isTheme) {
            [self ll_set:@"setColor:" withObject:textColor.resolvedColor(userInterfaceStyle)];
        }
        
        UIColor *shadowColor = [self ll_get:@"shadowColor"];
        if (shadowColor.isTheme) {
            [self ll_set:@"setShadowColor:" withObject:shadowColor.resolvedColor(userInterfaceStyle)];
        }
    }
    
    
    NSMutableAttributedString *truncationToken = [[self ll_get:@"truncationToken"] mutableCopy];
    [truncationToken refreshAttributes:userInterfaceStyle];
    [truncationToken refreshYYAttributes:userInterfaceStyle];
    
    if (!ll_ObjectIsEmpty(truncationToken)) {
        [self ll_set:@"setTruncationToken:" withObject:truncationToken];
    }
}

/// YYTextView
- (void)refreshYYTextView {
    NSMutableAttributedString *attributedText = [[self ll_get:@"attributedText"] mutableCopy];
    LLUserInterfaceStyle userInterfaceStyle = [[self ll_performSelectorWithArgs:@selector(userInterfaceStyle)] integerValue];
    [attributedText refreshAttributes:userInterfaceStyle];
    [attributedText refreshYYAttributes:userInterfaceStyle];
    
    if (!ll_ObjectIsEmpty(attributedText)) {
        [self ll_set:@"setAttributedText:" withObject:attributedText];
    } else {
        UIColor *textColor = [self ll_get:@"textColor"];
        if (textColor.isTheme) {
            [self ll_set:@"setTextColor:" withObject:textColor.resolvedColor(userInterfaceStyle)];
        }
    }
    
    
    NSMutableAttributedString *placeholderAttributedText = [[self ll_get:@"placeholderAttributedText"] mutableCopy];
    [placeholderAttributedText refreshAttributes:userInterfaceStyle];
    [placeholderAttributedText refreshYYAttributes:userInterfaceStyle];
    
    if (!ll_ObjectIsEmpty(placeholderAttributedText)) {
        [self ll_set:@"setPlaceholderAttributedText:" withObject:placeholderAttributedText];
    } else {
        UIColor *placeholderTextColor = [self ll_get:@"placeholderTextColor"];
        if (placeholderTextColor.isTheme) {
            [self ll_set:@"setPlaceholderTextColor:" withObject:placeholderTextColor.resolvedColor(userInterfaceStyle)];
        }
    }
    
    
    NSMutableDictionary *linkTextAttributes = [[self ll_get:@"linkTextAttributes"] mutableCopy];
    [linkTextAttributes refreshAttributes:userInterfaceStyle];
    [linkTextAttributes refreshYYAttributes:userInterfaceStyle];
    
    if (!ll_ObjectIsEmpty(linkTextAttributes)) {
        [self ll_set:@"setLinkTextAttributes:" withObject:linkTextAttributes];
    }
    
    
    NSMutableDictionary *highlightTextAttributes = [[self ll_get:@"highlightTextAttributes"] mutableCopy];
    [highlightTextAttributes refreshAttributes:userInterfaceStyle];
    [highlightTextAttributes refreshYYAttributes:userInterfaceStyle];
    
    if (!ll_ObjectIsEmpty(highlightTextAttributes)) {
        [self ll_set:@"setHighlightTextAttributes:" withObject:highlightTextAttributes];
    }
    
    
    NSMutableDictionary *typingAttributes = [[self ll_get:@"typingAttributes"] mutableCopy];
    [typingAttributes refreshAttributes:userInterfaceStyle];
    [typingAttributes refreshYYAttributes:userInterfaceStyle];
    
    if (!ll_ObjectIsEmpty(typingAttributes)) {
        [self ll_set:@"setTypingAttributes:" withObject:typingAttributes];
    }
}

@end
