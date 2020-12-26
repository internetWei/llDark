//
//  LLLaunchScreen.m
//  LLDarkTheme
//
//  Created by LL on 2020/11/17.
//

#import "LLLaunchScreen.h"

#import "LLDarkManager.h"
#import "UIImage+Dark.h"
#import "LLDarkDefine.h"

/// 竖屏浅色启动图名称
static NSString * const verticalLightName = @"verticalLight";

/// 竖屏深色启动图名称
static NSString * const verticalDarkName = @"verticalDark";

/// 横屏浅色启动图名称
static NSString * const horizontalLightName = @"horizontalLight";

/// 横屏深色启动图名称
static NSString * const horizontalDarkName = @"horizontalDark";

static NSString * const nameMapppingIdentifier = @"nameMapppingIdentifier";

@interface LLLaunchScreen ()

@end

@implementation LLLaunchScreen

+ (void)modifyLaunchScreen {
    // 本地启动图路径
    NSString *verticalLightPath = verticalLightName;
    NSString *verticalDarkPath = verticalDarkName;
    NSString *horizontalLightPath;
    NSString *horizontalDarkPath;
    if ([self supportHorizontalScreen]) {
        horizontalLightPath = horizontalLightName;
        horizontalDarkPath = horizontalDarkName;
    }
    
    NSMutableArray *pathArray;
    switch (LLDarkManager.userInterfaceStyle) {
        case LLUserInterfaceStyleUnspecified:
        {
            pathArray = [self pathArray:verticalLightPath, verticalDarkPath, horizontalLightPath, horizontalDarkPath, nil];
        }
            break;
        case LLUserInterfaceStyleLight:
        {
            pathArray = [self pathArray:verticalLightPath, horizontalLightPath, nil];
        }
            break;
        case LLUserInterfaceStyleDark:
        {
            pathArray = [self pathArray:verticalDarkPath, horizontalDarkPath, nil];
        }
            break;
    }
    
    for (NSString *name in pathArray) {
        [self replaceLaunchImage:name restore:(LLDarkManager.userInterfaceStyle == LLUserInterfaceStyleUnspecified)];
    }
}

/// 替换系统启动图
+ (void)replaceLaunchImage:(NSString *)name restore:(BOOL)restore {
    NSString *localPath = [self localLaunchScreenPath];
    NSString *filePath = [localPath stringByAppendingPathComponent:[name stringByAppendingString:@".png"]];
    
    UIImage *replacementImage = [UIImage imageWithContentsOfFile:filePath];
    
    if (!replacementImage) return;
    
    // 检查图片尺寸是否等同屏幕分辨率
    if (![self checkImageMatchScreenSize:replacementImage]) return;
    
    NSData *data = UIImageJPEGRepresentation(replacementImage, 0.8);
    if (!data) return;
    
    // 获取系统缓存启动图路径
    NSString *cacheDir = [self launchImageCacheDirectory];
    if (!cacheDir) return;
    
    // 工作目录
    NSString *cachesParentDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *tmpDir = [cachesParentDir stringByAppendingPathComponent:@"ll_tmpLaunchImageCaches"];
    
    // 清理工作目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:tmpDir]) {
        [fileManager removeItemAtPath:tmpDir error:nil];
    }
    
    // 移动系统缓存目录内容至工作目录
    BOOL moveResult = [fileManager moveItemAtPath:cacheDir toPath:tmpDir error:nil];
    if (!moveResult) return;
    
    // 写入并替换启动图
    if (restore) {
        NSDictionary *nameMapping = [NSUserDefaults.standardUserDefaults objectForKey:nameMapppingIdentifier];
        // 系统启动图名称
        NSString *imageName = [nameMapping objectForKey:name];
        NSString *fullPath = [tmpDir stringByAppendingPathComponent:imageName];
        
        [data writeToFile:fullPath atomically:YES];
    } else {
        for (NSString *imageName in [fileManager contentsOfDirectoryAtPath:tmpDir error:nil]) {
            NSString *fullPath = [tmpDir stringByAppendingPathComponent:imageName];
            UIImage *image = [UIImage imageWithContentsOfFile:fullPath];
            if (CGSizeEqualToSize(CGSizeMultiply(image.size, UIScreen.mainScreen.scale), replacementImage.size)) {
                [data writeToFile:fullPath atomically:YES];
            }
        }
    }
    
    // 还原系统缓存目录
    moveResult = [fileManager moveItemAtPath:tmpDir toPath:cacheDir error:nil];
    
    // 清理工作目录
    if ([fileManager fileExistsAtPath:tmpDir]) {
        [fileManager removeItemAtPath:tmpDir error:nil];
    }
}

