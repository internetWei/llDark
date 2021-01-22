//
//  UIImage+Dark.m
//  LLDark <https://github.com/internetWei/llDark>
//
//  Created by LL on 2020/11/17.
//

#import "UIImage+Dark.h"

#import <objc/runtime.h>

#import "LLDarkDefine.h"
#import "LLDarkSource.h"

static NSString * const llDark_imageAssets_identifer = @"llDark_imageAssets_identifer";
static NSString * const llDark_imageFiles_identifer = @"llDark_imageFiles_identifer";
static NSString * const llDark_imageNameFiles_identifer = @"llDark_imageNameFiles_identifer";

@interface UIImage ()

@property (nonatomic) NSString *lightImageName;

@property (nonatomic) NSString *darkImageName;

/// Assets图片集合
@property (nonatomic, class, readonly) NSMutableSet<NSString *> *imageAssets;

/// Files图片集合
@property (nonatomic, class, readonly) NSMutableSet<NSString *> *imageFiles;

/// 一个字典，key是图片名称，value是图片对应相对路径
@property (nonatomic, class, readonly) NSMutableDictionary<NSString *, NSString *> *imageNameFiles;

@end

@implementation UIImage (Dark)

+ (void)load {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(synchronizeData) name:UIApplicationWillResignActiveNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(synchronizeData) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

+ (void)initialize {
#ifndef DEBUG
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *old_app_version = [NSUserDefaults.standardUserDefaults objectForKey:@"llDark_old_app_version"];
    
    if ([old_app_version isEqualToString:app_version] == NO) {
        [NSUserDefaults.standardUserDefaults removeObjectForKey:llDark_imageAssets_identifer];
        [NSUserDefaults.standardUserDefaults removeObjectForKey:llDark_imageFiles_identifer];
        [NSUserDefaults.standardUserDefaults removeObjectForKey:llDark_imageNameFiles_identifer];
        
        [NSUserDefaults.standardUserDefaults setObject:app_version forKey:@"llDark_old_app_version"];
    }
#endif
}

- (UIImage *)removeTheme {
    if (!self.isTheme) return self;
    return UIImage.imageNamed(self.lightImageName);
}

+ (UIImage * _Nullable (^)(NSString * _Nonnull, NSString * _Nullable))themeImage {
    return ^(NSString *lightImageName, NSString * _Nullable darkImageName) {
        if (ll_ObjectIsEmpty(lightImageName)) return (id)nil;
                
        if (!darkImageName) darkImageName = LLDarkSource.darkImageForKey(lightImageName);
        
        if (!darkImageName) {
            return (id)UIImage.imageNamed(lightImageName);
        }
        
        return (id)UIImage.dynamicThemeRenderingModeImage(lightImageName, darkImageName, UIImageRenderingModeAlwaysOriginal);
    };
}

+ (UIImage *)themeImage:(NSString *)lightImageName {
    return UIImage.themeImage(lightImageName, nil);
}

+ (UIImage * _Nullable (^)(NSString * _Nonnull, NSString * _Nonnull, UIImageRenderingMode))dynamicThemeRenderingModeImage {
    return ^(NSString *lightImage, NSString *darkImage, UIImageRenderingMode renderingMode) {
        NSString *imageName = correctObj(lightImage, darkImage);
        
        UIImage *image = [self _imageNamed:imageName origin:@[lightImage, darkImage]];
        image.lightImageName = lightImage;
        image.darkImageName = darkImage;
        
        if (!image) return (id)nil;
        return (id)image.renderingModeFrom(renderingMode);
    };
}

+ (UIImage * _Nullable (^)(NSString * _Nonnull))imageNamed {
    return ^(NSString *imageName) {
        return (id)[UIImage _imageNamed:imageName origin:nil];
    };
}

+ (nullable UIImage *)_imageNamed:(NSString *)imageName origin:(nullable NSArray<NSString *> *)imageNames {
    if (![imageName isKindOfClass:NSString.class]) return (id)nil;

    if (imageName.length == 0) return (id)nil;

    // 判断之前是否加载过
    if ([UIImage.imageAssets containsObject:imageName]) {
        return (id)[UIImage imageNamed:imageName];
    }

    if ([UIImage.imageFiles containsObject:imageName]) {
        return (id)[UIImage _imageOfFile:imageName orign:imageNames];
    }

    UIImage *image = [UIImage _imageOfFile:imageName orign:imageNames];
    if (image) {
        [UIImage.imageFiles addObject:imageName];
    } else {
        image = [UIImage imageNamed:imageName];
        [UIImage.imageAssets addObject:imageName];
    }

    if (image) {
        image = image.renderingModeFrom(UIImageRenderingModeAlwaysOriginal);
    }
    return (id)image;
}

+ (nullable UIImage *)_imageOfFile:(NSString *)imageName orign:(nullable NSArray<NSString *> *)imageNames {
    NSString *imageFilePath = UIImage.imageFilePath(imageName);
    
    /// 判断是否需要使用缓存对象
    if (imageNames.count > 1) {
        UIImage *cacheImage = [imageCache() objectForKey:imageFilePath];
        if (!cacheImage) [imageCache() objectForKey:imageName];
        if (cacheImage) {
            NSString *cacheLightImageName = cacheImage.lightImageName;
            NSString *cacheDarkImageName = cacheImage.darkImageName;
            if ([cacheLightImageName isEqualToString:imageNames.firstObject] &&
                [cacheDarkImageName isEqualToString:imageNames[1]]) {
                return cacheImage;
            }
        }
    }
    
    BOOL successful = YES;
    UIImage *localImage = [UIImage imageWithContentsOfFile:imageFilePath];
    /// 尝试直接加载图片名称(图片名称可能是路径)
    if (!localImage) {
        successful = NO;
        localImage = [UIImage imageWithContentsOfFile:imageName];
    }
    if (!localImage) return (id)nil;
    
    localImage = localImage.renderingModeFrom(UIImageRenderingModeAlwaysOriginal);
    if (localImage) {
        if (imageNames.count > 1) {
            localImage.lightImageName = imageNames.firstObject;
            localImage.darkImageName = imageNames[1];
        }
        [imageCache() setObject:localImage forKey:successful ? imageFilePath : imageName cost:imageCost(localImage)];
    }
    return (id)localImage;
}

/// 根据图片名称获取图片完整路径
+ (NSString * _Nullable (^) (NSString *imageName))imageFilePath {
    return ^(NSString *imageName) {
        if (imageName.length == 0 ||
            [imageName hasPrefix:@"/"]) return (id)nil;
        
        // 判断之前是不是获取过
        if ([UIImage.imageNameFiles objectForKey:imageName]) {
            NSString *imageFullName = [self.imageNameFiles objectForKey:imageName];
            return (id)[NSBundle.mainBundle pathForResource:imageFullName ofType:nil];
        }
        
        NSString *res = imageName.stringByDeletingPathExtension;
        NSString *ext = imageName.pathExtension;
        NSString *path = nil;
        CGFloat scale = 1;
        
        // 如果没有扩展名，通过系统支持的类型进行猜测(与UIImage相同)
        NSArray *exts = ext.length > 0 ? @[ext] : @[@"", @"png", @"jpeg", @"jpg", @"gif", @"webp", @"apng", @"ktx"];
        NSArray<NSNumber *> *scales = preferredScales();
        
        for (NSNumber *obj in scales) {
            scale = obj.integerValue;
            NSString *scaleName = ({
                NSString *scaleName = [res stringByAppendingFormat:@"@%@x", @(scale)];
                if (res.length == 0 || [res hasPrefix:@"/"]) scaleName = res;
                scaleName;
            });
            for (NSString *ext in exts) {
                path = [[NSBundle mainBundle] pathForResource:scaleName ofType:ext];
                if (path) break;
            }
            if (path) break;
        }
        
        if (!path) {
            for (NSString *obj in exts) {
                path = [[NSBundle mainBundle] pathForResource:res ofType:obj];
                if (path) break;
            }
        }
        
        if (path) [UIImage.imageNameFiles setObject:[path lastPathComponent] forKey:imageName];
        
        return (id)path;
    };
}

- (UIImage * _Nonnull (^)(UIImageRenderingMode))renderingModeFrom {
    return ^(UIImageRenderingMode model) {
        if (self.renderingMode == model) return self;
        UIImage *image = [self imageWithRenderingMode:model];
        image.lightImageName = self.lightImageName;
        image.darkImageName = self.darkImageName;
        return image;
    };
}

- (void)darkImage:(void (^)(UIImage * _Nonnull))complete saturation:(CGFloat)value {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        CIImage *beginImage = [CIImage imageWithCGImage:self.CGImage];
        CIFilter * filter = [CIFilter filterWithName:@"CIColorControls"];
        [filter setValue:beginImage forKey:kCIInputImageKey];
        // 饱和度 0---2 默认为1
        [filter setValue:[NSNumber numberWithFloat:value] forKey:@"inputSaturation"];
        // 得到过滤后的图片
        CIImage *outputImage = [filter outputImage];
        // 转换图片, 创建基于GPU的CIContext对象
        CIContext *context = [CIContext contextWithOptions: nil];
        CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
        UIImage *newImg = [UIImage imageWithCGImage:cgimg];
        newImg.lightImageName = self.lightImageName;
        newImg.darkImageName = self.darkImageName;
        CGImageRelease(cgimg);
        dispatch_async(dispatch_get_main_queue(), ^{        
            !complete ?: complete(newImg);
        });
    });
}


