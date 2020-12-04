//
//  NSObject+DarkExpand.m
//  LLDark_Example
//
//  Created by LL on 2020/12/4.
//  Copyright © 2020 xianglong.wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@implementation NSObject (DarkExpand)

+ (NSDictionary<id, id> *)llDarkTheme {
    return @{
            [UIColor colorWithRed:27.0 / 255.0 green:27.0 / 255.0 blue:27.0 / 255.0 alpha:1.0] : UIColor.whiteColor,
             UIColor.whiteColor : [UIColor colorWithRed:27.0 / 255.0 green:27.0 / 255.0 blue:27.0 / 255.0 alpha:1.0],
            
            [UIColor colorWithRed:240 / 255.0 green:238 / 255.0 blue:245 / 255.0 alpha:1.0] : [UIColor colorWithRed:39 / 255.0 green:39 / 255.0 blue:39 /255.0 alpha:1.0],
            [UIColor colorWithRed:57 / 255.0 green:56 / 255.0 blue:60 / 255.0 alpha:1.0] : [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.87],
            [UIColor colorWithRed:176 / 255.0 green:176 / 255.0 blue:176 / 255.0 alpha:1.0] : [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.6],
            [UIColor colorWithRed:241 / 255.0 green:252 / 255.0 blue:241 / 255.0 alpha:0.87] : [UIColor colorWithRed:39 / 255.0 green:39 / 255.0 blue:39 / 255.0 alpha:1.0],
            [UIColor colorWithRed:77 / 255.0 green:77 / 255.0 blue:75 / 255.0 alpha:0.87] : [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.38],
             @"background_light" : @"background_dark",
             @"durk_light" : @"durk_dark",
    };
}

+ (NSArray<NSString *> *)thirdControlClassName {
    /*
     在这里返回需要适配的第3方UI控件，如果返回了UI控件,
     则一定要实现对应的刷新方法，方法名为refresh+控件类名,
     例如这里返回了@"TYAttributedLabel"，则一定要实现refreshTYAttributedLabel这个方法,
     LLDark已经实现了YYLabel和YYTextView的刷新，可以在LLThird.m找到YYLabel的刷新逻辑并参考。
     */
    return @[];
}

@end