+ (void)initialization {
    NSString *localPath = [self localLaunchScreenPath];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *old_app_version = [NSUserDefaults.standardUserDefaults objectForKey:@"ll_app_version"];
    // 判断是否需要重新生成启动图(判断APP版本号和上次记录的版本号是否一致、本地文件是否存在)
    if ([app_version isEqualToString:old_app_version] &&
        ![self isEmptyItemAtPath:localPath]) return;
    
    NSString *launchScreenName = @"LaunchScreen";
    if (LLDarkManager.launchScreenName.length > 0) {
        launchScreenName = LLDarkManager.launchScreenName;
    }
    
    // 从LaunchScreen.storyboard生成一份启动图并保存到沙盒中
    UIWindow *window = currentWindow();
    NSInteger interfaceStyle = 0;
    if (@available(iOS 13.0, *)) {
        // 保存APP当前的主题模式
        interfaceStyle = window.overrideUserInterfaceStyle;
    }
    
    // 生成启动图
    UIImage *verticalLight = [self snapshotStoryboard:launchScreenName isPortrait:YES isDark:NO];
    UIImage *verticalDark = [self snapshotStoryboard:launchScreenName isPortrait:YES isDark:YES];
    UIImage *horizontalLight = nil;
    UIImage *horizontalDark = nil;
    
    if ([self supportHorizontalScreen]) {
        horizontalLight = [self snapshotStoryboard:launchScreenName isPortrait:NO isDark:NO];
        horizontalDark = [self snapshotStoryboard:launchScreenName isPortrait:NO isDark:YES];
    }
    
    // 恢复APP主题模式
    if (@available(iOS 13.0, *)) {
        window.overrideUserInterfaceStyle = interfaceStyle;
    }
    
    // 本地启动图路径
    NSString *verticalLightPath = [localPath stringByAppendingPathComponent:[verticalLightName stringByAppendingString:@".png"]];
    NSString *verticalDarkPath = [localPath stringByAppendingPathComponent:[verticalDarkName stringByAppendingString:@".png"]];
    NSString *horizontalLightPath;
    NSString *horizontalDarkPath;
    if ([self supportHorizontalScreen]) {
        horizontalLightPath = [localPath stringByAppendingPathComponent:[horizontalLightName stringByAppendingString:@".png"]];
        horizontalDarkPath = [localPath stringByAppendingPathComponent:[horizontalDarkName stringByAppendingString:@".png"]];
    }
    
    // 将生成的启动图保存到本地
    [UIImageJPEGRepresentation(verticalLight, 0.8) writeToFile:verticalLightPath atomically:YES];
    [UIImageJPEGRepresentation(verticalDark, 0.8) writeToFile:verticalDarkPath atomically:YES];
    [UIImageJPEGRepresentation(horizontalLight, 0.8) writeToFile:horizontalLightPath atomically:YES];
    [UIImageJPEGRepresentation(horizontalDark, 0.8) writeToFile:horizontalDarkPath atomically:YES];
    
    // 保存APP当前版本号信息
    [NSUserDefaults.standardUserDefaults setObject:app_version forKey:@"ll_app_version"];
    
    // 生成启动图名称映射字典
    [self createLaunchImageNameMapping];
}

/// 生成启动图名称映射字典
+ (void)createLaunchImageNameMapping {
    NSMutableDictionary *nameMappping = [NSMutableDictionary dictionary];
    
    // 获取系统缓存启动图路径
    NSString *cacheDir = [self launchImageCacheDirectory];
    if (!cacheDir) return;
    
    // 工作目录
    NSString *cachesParentDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *tmpDir = [cachesParentDir stringByAppendingPathComponent:@"ll_tmpLaunchImageCaches"];
    
    // 清理工作目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:tmpDir]) {
        [fileManager removeItemAtPath:tmpDir error:nil];
    }
    
    // 移动系统缓存目录内容至工作目录
    BOOL moveResult = [fileManager copyItemAtPath:cacheDir toPath:tmpDir error:nil];
    if (!moveResult) return;
    
    // 操作工作目录
    // 遍历记录需要操作的图片名
    for (NSString *name in [fileManager contentsOfDirectoryAtPath:tmpDir error:nil]) {
        if ([self isSnapShotName:name]) {
            UIImage *tmpImage = [UIImage imageWithContentsOfFile:[tmpDir stringByAppendingPathComponent:name]];
            // 判断是横图还是竖图
            if (tmpImage.size.width < tmpImage.size.height) {// 竖图
                if (tmpImage.hasDarkImage) {// 深色竖图
                    [nameMappping setObject:name forKey:verticalDarkName];
                } else {// 浅色竖图
                    [nameMappping setObject:name forKey:verticalLightName];
                }
            } else {// 横图
                if (tmpImage.hasDarkImage) {// 深色横图
                    [nameMappping setObject:name forKey:horizontalDarkName];
                } else {// 浅色横图
                    [nameMappping setObject:name forKey:horizontalLightName];
                }
            }
        }
    }
    
    // 清理工作目录
    if ([fileManager fileExistsAtPath:tmpDir]) {
        [fileManager removeItemAtPath:tmpDir error:nil];
    }
    
    [NSUserDefaults.standardUserDefaults setObject:nameMappping forKey:nameMapppingIdentifier];
}

