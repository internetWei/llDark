//
//  NSMutableDictionary+Dark.h
//  LLDark <https://github.com/internetWei/llDark>
//
//  Created by LL on 2020/11/18.
//

#import <Foundation/Foundation.h>

#import "LLDarkConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (Refresh)

- (void)refreshAttributes:(LLUserInterfaceStyle)userInterfaceStyle;

- (void)refreshYYAttributes:(LLUserInterfaceStyle)userInterfaceStyle;

@end

NS_ASSUME_NONNULL_END
