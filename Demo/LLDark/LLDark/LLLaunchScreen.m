//
//  LLLaunchScreen.m
//  LLDarkTheme
//
//  Created by LL on 2020/11/17.
//

#import "LLLaunchScreen.h"

#import "LLDarkDefine.h"
#import "LLDarkManager.h"

static NSString * const ll_launchScreen_mapping_identifier = @"ll_launchScreen_mapping_identifier";

@interface LLLaunchScreen ()

/**
 启动图映射表
 
 @"dark_vertial" : @"深色竖屏启动图"
 
 @"dark_horizaton" : @"深色横屏启动图"
 
 @"light_vertial" : @"浅色竖屏启动图"
 
 @"light_horizaton" : @浅色横屏启动图""
 */
@property (nonatomic, class, readonly) NSDictionary<NSString *, NSString *> *mappingTable;

/// lauchScreen副本文件夹路径
@property (nonatomic, class, readonly) NSString *launchScreenCopyDirectory;

/// lauchScreen文件夹路径
@property (nonatomic, class, readonly) NSString *launchScreenDirectory;

@end

@implementation LLLaunchScreen

+ (void)modifyLaunchScreen {
    
    /// iOS13以下启动图文件夹无权限访问
    if (@available(iOS 13.0, *)) {
        NSDictionary<NSString *, NSString *> *mappingTable = _mappingTable;
        
        // 当前主题是“跟随系统”，将启动图恢复为初始状态。
        if (LLDarkManager.userInterfaceStyle == LLUserInterfaceStyleUnspecified) {
            for (NSString *identifier in mappingTable) {
                NSString *imageName = [mappingTable objectForKey:identifier];
                // 副本中的启动图路径
                NSString *copy_fullPath = [self.launchScreenCopyDirectory stringByAppendingPathComponent:imageName];
                // 系统启动图路径
                NSString *fullPath = [self.launchScreenDirectory stringByAppendingPathComponent:imageName];
                [self copyItemAtPath:copy_fullPath toPath:fullPath];
            }
            return;
        }
        
        // 当前主题是“浅色主题”，将本地所有启动图都更改为浅色启动图(名称不变)。
        if (LLDarkManager.userInterfaceStyle == LLUserInterfaceStyleLight) {
            // 副本中浅色竖屏启动图的路径
            NSString *copy_light_vertial_fullPath = ({
                NSString *imageName = [mappingTable objectForKey:@"light_vertial"];
                [self.launchScreenCopyDirectory stringByAppendingPathComponent:imageName];
            });
            
            // 副本中浅色横屏启动图的路径
            NSString *copy_light_horizaton_fullPath = ({
                NSString *imageName = [mappingTable objectForKey:@"light_horizaton"];
                [self.launchScreenCopyDirectory stringByAppendingPathComponent:imageName];
            });
            
            [self replaceWithOrigin:copy_light_vertial_fullPath identifier1:@"light_vertial" identifier2:@"dark_vertial"];
            [self replaceWithOrigin:copy_light_horizaton_fullPath identifier1:@"light_horizaton" identifier2:@"dark_horizaton"];
            
            return;
        }
        
        // 当前主题是“深色主题”，将本地所有启动图更改为深色启动图(名称不变)。
        if (LLDarkManager.userInterfaceStyle == LLUserInterfaceStyleDark) {
            // 副本中深色竖屏启动图的路径
            NSString *copy_dark_vertial_fullPath = ({
                NSString *imageName = [mappingTable objectForKey:@"dark_vertial"];
                [self.launchScreenCopyDirectory stringByAppendingPathComponent:imageName];
            });
            
            // 副本中深色横屏启动图的路径
            NSString *copy_dark_horizaton_fullPath = ({
                NSString *imageName = [mappingTable objectForKey:@"dark_horizaton"];
                [self.launchScreenCopyDirectory stringByAppendingPathComponent:imageName];
            });
            
            [self replaceWithOrigin:copy_dark_vertial_fullPath identifier1:@"light_vertial" identifier2:@"dark_vertial"];
            [self replaceWithOrigin:copy_dark_horizaton_fullPath identifier1:@"light_horizaton" identifier2:@"dark_horizaton"];
            
            return;
        }
    }
}

+ (void)replaceWithOrigin:(NSString *)originPath identifier1:(NSString *)identifier1 identifier2:(NSString *)identifier2 {
    NSString *name1 = [_mappingTable objectForKey:identifier1];
    NSString *name2 = [_mappingTable objectForKey:identifier2];
    
    NSString *fullPath1 = [self.launchScreenDirectory stringByAppendingPathComponent:name1];
    NSString *fullPath2 = [self.launchScreenDirectory stringByAppendingPathComponent:name2];
    
    [self copyItemAtPath:originPath toPath:fullPath1];
    [self copyItemAtPath:originPath toPath:fullPath2];
}

+ (void)initialization {
    if (@available(iOS 13.0, *)) {
        [self mappingTable];
    }
}