/// 根据LaunchScreen名称、是否竖屏、是否暗黑3个参数生成启动图。
+ (UIImage *)snapshotStoryboard:(NSString *)sbName isPortrait:(BOOL)isPortrait isDark:(BOOL)isDark {
    if (@available(iOS 13.0, *)) {
        UIWindow *window = currentWindow();
        if (isDark) {
            window.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
        } else {
            window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        }
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:sbName bundle:nil];
    UIViewController *vc = storyboard.instantiateInitialViewController;
    vc.view.frame = [UIScreen mainScreen].bounds;
    
    if (isPortrait) {
        if (vc.view.frame.size.width > vc.view.frame.size.height) {
            vc.view.frame = CGRectMake(0, 0, vc.view.frame.size.height, vc.view.frame.size.width);
        }
    } else {
        if (vc.view.frame.size.width < vc.view.frame.size.height) {
            vc.view.frame = CGRectMake(0, 0, vc.view.frame.size.height, vc.view.frame.size.width);
        }
    }
    
    [vc.view setNeedsLayout];
    [vc.view layoutIfNeeded];
    
    UIGraphicsBeginImageContextWithOptions(vc.view.frame.size, NO, [UIScreen mainScreen].scale);
    [vc.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/// YES：APP支持横屏，NO：不支持
+ (BOOL)supportHorizontalScreen {
    NSArray *t_array = [NSBundle.mainBundle.infoDictionary objectForKey:@"UISupportedInterfaceOrientations"];
    if ([t_array containsObject:@"UIInterfaceOrientationLandscapeLeft"] ||
        [t_array containsObject:@"UIInterfaceOrientationLandscapeRight"]) {
        return YES;
    } else {
        return NO;
    }
}

/// 系统启动图缓存路径
+ (nullable NSString *)launchImageCacheDirectory {
    NSString *bundleID = [NSBundle mainBundle].infoDictionary[@"CFBundleIdentifier"];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    // iOS13之前
    NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *snapshotsPath = [[cachesDirectory stringByAppendingPathComponent:@"Snapshots"] stringByAppendingPathComponent:bundleID];
    if ([fileManager fileExistsAtPath:snapshotsPath]) {
        return snapshotsPath;
    }
    
    // iOS13
    NSString *libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    snapshotsPath = [NSString stringWithFormat:@"%@/SplashBoard/Snapshots/%@ - {DEFAULT GROUP}", libraryDirectory, bundleID];
    if ([fileManager fileExistsAtPath:snapshotsPath]) {
        return snapshotsPath;
    }
    
    return nil;
}

+ (NSString *)localLaunchScreenPath {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [rootPath stringByAppendingPathComponent:@"ll_launchImageCaches"];
    if (![NSFileManager.defaultManager fileExistsAtPath:path]) {
        [NSFileManager.defaultManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:@{} error:nil];
    }
    return path;
}

+ (BOOL)isEmptyItemAtPath:(NSString *)path {
    for (NSString *name in [NSFileManager.defaultManager contentsOfDirectoryAtPath:path error:nil]) {
        if ([self isSnapShotName:name]) {
            return NO;
        }
    }
    return YES;
}

/// 系统缓存启动图后缀名
+ (BOOL)isSnapShotName:(NSString *)name {
    // 新系统后缀
    if ([name hasSuffix:@".ktx"]) {
        return YES;
    }
    // 老系统后缀
    if ([name hasSuffix:@".png"]) {
        return YES;
    }
    return NO;
}

+ (NSMutableArray<NSString *> *)pathArray:(NSString *)path, ... NS_REQUIRES_NIL_TERMINATION {
    NSMutableArray *t_array = [NSMutableArray array];
    
    va_list arglist;
    va_start(arglist, path);
    
    if (path) {
        [t_array addObject:path];
    }
    
    id arg;
    while ((arg = va_arg(arglist, id))) {
        [t_array addObject:arg];
    }
    
    va_end(arglist);
    
    return t_array;
}

/// 检查图片大小
+ (BOOL)checkImageMatchScreenSize:(UIImage *)image {
    CGSize screenSize = CGSizeApplyAffineTransform([UIScreen mainScreen].bounds.size,
                                                   CGAffineTransformMakeScale([UIScreen mainScreen].scale,
                                                                              [UIScreen mainScreen].scale));
    CGSize imageSize = CGSizeApplyAffineTransform(image.size,
                                                  CGAffineTransformMakeScale(image.scale, image.scale));
    if (CGSizeEqualToSize(imageSize, screenSize)) {
        return YES;
    }
    if (CGSizeEqualToSize(CGSizeMake(imageSize.height, imageSize.width), screenSize)) {
        return YES;
    }
    return NO;
}

@end
