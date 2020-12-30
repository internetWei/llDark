//
//  LLLaunchScreen.m
//  LLDarkTheme
//
//  Created by LL on 2020/11/17.
//

#import "LLLaunchScreen.h"

#import "LLDarkDefine.h"
#import "UIImage+Dark.h"

/// 竖屏浅色启动图名称
static NSString * const verticalLightName = @"verticalLight";

/// 竖屏深色启动图名称
static NSString * const verticalDarkName = @"verticalDark";

/// 横屏浅色启动图名称
static NSString * const horizontalLightName = @"horizontalLight";

/// 横屏深色启动图名称
static NSString * const horizontalDarkName = @"horizontalDark";

static NSString * const nameMapppingIdentifier = @"nameMapppingIdentifier";

@implementation LLLaunchScreen

+ (void)initialization {
    NSString *localPath = [self launchImageBackupPath];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *old_app_version = [NSUserDefaults.standardUserDefaults objectForKey:@"ll_app_version"];
    
    // 判断是否需要重新初始化启动图资源
    if ([app_version isEqualToString:old_app_version] &&
        ![self isEmptyDir:localPath]) return;
    
    // 清空本地启动图
    for (NSString *name in [NSFileManager.defaultManager contentsOfDirectoryAtPath:localPath error:nil]) {
        NSString *fullPath = [localPath stringByAppendingPathComponent:name];
        [NSFileManager.defaultManager removeItemAtPath:fullPath error:nil];
    }
    
    UIWindow *window = currentWindow();
    NSInteger interfaceStyle = 0;
    if (@available(iOS 13.0, *)) {
        // 保存APP当前的主题模式
        interfaceStyle = window.overrideUserInterfaceStyle;
    }
    
    NSString *launchScreenName = @"LaunchScreen";
    if (LLLaunchScreen.launchScreenName.length > 0) {
        launchScreenName = LLLaunchScreen.launchScreenName;
    }
    
    /*-------1.生成启动图资源-------*/
    
    UIImage *verticalLight = [self snapshotStoryboard:launchScreenName isPortrait:YES isDark:NO];
    UIImage *verticalDark;
    if (@available(iOS 13.0, *)) {
        verticalDark = [self snapshotStoryboard:launchScreenName isPortrait:YES isDark:YES];
    } else {
        // 尝试从本地获取暗黑启动图资源
        verticalDark = [self darkImageFromOrientation:YES];
    }
    
    UIImage *horizontalLight = nil;
    UIImage *horizontalDark = nil;
    if ([self supportHorizontalScreen]) {
        horizontalLight = [self snapshotStoryboard:launchScreenName isPortrait:NO isDark:NO];
        if (@available(iOS 13.0, *)) {
            horizontalDark = [self snapshotStoryboard:launchScreenName isPortrait:NO isDark:YES];
        } else {
            horizontalDark = [self darkImageFromOrientation:NO];
        }
    }
    
    // 恢复APP主题模式
    if (@available(iOS 13.0, *)) {
        window.overrideUserInterfaceStyle = interfaceStyle;
    }
    
    // 本地启动图路径
    NSString *verticalLightPath = [localPath stringByAppendingPathComponent:[verticalLightName stringByAppendingString:@".png"]];
    NSString *verticalDarkPath = [localPath stringByAppendingPathComponent:[verticalDarkName stringByAppendingString:@".png"]];
    NSString *horizontalLightPath = [localPath stringByAppendingPathComponent:[horizontalLightName stringByAppendingString:@".png"]];
    NSString *horizontalDarkPath = [localPath stringByAppendingPathComponent:[horizontalDarkName stringByAppendingString:@".png"]];

    // 将生成的启动图保存到本地
    if (verticalLight) {
        [UIImageJPEGRepresentation(verticalLight, 0.8) writeToFile:verticalLightPath atomically:YES];
    }
    if (verticalDark) {
        [UIImageJPEGRepresentation(verticalDark, 0.8) writeToFile:verticalDarkPath atomically:YES];
    }
    if (horizontalLight) {
        [UIImageJPEGRepresentation(horizontalLight, 0.8) writeToFile:horizontalLightPath atomically:YES];
    }
    if (horizontalDark) {
        [UIImageJPEGRepresentation(horizontalDark, 0.8) writeToFile:horizontalDarkPath atomically:YES];
    }
    
    // 保存APP当前版本号信息
    [NSUserDefaults.standardUserDefaults setObject:app_version forKey:@"ll_app_version"];
    
    [self createLaunchImageNameMapping];
}