static NSDictionary<NSString *,NSString *> * _mappingTable;
+ (NSDictionary<NSString *, NSString *> *)mappingTable {
    if (!_mappingTable) {
        _mappingTable = [NSUserDefaults.standardUserDefaults objectForKey:ll_launchScreen_mapping_identifier];
        BOOL isExist = [NSFileManager.defaultManager fileExistsAtPath:self.launchScreenCopyDirectory];
        if (!_mappingTable ||
            !isExist) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                _mappingTable = [self generateMappingTable];
                [NSUserDefaults.standardUserDefaults setObject:_mappingTable forKey:ll_launchScreen_mapping_identifier];
            });
        }
    }
    return _mappingTable;
}

/// 将指定路径上的文件内容覆盖到新位置。
+ (void)copyItemAtPath:(NSString *)srcPath toPath:(NSString *)dtsPath {
    // 判断原路径是否存在，防止误删现有的启动图。
    if ([NSFileManager.defaultManager fileExistsAtPath:srcPath]) {
        NSData *data = [NSData dataWithContentsOfFile:srcPath];
        [data writeToFile:dtsPath atomically:YES];
    }
}

/// 生成启动图映射表
+ (NSDictionary<NSString *, NSString *> *)generateMappingTable {
    NSMutableDictionary<NSString *, NSString *> *mappingTable = [NSMutableDictionary dictionary];
    
    // launchScreen路径
    NSString *launchScreenPath = self.launchScreenDirectory;
    
    // 获取本地所有的启动图，并生成简单的键值对信息。@{图片名称 : 图片地址}
    NSDictionary<NSString *, NSString *> *all_launchScreen_image = ({
        NSFileManager *fileManager = NSFileManager.defaultManager;
        NSArray<NSString *> *paths = [fileManager subpathsAtPath:launchScreenPath];
        NSMutableDictionary<NSString *, NSString *> *t_dict = [NSMutableDictionary dictionary];
        for (NSString *imageName in paths) {
            if ([imageName hasSuffix:@".ktx"]) {
                NSString *fullPath = [launchScreenPath stringByAppendingPathComponent:imageName];
                [t_dict setValue:fullPath forKey:imageName];
            }
        }
        [t_dict copy];
    });
    
    for (NSString *imageName in all_launchScreen_image) {
        NSString *fullPath = all_launchScreen_image[imageName];
        
        // 将启动图Copy一份副本至Document文件夹下。
        [self copyItemAtPath:fullPath];
        
        UIImage *image = [UIImage imageWithContentsOfFile:fullPath];
        
        if (@available(iOS 13.0, *)) {
            BOOL isDark = [self hasDarkImage:image];
            
            if (isDark && (image.size.width < image.size.height)) {// 深色竖屏启动图
                [mappingTable setValue:imageName forKey:@"dark_vertial"];
                continue;
            }

            if (isDark && (image.size.width > image.size.height)) {// 深色横屏启动图
                [mappingTable setValue:imageName forKey:@"dark_horizaton"];
                continue;
            }

            if (!isDark && (image.size.width < image.size.height)) {// 浅色竖屏启动图
                [mappingTable setValue:imageName forKey:@"light_vertial"];
                continue;
            }

            if (!isDark && (image.size.width > image.size.height)) {// 浅色横屏启动图
                [mappingTable setValue:imageName forKey:@"light_horizaton"];
                continue;
            }
        }
    }
    
    return [mappingTable copy];
}

/// 将启动图Copy一份至Document之下。
+ (void)copyItemAtPath:(NSString *)srcPath {
    NSFileManager *fileManager = NSFileManager.defaultManager;
    
    // lauchScreen副本文件夹路径。
    NSString *directory = ({
        NSString *directory = self.launchScreenCopyDirectory;
        if (![fileManager fileExistsAtPath:directory]) {
            [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        directory;
    });
    
    
    NSString *imageName = srcPath.lastPathComponent;
    NSString *dstPath = [directory stringByAppendingPathComponent:imageName];
    
    [fileManager copyItemAtPath:srcPath toPath:dstPath error:nil];
}


/// YES表示是深色图片，NO表示是浅色图片
+ (BOOL)hasDarkImage:(UIImage *)image {
    // 获取图片右上角1×1像素点的颜色值。
    NSArray<NSNumber *> *RGBArr = [self pixelColorFromImage:image point:CGPointMake(image.size.width - 1, image.size.height - 1)];
    
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

/// 获取图片上某个点的颜色值(不包含alpha)。
+ (nullable NSArray<NSNumber *> *)pixelColorFromImage:(UIImage *)image point:(CGPoint)point {
    // 判断点是否超出图像范围
    if (!CGRectContainsPoint(CGRectMake(0, 0, image.size.width, image.size.height), point)) return nil;
    
    // 将像素绘制到一个1×1像素字节数组和位图上下文。
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = image.CGImage;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
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

+ (NSString *)launchScreenCopyDirectory {
    static NSString *fullPath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        fullPath = [path stringByAppendingPathComponent:@"ll_launchScreen"];
    });
    return fullPath;
}

+ (NSString *)launchScreenDirectory {
    static NSString *fullPath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
        NSString *bundleIdentifier = [infoDict objectForKey:@"CFBundleIdentifier"];
        if (@available(iOS 13.0, *)) {
            fullPath = [NSHomeDirectory() stringByAppendingFormat:@"/Library/SplashBoard/Snapshots/%@ - {DEFAULT GROUP}", bundleIdentifier];
        }
    });
    return fullPath;
}

@end