#pragma mark - setter/getter
- (void)setLightImageName:(NSString *)lightImageName {
    objc_setAssociatedObject(self, @selector(lightImageName), lightImageName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)lightImageName {
    return objc_getAssociatedObject(self, @selector(lightImageName));
}

- (void)setDarkImageName:(NSString *)darkImageName {
    objc_setAssociatedObject(self, @selector(darkImageName), darkImageName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)darkImageName {
    NSString *darkImageName = objc_getAssociatedObject(self, @selector(darkImageName));
    if (darkImageName) return darkImageName;
    
    // 从深色图片资源中获取对应图片名称
    darkImageName = LLDarkSource.darkImageForKey(darkImageName);
    if (darkImageName) {
        self.darkImageName = darkImageName;
        return darkImageName;
    }
    
    // 返回浅色模式下的图片名称
    return self.lightImageName;
}

- (BOOL)isTheme {
    return (self.lightImageName != nil);
}

- (UIImage * _Nonnull (^)(LLUserInterfaceStyle))resolvedImage {
    return ^(LLUserInterfaceStyle userInterfaceStyle) {
        if (userInterfaceStyle == LLUserInterfaceStyleUnspecified) {
            return UIImage.dynamicThemeRenderingModeImage(self.lightImageName, self.darkImageName, self.renderingMode);
        } else if (userInterfaceStyle == LLUserInterfaceStyleLight) {
            return UIImage.imageNamed(self.lightImageName);
        } else {
            return UIImage.imageNamed(self.darkImageName);
        }
    };
}


/// 获取图片上某个点的颜色值(不包含alpha)。
- (nullable NSArray<NSNumber *> *)pixelColorFromPoint:(CGPoint)point {
    // 判断点是否超出图像范围
    if (!CGRectContainsPoint(CGRectMake(0, 0, self.size.width, self.size.height), point)) return nil;
    
    // 将像素绘制到一个1×1像素字节数组和位图上下文。
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = self.CGImage;
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = {0, 0, 0, 0};
    CGContextRef context = CGBitmapContextCreate(pixelData, 1, 1, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // 将指定像素绘制到上下文中
    CGContextTranslateCTM(context, -pointX, pointY - height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), cgImage);
    CGContextRelease(context);
    
    CGFloat red = (CGFloat)pixelData[0];
    CGFloat green = (CGFloat)pixelData[1];
    CGFloat blue = (CGFloat)pixelData[2];
    return @[@(red), @(green), @(blue)];
}

- (BOOL)hasDarkImage {
    // 获取图片右上角1×1像素点的颜色值。
    NSArray<NSNumber *> *RGBArr = [self pixelColorFromPoint:CGPointMake(self.size.width - 1, 1)];
    
    CGFloat max = [RGBArr.firstObject floatValue];
    
    // 找到颜色的最大值
    for (NSNumber *number in RGBArr) {
        if (max < [number floatValue]) {
            max = [number floatValue];
        }
    }
    
    // 判断如果其他颜色小于最大值且差值在10以内则是暗色，并且最大值需小于190。
    if (max >= 190) {
        return NO;
    }
    
    for (NSNumber *number in RGBArr) {
        if ([number floatValue] + 10 < max) {
            return NO;
        }
    }
    
    return YES;
}


+ (NSMutableSet<NSString *> *)imageAssets {
    static NSMutableSet<NSString *> *_imageAssets = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *t_arry = [NSUserDefaults.standardUserDefaults objectForKey:llDark_imageAssets_identifer];
        _imageAssets = [NSMutableSet setWithArray:t_arry];
    });
    return _imageAssets;
}