+ (void)restoreLaunchScreeen {
    NSString *customPath = [self launchImageCustomPath];
    for (NSString *name in [NSFileManager.defaultManager contentsOfDirectoryAtPath:customPath error:nil]) {
        NSString *fullPath = [customPath stringByAppendingPathComponent:name];
        [NSFileManager.defaultManager removeItemAtPath:fullPath error:nil];
    }
    
    for (NSString *name in @[verticalLightName, verticalDarkName, horizontalLightName, horizontalDarkName]) {
        [self replaceLaunchImage:name restore:YES];
    }
}

+ (void)launchImageAdaptation {
    NSArray *pathArray;
    switch (LLDarkManager.userInterfaceStyle) {
        case LLUserInterfaceStyleUnspecified:
        {
            
            pathArray = @[verticalLightName, verticalDarkName, horizontalLightName, horizontalDarkName];
        }
            break;
        case LLUserInterfaceStyleLight:
        {
            pathArray = @[verticalLightName, horizontalLightName];
        }
            break;
        case LLUserInterfaceStyleDark:
        {
            pathArray = @[verticalDarkName, horizontalDarkName];
        }
            break;
    }
    for (NSString *name in pathArray) {
        [self replaceLaunchImage:name restore:(LLDarkManager.userInterfaceStyle == LLUserInterfaceStyleUnspecified)];
    }
}

+ (void)replaceLaunchImage:(NSString *)name restore:(BOOL)restore {
    NSString *customPath = [self launchImageCustomPath];
    NSString *fullPath = [customPath stringByAppendingPathComponent:[name stringByAppendingString:@".png"]];
    if (![NSFileManager.defaultManager fileExistsAtPath:fullPath]) {
        NSString *localPath = [self launchImageBackupPath];
        fullPath = [localPath stringByAppendingPathComponent:[name stringByAppendingString:@".png"]];
    }
    
    UIImage *replaceImage = [UIImage imageWithContentsOfFile:fullPath];
    
    if (!replaceImage) return;
    
    if ([name isEqualToString:verticalLightName] ||
        [name isEqualToString:verticalDarkName]) {
        replaceImage = [self resizeImage:replaceImage toPortraitScreenSize:YES];
    } else {
        replaceImage = [self resizeImage:replaceImage toPortraitScreenSize:NO];
    }
    
    // 检查图片尺寸是否等同屏幕分辨率
    if (![self checkImageMatchScreenSize:replaceImage]) return;
    
    // 获取系统缓存启动图路径
    NSString *cacheDir = [self launchImageCacheDirectory];
    if (!cacheDir) return;
    
    // 工作目录
    NSString *cachesParentDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *tmpDir = [cachesParentDir stringByAppendingPathComponent:@"ll_tmpLaunchImage"];
    
    // 清理工作目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:tmpDir]) {
        [fileManager removeItemAtPath:tmpDir error:nil];
    }
    
    // 移动系统缓存目录内容至工作目录
    BOOL moveResult = [fileManager moveItemAtPath:cacheDir toPath:tmpDir error:nil];
    if (!moveResult) return;
    
    NSData *data = UIImageJPEGRepresentation(replaceImage, 0.8);
    
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
            if (CGSizeEqualToSize(CGSizeMultiply(image.size, image.scale), replaceImage.size)) {
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

/// 生成启动图名称映射表
+ (void)createLaunchImageNameMapping {
    NSMutableDictionary *nameMappping = [NSMutableDictionary dictionary];
    
    // 获取系统缓存启动图路径
    NSString *cacheDir = [self launchImageCacheDirectory];
    if (!cacheDir) return;
    
    // 工作目录
    NSString *cachesParentDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *tmpDir = [cachesParentDir stringByAppendingPathComponent:@"ll_tmpLaunchImage"];
    
    // 清理工作目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:tmpDir]) {
        [fileManager removeItemAtPath:tmpDir error:nil];
    }
    
    // 移动系统缓存目录内容至工作目录
    BOOL moveResult = [fileManager moveItemAtPath:cacheDir toPath:tmpDir error:nil];
    if (!moveResult) return;
    
    // 遍历记录需要操作的图片名
    for (NSString *name in [fileManager contentsOfDirectoryAtPath:tmpDir error:nil]) {
        if ([self isSnapShotName:name]) {
            UIImage *tmpImage = [UIImage imageWithContentsOfFile:[tmpDir stringByAppendingPathComponent:name]];
            if (@available(iOS 13.0, *)) {
                // 判断是横图还是竖图
                if (tmpImage.size.width < tmpImage.size.height) {// 竖图
                    if (_hasDarkImageBlock) {// 用户实现了自定义深色图片校验
                        BOOL hasDark = _hasDarkImageBlock(tmpImage);
                        if (hasDark) {
                            [nameMappping setObject:name forKey:verticalDarkName];
                        } else {
                            [nameMappping setObject:name forKey:verticalLightName];
                        }
                    } else {
                        if (tmpImage.hasDarkImage) {// 深色竖图
                            [nameMappping setObject:name forKey:verticalDarkName];
                        } else {// 浅色竖图
                            [nameMappping setObject:name forKey:verticalLightName];
                        }
                    }
                } else {// 横图
                    if (_hasDarkImageBlock) {
                        BOOL hasDark = _hasDarkImageBlock(tmpImage);
                        if (hasDark) {
                            [nameMappping setObject:name forKey:horizontalDarkName];
                        } else {
                            [nameMappping setObject:name forKey:horizontalLightName];
                        }
                    } else {
                        if (tmpImage.hasDarkImage) {// 深色横图
                            [nameMappping setObject:name forKey:horizontalDarkName];
                        } else {// 浅色横图
                            [nameMappping setObject:name forKey:horizontalLightName];
                        }
                    }
                }
            } else {
                if (tmpImage.size.width < tmpImage.size.height) {// 竖图
                    [nameMappping setObject:name forKey:verticalLightName];
                    [nameMappping setObject:name forKey:verticalDarkName];
                } else {
                    [nameMappping setObject:name forKey:horizontalLightName];
                    [nameMappping setObject:name forKey:horizontalDarkName];
                }
            }
        }
    }
    
    // 还原系统缓存目录
    moveResult = [fileManager moveItemAtPath:tmpDir toPath:cacheDir error:nil];
    
    // 清理工作目录
    if ([fileManager fileExistsAtPath:tmpDir]) {
        [fileManager removeItemAtPath:tmpDir error:nil];
    }
    
    [NSUserDefaults.standardUserDefaults setObject:nameMappping forKey:nameMapppingIdentifier];
}

