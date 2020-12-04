//
//  LLDark.h
//  LLDark
//
//  Created by LL on 2020/11/17.
//

#ifndef LLDark_h
#define LLDark_h

//! Project version number for Masonry.
FOUNDATION_EXPORT double LLDarkVersionNumber;

//! Project version string for Masonry.
FOUNDATION_EXPORT const unsigned char LLDarkVersionString[];

#if __has_include(<LLDark.h>)

#import <LLDarkManager.h>
#import <UIImageView+Dark.h>
#import <NSObject+Dark.h>
#import <UIColor+Dark.h>
#import <UIImage+Dark.h>
#import <UIView+Dark.h>
#import <LLDarkSource.h>

#else

#import "LLDarkManager.h"
#import "UIImageView+Dark.h"
#import "NSObject+Dark.h"
#import "UIColor+Dark.h"
#import "UIImage+Dark.h"
#import "UIView+Dark.h"
#import "LLDarkSource.h"

#endif

#endif /* LLDark_h */