+ (NSMutableSet<NSString *> *)imageFiles {
    static NSMutableSet<NSString *> *_imageFiles = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *t_arry = [NSUserDefaults.standardUserDefaults objectForKey:llDark_imageFiles_identifer];
        _imageFiles = [NSMutableSet setWithArray:t_arry];
    });
    return _imageFiles;
}


+ (NSMutableDictionary<NSString *,NSString *> *)imageNameFiles {
    static NSMutableDictionary<NSString *, NSString *> *_imageNameFiles = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *t_dict = [NSUserDefaults.standardUserDefaults objectForKey:llDark_imageNameFiles_identifer];
        _imageNameFiles = [NSMutableDictionary dictionaryWithDictionary:t_dict];
    });
    return _imageNameFiles;
}

+ (void)synchronizeData {
#ifndef DEBUG
    [NSUserDefaults.standardUserDefaults setObject:UIImage.imageAssets.allObjects forKey:llDark_imageAssets_identifer];
    [NSUserDefaults.standardUserDefaults setObject:UIImage.imageFiles.allObjects forKey:llDark_imageFiles_identifer];
    [NSUserDefaults.standardUserDefaults setObject:UIImage.imageNameFiles.copy forKey:llDark_imageNameFiles_identifer];
#endif
}


NSArray<NSNumber *> * preferredScales(void) {
    static NSArray<NSNumber *> *scales = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat screenScale = [UIScreen mainScreen].scale;
        if (screenScale <= 1) {
            scales = @[@1, @2, @3];
        } else if (screenScale <= 2) {
            scales = @[@2, @3, @1];
        } else {
            scales = @[@3, @2, @1];
        }
    });
    return scales;
}

- (UIImage *)resizeImageWithDirection:(BOOL)vertical {
    CGSize imageSize = CGSizeApplyAffineTransform(self.size,
                                                  CGAffineTransformMakeScale(self.scale, self.scale));
    CGSize contextSize = [self contextSizeForPortrait:vertical];
    
    if (!CGSizeEqualToSize(imageSize, contextSize)) {
        UIGraphicsBeginImageContext(contextSize);
        CGFloat ratio = MAX((contextSize.width / self.size.width),
                            (contextSize.height / self.size.height));
        CGRect rect = CGRectMake(0, 0, self.size.width * ratio, self.size.height * ratio);
        [self drawInRect:rect];
        UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return resizedImage;
    }
    
    return self;
}

- (CGSize)contextSizeForPortrait:(BOOL)isPortrait {
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat width = MIN(screenSize.width, screenSize.height);;
    CGFloat height = MAX(screenSize.width, screenSize.height);
    if (!isPortrait) {
        width = MAX(screenSize.width, screenSize.height);
        height = MIN(screenSize.width, screenSize.height);
    }
    CGSize contextSize = CGSizeMake(width * screenScale, height * screenScale);
    return contextSize;
}

@end