/// YES：竖屏，NO：横屏
+ (nullable UIImage *)darkImageFromOrientation:(BOOL)orientation {
    CGSize screenSize = [self screenSize];
    NSString *imageName = nil;
    if (orientation) {
        imageName = [NSString stringWithFormat:@"launchImage_%.0f_%.0f", screenSize.width, screenSize.height];
    } else {
        imageName = [NSString stringWithFormat:@"launchImage_%.0f_%.0f", screenSize.height, screenSize.width];
    }
    NSString *fullPath = [NSBundle.mainBundle pathForResource:imageName ofType:@".ktx"];
    if (!fullPath) {
        for (NSString *suffix in @[@".png", @".jpeg", @".jpg"]) {
            fullPath = [NSBundle.mainBundle pathForResource:imageName ofType:suffix];
            if (fullPath) break;
        }
    }
    
    if (!fullPath) return nil;
    
    return [UIImage imageWithContentsOfFile:fullPath];
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

+ (BOOL)isEmptyDir:(NSString *)path {
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

/// 启动图备份文件夹
+ (NSString *)launchImageBackupPath {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [rootPath stringByAppendingPathComponent:@"ll_launchImageBackup"];
    if (![NSFileManager.defaultManager fileExistsAtPath:path]) {
        [NSFileManager.defaultManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:@{} error:nil];
    }
    return path;
}

/// 自定义启动图文件夹
+ (NSString *)launchImageCustomPath {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [rootPath stringByAppendingPathComponent:@"ll_launchImageCustom"];
    if (![NSFileManager.defaultManager fileExistsAtPath:path]) {
        [NSFileManager.defaultManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:@{} error:nil];
    }
    return path;
}

/// 获取屏幕宽高
+ (CGSize)screenSize {
    CGFloat width = UIScreen.mainScreen.bounds.size.width;
    CGFloat height = UIScreen.mainScreen.bounds.size.height;
    CGSize size = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        size = CGSizeMake(width, height);
    }else {
        size = CGSizeMake(height, width);
    }
    return size;
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

/// 将图片强行转换为某个尺寸
+ (UIImage *)resizeImage:(UIImage *)image toPortraitScreenSize:(BOOL)isPortrait {
    CGSize imageSize = CGSizeApplyAffineTransform(image.size,
                                                  CGAffineTransformMakeScale(image.scale, image.scale));
    CGSize contextSize = [self contextSizeForPortrait:isPortrait];
    
    if (!CGSizeEqualToSize(imageSize, contextSize)) {
        UIGraphicsBeginImageContext(contextSize);
        CGFloat ratio = MAX((contextSize.width / image.size.width),
                            (contextSize.height / image.size.height));
        CGRect rect = CGRectMake(0, 0, image.size.width * ratio, image.size.height * ratio);
        [image drawInRect:rect];
        UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return resizedImage;
    }
    
    return image;
}

+ (CGSize)contextSizeForPortrait:(BOOL)isPortrait {
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

+ (void)replaceLaunchImage:(NSData *)data toImageName:(NSString *)imageName {
    UIImage *replaceImage = [UIImage imageWithData:data];
    
    if ([imageName isEqualToString:verticalLightName] ||
        [imageName isEqualToString:verticalDarkName]) {
        replaceImage = [self resizeImage:replaceImage toPortraitScreenSize:YES];
    } else {
        replaceImage = [self resizeImage:replaceImage toPortraitScreenSize:NO];
    }
    data = UIImageJPEGRepresentation(replaceImage, 1.0);
    
    // 获取系统缓存启动图路径
    NSString *cacheDir = [self launchImageCacheDirectory];
    if (!cacheDir) return;
    
    // 工作目录
    NSString *cachesParentDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *tmpDir = [cachesParentDir stringByAppendingPathComponent:@"ll_tmpLaunchImage"];
    
    // 清理工作目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:tmpDir]) {
        [fileManager removeItemAtPath:tmpDir error:nil];
    }
    
    // 移动系统缓存目录内容至工作目录
    BOOL moveResult = [fileManager moveItemAtPath:cacheDir toPath:tmpDir error:nil];
    if (!moveResult) return;
    
    NSDictionary *nameMapping = [NSUserDefaults.standardUserDefaults objectForKey:nameMapppingIdentifier];
    NSString *name = [nameMapping objectForKey:imageName];
    
    [data writeToFile:[tmpDir stringByAppendingPathComponent:name] atomically:YES];
    
    // 还原系统缓存目录
    moveResult = [fileManager moveItemAtPath:tmpDir toPath:cacheDir error:nil];
    
    // 清理工作目录
    if ([fileManager fileExistsAtPath:tmpDir]) {
        [fileManager removeItemAtPath:tmpDir error:nil];
    }
}

+ (void)setVerticalLightImage:(UIImage *)verticalLightImage {
    [self initialization];
    NSString *customPath = [self launchImageCustomPath];
    NSString *verticalLightPath = [customPath stringByAppendingPathComponent:[verticalLightName stringByAppendingString:@".png"]];
    if (verticalLightImage) {
        NSData *data = UIImageJPEGRepresentation(verticalLightImage, 0.8);
        [data writeToFile:verticalLightPath atomically:YES];
        [self replaceLaunchImage:data toImageName:verticalLightName];
    } else {
        NSString *localPath = [self launchImageBackupPath];
        NSString *fullPath = [localPath stringByAppendingPathComponent:[verticalLightName stringByAppendingString:@".png"]];
        NSData *data = [NSData dataWithContentsOfFile:fullPath];
        [self replaceLaunchImage:data toImageName:verticalLightName];
        [NSFileManager.defaultManager removeItemAtPath:verticalLightPath error:nil];
    }
}

+ (UIImage *)verticalLightImage {
    NSString *localPath = [self launchImageCustomPath];
    NSString *verticalLightPath = [localPath stringByAppendingPathComponent:[verticalLightName stringByAppendingString:@".png"]];
    
    return [UIImage imageWithContentsOfFile:verticalLightPath];
}

+ (void)setVerticalDarkImage:(UIImage *)verticalDarkImage {
    [self initialization];
    NSString *customPath = [self launchImageCustomPath];
    NSString *verticalDarkPath = [customPath stringByAppendingPathComponent:[verticalDarkName stringByAppendingString:@".png"]];
    if (verticalDarkImage) {
        NSData *data = UIImageJPEGRepresentation(verticalDarkImage, 0.8);
        [data writeToFile:verticalDarkPath atomically:YES];
        [self replaceLaunchImage:data toImageName:verticalDarkName];
    } else {
        NSString *localPath = [self launchImageBackupPath];
        NSString *fullPath = [localPath stringByAppendingPathComponent:[verticalDarkName stringByAppendingString:@".png"]];
        NSData *data = [NSData dataWithContentsOfFile:fullPath];
        [self replaceLaunchImage:data toImageName:verticalDarkName];
        [NSFileManager.defaultManager removeItemAtPath:verticalDarkPath error:nil];
    }
}

+ (UIImage *)verticalDarkImage {
    NSString *localPath = [self launchImageCustomPath];
    NSString *verticalDarkPath = [localPath stringByAppendingPathComponent:[verticalDarkName stringByAppendingString:@".png"]];
    
    return [UIImage imageWithContentsOfFile:verticalDarkPath];
}

+ (void)setHorizontalLightImage:(UIImage *)horizontalLightImage {
    [self initialization];
    NSString *customPath = [self launchImageCustomPath];
    NSString *horizontalLightPath = [customPath stringByAppendingPathComponent:[horizontalLightName stringByAppendingString:@".png"]];
    if (horizontalLightImage) {
        NSData *data = UIImageJPEGRepresentation(horizontalLightImage, 0.8);
        [data writeToFile:horizontalLightPath atomically:YES];
        [self replaceLaunchImage:data toImageName:horizontalLightName];
    } else {
        NSString *localPath = [self launchImageBackupPath];
        NSString *fullPath = [localPath stringByAppendingPathComponent:[horizontalLightName stringByAppendingString:@".png"]];
        NSData *data = [NSData dataWithContentsOfFile:fullPath];
        [self replaceLaunchImage:data toImageName:horizontalLightName];
        [NSFileManager.defaultManager removeItemAtPath:horizontalLightPath error:nil];
    }
}

+ (UIImage *)horizontalLightImage {
    NSString *localPath = [self launchImageCustomPath];
    NSString *horizontalLightPath = [localPath stringByAppendingPathComponent:[horizontalLightName stringByAppendingString:@".png"]];
    
    return [UIImage imageWithContentsOfFile:horizontalLightPath];
}

+ (void)setHorizontalDarkImage:(UIImage *)horizontalDarkImage {
    [self initialization];
    NSString *customPath = [self launchImageCustomPath];
    NSString *horizontalDarkPath = [customPath stringByAppendingPathComponent:[horizontalDarkName stringByAppendingString:@".png"]];
    if (horizontalDarkImage) {
        NSData *data = UIImageJPEGRepresentation(horizontalDarkImage, 0.8);
        [data writeToFile:horizontalDarkPath atomically:YES];
        [self replaceLaunchImage:data toImageName:horizontalDarkName];
    } else {
        NSString *localPath = [self launchImageBackupPath];
        NSString *fullPath = [localPath stringByAppendingPathComponent:[horizontalDarkName stringByAppendingString:@".png"]];
        NSData *data = [NSData dataWithContentsOfFile:fullPath];
        [self replaceLaunchImage:data toImageName:horizontalDarkName];
        [NSFileManager.defaultManager removeItemAtPath:horizontalDarkPath error:nil];
    }
}

+ (UIImage *)horizontalDarkImage {
    NSString *localPath = [self launchImageCustomPath];
    NSString *horizontalDarkPath = [localPath stringByAppendingPathComponent:[horizontalDarkName stringByAppendingString:@".png"]];
    
    return [UIImage imageWithContentsOfFile:horizontalDarkPath];
}

static NSString *_launchScreenName;
+ (void)setLaunchScreenName:(NSString *)launchScreenName {
    _launchScreenName = launchScreenName;
}

+ (NSString *)launchScreenName {
    return _launchScreenName;
}

static BOOL (^_hasDarkImageBlock) (UIImage *image);
+ (void)setHasDarkImageBlock:(BOOL (^)(UIImage * _Nonnull))hasDarkImageBlock {
    _hasDarkImageBlock = hasDarkImageBlock;
}

+ (BOOL (^)(UIImage * _Nonnull))hasDarkImageBlock {
    return _hasDarkImageBlock;
}

@end
