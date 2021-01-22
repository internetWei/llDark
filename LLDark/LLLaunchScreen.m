//
//  LLLaunchScreen.m
//  LLDarkTheme
//
//  Created by LL on 2020/11/17.
//

#import "LLLaunchScreen.h"

#import "NSObject+Dark.h"
#import "UIImage+Dark.h"
#import "LLDarkManager.h"

static NSString * const llDark_launchImageInfoIdentifier = @"llDark_launchImageInfoIdentifier";
static NSString * const llDark_launchImageModifyIdentifier = @"llDark_launchImageModifyIdentifier";
static NSString * const llDark_launchImageVersionIdentifier = @"llDark_launchImageVersionIdentifier";

static BOOL llDark_launchImage_repairException = NO;
static BOOL llDark_launchImage_restoreAsBefore = NO;

@implementation LLLaunchScreen

+ (void)didFinishLaunching {
    [self launchImageIsNewVersion:^{
        NSDictionary *modifyDictionary = [NSUserDefaults.standardUserDefaults objectForKey:llDark_launchImageModifyIdentifier];
        for (NSString *key in modifyDictionary) {
            NSString *isModify = modifyDictionary[key];
            if ([isModify isEqualToString:@"YES"]) {
                NSString *fullPath = [customLaunchImageBackupPath() stringByAppendingPathComponent:[key stringByAppendingString:@".png"]];
                [self replaceLaunchImage:[UIImage imageWithContentsOfFile:fullPath] launchImageType:LaunchImageTypeFromLaunchImageName(key) compressionQuality:0.8 validation:nil];
            }
        }
    } identifier:NSStringFromSelector(@selector(didFinishLaunching))];
    
    [self repairException];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(launchImageAdaptation) name:ThemeDidChangeNotification object:nil];
}

+ (void)launchImageAdaptation {
    if (LLDarkManager.userInterfaceStyle == LLUserInterfaceStyleUnspecified) {
        NSDictionary *modifyDictionary = [NSUserDefaults.standardUserDefaults objectForKey:llDark_launchImageModifyIdentifier];
        for (NSString *key in modifyDictionary) {
            NSString *isModify = modifyDictionary[key];
            if ([isModify isEqualToString:@"YES"]) {
                NSString *fullPath = [customLaunchImageBackupPath() stringByAppendingPathComponent:[key stringByAppendingString:@".png"]];
                UIImage *replaceImage = [UIImage imageWithContentsOfFile:fullPath];
                [self replaceLaunchImage:replaceImage launchImageType:LaunchImageTypeFromLaunchImageName(key) compressionQuality:0.8 validation:nil initiative:NO];
            } else {
                [self replaceLaunchImage:nil launchImageType:LaunchImageTypeFromLaunchImageName(key) compressionQuality:0.8 validation:nil initiative:NO];
            }
        }
        return;
    }
    
    if (LLDarkManager.userInterfaceStyle == LLUserInterfaceStyleLight) {
        UIImage *verticalLightImage = [self launchImageFromLaunchImageType:LLDarkLaunchImageTypeVerticalLight];
        if (verticalLightImage) {
            [self replaceVerticalLaunchImage:verticalLightImage initiative:NO];
        }
        UIImage *horizontalLightImage = [self launchImageFromLaunchImageType:LLDarkLaunchImageTypeHorizontalLight];
        if (horizontalLightImage) {
            [self replaceHorizontalLaunchImage:horizontalLightImage initiative:NO];
        }
        return;
    }
    
    if (LLDarkManager.userInterfaceStyle == LLUserInterfaceStyleDark) {
        if (@available(iOS 13.0, *)) {
            UIImage *verticalDarkImage = [self launchImageFromLaunchImageType:LLDarkLaunchImageTypeVerticalDark];
            if (verticalDarkImage) {
                [self replaceVerticalLaunchImage:verticalDarkImage initiative:NO];
            }
            UIImage *horizontalDarkImage = [self launchImageFromLaunchImageType:LLDarkLaunchImageTypeHorizontalDark];
            if (horizontalDarkImage) {
                [self replaceHorizontalLaunchImage:horizontalDarkImage initiative:NO];
            }
        } else {
            CGSize screenSize = UIScreen.mainScreen.bounds.size;
            NSString *imageName = [NSString stringWithFormat:@"launchImage_%.0f_%.0f", screenSize.width, screenSize.height];
            UIImage *verticalDarkImage = UIImage.imageNamed(imageName);
            if (verticalDarkImage) {
                [self replaceVerticalLaunchImage:verticalDarkImage initiative:NO];
            }
            
            imageName = [NSString stringWithFormat:@"launchImage_%.0f_%.0f", screenSize.height, screenSize.width];
            UIImage *horizontalDarkImage = UIImage.imageNamed(imageName);
            if (horizontalDarkImage) {
                [self replaceHorizontalLaunchImage:horizontalDarkImage initiative:NO];
            }
        }
        return;
    }
}

+ (void)replaceVerticalLaunchImage:(nullable UIImage *)verticalImage {
    [self replaceVerticalLaunchImage:verticalImage initiative:YES];
}

+ (void)replaceVerticalLaunchImage:(nullable UIImage *)verticalImage initiative:(BOOL)isInitiative {
    [self replaceLaunchImage:verticalImage launchImageType:LLDarkLaunchImageTypeVerticalLight compressionQuality:0.8 validation:nil initiative:isInitiative];
    if (@available(iOS 13.0, *)) {
        [self replaceLaunchImage:verticalImage launchImageType:LLDarkLaunchImageTypeVerticalDark compressionQuality:0.8 validation:nil initiative:isInitiative];
    }
}

+ (void)replaceHorizontalLaunchImage:(nullable UIImage *)horizontalImage {
    [self replaceHorizontalLaunchImage:horizontalImage initiative:YES];
}

+ (void)replaceHorizontalLaunchImage:(nullable UIImage *)horizontalImage initiative:(BOOL)isInitiative {
    [self replaceLaunchImage:horizontalImage launchImageType:LLDarkLaunchImageTypeHorizontalLight compressionQuality:0.8 validation:nil initiative:isInitiative];
    if (@available(iOS 13.0, *)) {
        [self replaceLaunchImage:horizontalImage launchImageType:LLDarkLaunchImageTypeHorizontalDark compressionQuality:0.8 validation:nil initiative:isInitiative];
    }
}

+ (void)repairException {
    [self launchImageIsNewVersion:^{
        if (doesExistsOriginLaunchImage()) {
            NSDictionary *modifyDictionary = [NSUserDefaults.standardUserDefaults objectForKey:llDark_launchImageModifyIdentifier];
            for (NSString *key in modifyDictionary) {
                NSString *isModify = modifyDictionary[key];
                if ([isModify isEqualToString:@"NO"]) {
                    [self replaceLaunchImage:nil launchImageType:LaunchImageTypeFromLaunchImageName(key) compressionQuality:0.8 validation:nil];
                }
            }
            
            llDark_launchImage_repairException = NO;
        } else {
            llDark_launchImage_repairException = YES;
        }
    } identifier:NSStringFromSelector(@selector(repairException))];
}

+ (void)restoreAsBefore {
    if (doesExistsOriginLaunchImage()) {
        [self replaceLaunchImage:nil launchImageType:LLDarkLaunchImageTypeVerticalLight compressionQuality:0.8 validation:nil];
        [self replaceLaunchImage:nil launchImageType:LLDarkLaunchImageTypeHorizontalLight compressionQuality:0.8 validation:nil];
        if (@available(iOS 13.0, *)) {
            [self replaceLaunchImage:nil launchImageType:LLDarkLaunchImageTypeVerticalDark compressionQuality:0.8 validation:nil];
            [self replaceLaunchImage:nil launchImageType:LLDarkLaunchImageTypeHorizontalDark compressionQuality:0.8 validation:nil];
        }
        
        [NSFileManager.defaultManager removeItemAtPath:customLaunchImageBackupPath() error:nil];
        llDark_launchImage_restoreAsBefore = NO;
    } else {
        llDark_launchImage_restoreAsBefore = YES;
    }
}

+ (BOOL)replaceLaunchImage:(nullable UIImage *)replaceImage
           launchImageType:(LLDarkLaunchImageType)launchImageType
        compressionQuality:(CGFloat)quality
                validation:(BOOL (^ _Nullable) (UIImage *originImage, UIImage *replaceImage))validationBlock {
    return [self replaceLaunchImage:replaceImage launchImageType:launchImageType compressionQuality:quality validation:validationBlock initiative:YES];
}

+ (BOOL)replaceLaunchImage:(nullable UIImage *)replaceImage
           launchImageType:(LLDarkLaunchImageType)launchImageType
        compressionQuality:(CGFloat)quality
                validation:(BOOL (^ _Nullable) (UIImage *originImage, UIImage *replaceImage))validationBlock
                initiative:(BOOL)isInitiative {
    BOOL isReplace = (replaceImage != nil);
    
    if (replaceImage == nil) {
        NSString *imageName = LaunchImageNameFromLaunchImageType(launchImageType);
        NSString *fullPath = [originLaunchImageFullBackupPath() stringByAppendingPathComponent:[imageName stringByAppendingString:@".png"]];
        replaceImage = [UIImage imageWithContentsOfFile:fullPath];
    }
    
    BOOL isVertical = NO;
    if (launchImageType == LLDarkLaunchImageTypeVerticalLight) {
        isVertical = YES;
    }
    
    if (@available(iOS 13.0, *)) {
        if (launchImageType == LLDarkLaunchImageTypeVerticalDark) {
            isVertical = YES;
        }
    }
    
    /// 调整图片大小与启动图一致
    replaceImage = [replaceImage resizeImageWithDirection:isVertical];
    
    NSData *replaceImageData = UIImageJPEGRepresentation(replaceImage, quality);
    if (!replaceImageData) return NO;
    
    // 替换启动图
    BOOL __block result = [self launchImageCustomBlock:^(NSString *tmpDirectory) {
        NSString *imageName = LaunchImageNameFromLaunchImageType(launchImageType);
        NSDictionary *launchImageInfo = [NSUserDefaults.standardUserDefaults objectForKey:llDark_launchImageInfoIdentifier];
        imageName = [launchImageInfo objectForKey:imageName];
        
        if (imageName == nil) result = NO;
        
        if (imageName) {
            NSString *fullPath = [tmpDirectory stringByAppendingPathComponent:imageName];
            UIImage *originImage = [UIImage imageWithContentsOfFile:fullPath];
            
            BOOL result = !validationBlock ? YES : validationBlock(originImage, replaceImage);
            if (result == YES) {
                [replaceImageData writeToFile:fullPath atomically:YES];
            }
        }
    }];
    
    if (result == NO) return NO;
    
    if (isInitiative) {
        // 备份replaceImage
        NSString *customLaunchImageFullPath = [customLaunchImageBackupPath() stringByAppendingPathComponent:[LaunchImageNameFromLaunchImageType(launchImageType) stringByAppendingString:@".png"]];
        if (isReplace) {
            [replaceImageData writeToFile:customLaunchImageFullPath atomically:YES];
        } else {
            [NSFileManager.defaultManager removeItemAtPath:customLaunchImageFullPath error:nil];
        }
    }
    
    if (isInitiative) {
        // 记录启动图修改记录
        NSMutableDictionary *modifyDictionary = [[NSUserDefaults.standardUserDefaults objectForKey:llDark_launchImageModifyIdentifier] mutableCopy];
        [modifyDictionary setObject:isReplace ? @"YES" : @"NO" forKey:LaunchImageNameFromLaunchImageType(launchImageType)];
        [NSUserDefaults.standardUserDefaults setObject:modifyDictionary.copy forKey:llDark_launchImageModifyIdentifier];
    }
    
    return YES;
}

+ (void)initialize {
    NSMutableDictionary *modifyDictionary = [[NSUserDefaults.standardUserDefaults objectForKey:llDark_launchImageModifyIdentifier] mutableCopy];
    if (modifyDictionary == nil) {
        modifyDictionary = [NSMutableDictionary dictionary];
        [modifyDictionary setObject:@"NO" forKey:LaunchImageNameFromLaunchImageType(LLDarkLaunchImageTypeVerticalLight)];
        [modifyDictionary setObject:@"NO" forKey:LaunchImageNameFromLaunchImageType(LLDarkLaunchImageTypeHorizontalLight)];
        if (@available(iOS 13.0, *)) {
            [modifyDictionary setObject:@"NO" forKey:LaunchImageNameFromLaunchImageType(LLDarkLaunchImageTypeVerticalDark)];
            [modifyDictionary setObject:@"NO" forKey:LaunchImageNameFromLaunchImageType(LLDarkLaunchImageTypeHorizontalDark)];
        }
        [NSUserDefaults.standardUserDefaults setObject:modifyDictionary.copy forKey:llDark_launchImageModifyIdentifier];
    }
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *old_app_version = [NSUserDefaults.standardUserDefaults objectForKey:@"llDark_launchImage_app_version_identifier"];
    
    if ([app_version isEqualToString:old_app_version] == NO) {
        NSMutableDictionary *versionDictionary = [[NSUserDefaults.standardUserDefaults objectForKey:llDark_launchImageVersionIdentifier] mutableCopy];
        if (versionDictionary == nil) versionDictionary = [NSMutableDictionary dictionary];
        
        [versionDictionary setObject:@"YES" forKey:NSStringFromSelector(@selector(didFinishLaunching))];
        [versionDictionary setObject:@"YES" forKey:NSStringFromSelector(@selector(initialization))];
        [versionDictionary setObject:@"YES" forKey:NSStringFromSelector(@selector(backupSystemLaunchImage))];
        [versionDictionary setObject:@"YES" forKey:NSStringFromSelector(@selector(repairException))];
        
        [NSUserDefaults.standardUserDefaults setObject:versionDictionary.copy forKey:llDark_launchImageVersionIdentifier];
        
        [NSUserDefaults.standardUserDefaults setObject:app_version forKey:@"llDark_launchImage_app_version_identifier"];
    }
    
    [self initialization];
}

+ (void)initialization {
    [self launchImageIsNewVersion:^{
        [self launchImageCustomBlock:^(NSString *tmpDirectory) {
            
            // 记录启动图信息
            NSMutableDictionary *infoDictionary = [NSMutableDictionary dictionary];
            for (NSString *name in [NSFileManager.defaultManager contentsOfDirectoryAtPath:tmpDirectory error:nil]) {
                if ([self isSnapShotSuffix:name] == NO) continue;
                
                UIImage *tmpImage = [UIImage imageWithContentsOfFile:[tmpDirectory stringByAppendingPathComponent:name]];
                if (@available(iOS 13.0, *)) {
                    BOOL hasDarkImage = LLLaunchScreen.hasDarkImageBlock(tmpImage);
                    
                    if (tmpImage.size.width < tmpImage.size.height) {
                        if (hasDarkImage) {// 竖屏深色启动图
                            [infoDictionary setObject:name forKey:LaunchImageNameFromLaunchImageType(LLDarkLaunchImageTypeVerticalDark)];
                        } else {// 竖屏浅色启动图
                            [infoDictionary setObject:name forKey:LaunchImageNameFromLaunchImageType(LLDarkLaunchImageTypeVerticalLight)];
                        }
                    } else {
                        if (hasDarkImage) {// 横屏深色启动图
                            [infoDictionary setObject:name forKey:LaunchImageNameFromLaunchImageType(LLDarkLaunchImageTypeHorizontalDark)];
                        } else {// 横屏浅色启动图
                            [infoDictionary setObject:name forKey:LaunchImageNameFromLaunchImageType(LLDarkLaunchImageTypeHorizontalLight)];
                        }
                    }
                } else {
                    if (tmpImage.size.width < tmpImage.size.height) {// 竖屏浅色启动图
                        [infoDictionary setObject:name forKey:LaunchImageNameFromLaunchImageType(LLDarkLaunchImageTypeVerticalLight)];
                    } else {// 横屏浅色启动图
                        [infoDictionary setObject:name forKey:LaunchImageNameFromLaunchImageType(LLDarkLaunchImageTypeHorizontalLight)];
                    }
                }
                
            }
            
            [NSUserDefaults.standardUserDefaults setObject:infoDictionary.copy forKey:llDark_launchImageInfoIdentifier];
        }];
    } identifier:NSStringFromSelector(@selector(initialization))];
}

+ (void)backupSystemLaunchImage {
    [self launchImageIsNewVersion:^{
        NSString *backupPath = originLaunchImageFullBackupPath();
        
        // 1.删除原始启动图备份文件
        for (NSString *name in [NSFileManager.defaultManager contentsOfDirectoryAtPath:backupPath error:nil]) {
            NSString *fullPath = [backupPath stringByAppendingPathComponent:name];
            [NSFileManager.defaultManager removeItemAtPath:fullPath error:nil];
        }
        
        // 2.生成APP的启动图对象
        UIImage *verticalLightImage, *verticalDarkImage, *horizontalLightImage, *horizontalDarkImage;
        if (@available(iOS 13.0, *)) {
            verticalDarkImage = [self createLaunchimageFromSnapshotStoryboardWithisPortrait:YES isDark:YES];
        }
        verticalLightImage = [self createLaunchimageFromSnapshotStoryboardWithisPortrait:YES isDark:NO];
        
        if (supportHorizontalScreen()) {
            horizontalLightImage = [self createLaunchimageFromSnapshotStoryboardWithisPortrait:NO isDark:NO];
            if (@available(iOS 13.0, *)) {
                horizontalDarkImage = [self createLaunchimageFromSnapshotStoryboardWithisPortrait:NO isDark:YES];
            }
        }
        
        // 本地启动图路径
        NSString *verticalLightPath = [backupPath stringByAppendingPathComponent:[LaunchImageNameFromLaunchImageType(LLDarkLaunchImageTypeVerticalLight) stringByAppendingString:@".png"]];
        NSString *horizontalLightPath = [backupPath stringByAppendingPathComponent:[LaunchImageNameFromLaunchImageType(LLDarkLaunchImageTypeHorizontalLight) stringByAppendingString:@".png"]];
        NSString *verticalDarkPath, *horizontalDarkPath;
        if (@available(iOS 13.0, *)) {
            verticalDarkPath = [backupPath stringByAppendingPathComponent:[LaunchImageNameFromLaunchImageType(LLDarkLaunchImageTypeVerticalDark) stringByAppendingString:@".png"]];
            horizontalDarkPath = [backupPath stringByAppendingPathComponent:[LaunchImageNameFromLaunchImageType(LLDarkLaunchImageTypeHorizontalDark) stringByAppendingString:@".png"]];
        }
        
        // 3.将启动图保存到备份文件夹
        if (verticalLightImage) {
            [UIImageJPEGRepresentation(verticalLightImage, 0.8) writeToFile:verticalLightPath atomically:YES];
        }
        if (verticalDarkImage) {
            [UIImageJPEGRepresentation(verticalDarkImage, 0.8) writeToFile:verticalDarkPath atomically:YES];
        }
        if (horizontalLightImage) {
            [UIImageJPEGRepresentation(horizontalLightImage, 0.8) writeToFile:horizontalLightPath atomically:YES];
        }
        if (horizontalDarkImage) {
            [UIImageJPEGRepresentation(horizontalDarkImage, 0.8) writeToFile:horizontalDarkPath atomically:YES];
        }
        
        if (llDark_launchImage_repairException == YES) {
            [self repairException];
        }
        
        if (llDark_launchImage_restoreAsBefore == YES) {
            [self restoreAsBefore];
        }
    } identifier:NSStringFromSelector(@selector(backupSystemLaunchImage))];
}

+ (nullable UIImage *)launchImageFromLaunchImageType:(LLDarkLaunchImageType)launchImageType {    
    NSString *fullPath = [customLaunchImageBackupPath() stringByAppendingPathComponent:[LaunchImageNameFromLaunchImageType(launchImageType) stringByAppendingString:@".png"]];
    if ([NSFileManager.defaultManager fileExistsAtPath:fullPath]) {
        return [UIImage imageWithContentsOfFile:fullPath];
    }
    
    fullPath = [originLaunchImageFullBackupPath() stringByAppendingPathComponent:[LaunchImageNameFromLaunchImageType(launchImageType) stringByAppendingString:@".png"]];
    if ([NSFileManager.defaultManager fileExistsAtPath:fullPath]) {
        return [UIImage imageWithContentsOfFile:fullPath];
    }
    
    return nil;
}

/// 判断是不是启动图后缀
+ (BOOL)isSnapShotSuffix:(NSString *)name {
    // 新系统后缀
    if ([name hasSuffix:@".ktx"]) return YES;
    // 老系统后缀
    if ([name hasSuffix:@".png"]) return YES;
    return NO;
}

BOOL supportHorizontalScreen(void) {
    NSArray *t_array = [NSBundle.mainBundle.infoDictionary objectForKey:@"UISupportedInterfaceOrientations"];
    if ([t_array containsObject:@"UIInterfaceOrientationLandscapeLeft"] ||
        [t_array containsObject:@"UIInterfaceOrientationLandscapeRight"]) {
        return YES;
    } else {
        return NO;
    }
}

NSString * launchScreenName(void) {
    static NSString *launchScreenName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *info = NSBundle.mainBundle.infoDictionary;
        launchScreenName = [info objectForKey:@"UILaunchStoryboardName"];
    });
    return launchScreenName;
}

+ (BOOL)launchImageCustomBlock:(void (^) (NSString *tmpDirectory))complete {
    /// 获取系统启动图路径
    NSString *systemDirectory = systemLaunchImagePath();
    if (!systemDirectory) return NO;
    
    // 工作目录
    NSString *tmpDirectory = ({
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *tmpDirectory = [rootPath stringByAppendingPathComponent:@"LLDark_LaunchImage_tmp"];
        tmpDirectory;
    });
    
    // 清理工作目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:tmpDirectory]) {
        [fileManager removeItemAtPath:tmpDirectory error:nil];
    }
    
    // 移动系统启动图文件夹至工作目录
    BOOL moveResult = [fileManager moveItemAtPath:systemDirectory toPath:tmpDirectory error:nil];
    if (!moveResult) return NO;
    
    !complete ?: complete(tmpDirectory);
    
    // 还原系统启动图信息
    moveResult = [fileManager moveItemAtPath:tmpDirectory toPath:systemDirectory error:nil];
    
    // 清理工作目录
    if ([fileManager fileExistsAtPath:tmpDirectory]) {
        [fileManager removeItemAtPath:tmpDirectory error:nil];
    }
    
    return YES;
}


/// 根据标识符判断是否是新版本
+ (void)launchImageIsNewVersion:(void (^) (void))complete identifier:(NSString *)identifier {
#ifdef DEBUG
    !complete ?: complete();
#else
    NSMutableDictionary *versionDictionary = [[NSUserDefaults.standardUserDefaults objectForKey:llDark_launchImageVersionIdentifier] mutableCopy];
    
    NSString *isNewVersion = [versionDictionary objectForKey:identifier];
    
    if ([isNewVersion isEqualToString:@"YES"]) {
        !complete ?: complete();
        [versionDictionary setObject:@"NO" forKey:identifier];
        [NSUserDefaults.standardUserDefaults setObject:versionDictionary.copy forKey:llDark_launchImageVersionIdentifier];
    }
#endif
}

NSString * LaunchImageNameFromLaunchImageType(LLDarkLaunchImageType launchImageType) {
    switch (launchImageType) {
        case LLDarkLaunchImageTypeVerticalLight:
            return @"LLDarkLaunchImageTypeVerticalLight";
        case LLDarkLaunchImageTypeVerticalDark:
            return @"LLDarkLaunchImageTypeVerticalDark";
        case LLDarkLaunchImageTypeHorizontalLight:
            return @"LLDarkLaunchImageTypeHorizontalLight";
        case LLDarkLaunchImageTypeHorizontalDark:
            return @"LLDarkLaunchImageTypeHorizontalDark";
    }
}

LLDarkLaunchImageType LaunchImageTypeFromLaunchImageName(NSString *launchImageName) {
    if ([launchImageName isEqualToString:@"LLDarkLaunchImageTypeVerticalDark"]) {
        if (@available(iOS 13.0, *)) {
            return LLDarkLaunchImageTypeVerticalDark;
        } else {
            return LLDarkLaunchImageTypeVerticalLight;
        }
    }
    
    if ([launchImageName isEqualToString:@"LLDarkLaunchImageTypeHorizontalLight"]) {
        return LLDarkLaunchImageTypeHorizontalLight;
    }
    
    if ([launchImageName isEqualToString:@"LLDarkLaunchImageTypeHorizontalDark"]) {
        if (@available(iOS 13.0, *)) {
            return LLDarkLaunchImageTypeHorizontalDark;
        } else {
            return LLDarkLaunchImageTypeHorizontalLight;
        }
    } else {
        return LLDarkLaunchImageTypeVerticalLight;
    }
}

+ (BOOL (^)(UIImage * _Nonnull))hasDarkImageBlock {
    static BOOL (^hasDarkImageBlock) (UIImage *) = ^(UIImage *image) {
        return image.hasDarkImage;
    };
    return hasDarkImageBlock;
}

+ (void)setHasDarkImageBlock:(BOOL (^)(UIImage * _Nonnull))hasDarkImageBlock {
    if (hasDarkImageBlock) {
        LLLaunchScreen.hasDarkImageBlock = hasDarkImageBlock;
    }
}

BOOL doesExistsOriginLaunchImage(void) {
    for (NSString *obj in [NSFileManager.defaultManager contentsOfDirectoryAtPath:originLaunchImageFullBackupPath() error:nil]) {
        if ([LLLaunchScreen isSnapShotSuffix:obj] == YES) {
            return YES;
        }
    }
    return NO;
}

NSString * systemLaunchImagePath(void) {
    NSString *bundleID = [NSBundle mainBundle].infoDictionary[@"CFBundleIdentifier"];

    NSString *snapshotsPath;
    if (@available(iOS 13.0, *)) {
        NSString *libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
        snapshotsPath = [NSString stringWithFormat:@"%@/SplashBoard/Snapshots/%@ - {DEFAULT GROUP}", libraryDirectory, bundleID];
    } else {
        NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        snapshotsPath = [[cachesDirectory stringByAppendingPathComponent:@"Snapshots"] stringByAppendingPathComponent:bundleID];
    }
    
    if ([NSFileManager.defaultManager fileExistsAtPath:snapshotsPath]) return snapshotsPath;
    
    return nil;
}

NSString * customLaunchImageBackupPath(void) {
    return (id)[LLLaunchScreen createFolder:@"llDark_custom_launchImage_backup_rootpath"];
}

NSString * originLaunchImageFullBackupPath(void) {
    return (id)[LLLaunchScreen createFolder:@"llDark_origin_launchImage_backup_rootpath"];
}

+ (NSString *)createFolder:(NSString *)folderName {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"LLDark/LaunchImage"];
    NSString *fullPath = [rootPath stringByAppendingPathComponent:folderName];
    if ([NSFileManager.defaultManager fileExistsAtPath:fullPath] == NO) {
        [NSFileManager.defaultManager createDirectoryAtPath:fullPath withIntermediateDirectories:YES attributes:@{} error:nil];
    }
    return fullPath;
}

+ (UIImage *)createLaunchimageFromSnapshotStoryboardWithisPortrait:(BOOL)isPortrait isDark:(BOOL)isDark {
    
    NSArray<UIWindow *> *currentWindows = UIApplication.sharedApplication.windows;
    
    NSArray<NSNumber *> *interfaceStyleArray = ({
        NSMutableArray<NSNumber *> *interfaceStyleArray = [NSMutableArray array];
        if (@available(iOS 13.0, *)) {
            for (UIWindow *window in currentWindows) {
                [interfaceStyleArray addObject:[NSNumber numberWithInteger:window.overrideUserInterfaceStyle]];
            }
        }
        interfaceStyleArray.copy;
    });
        
    if (@available(iOS 13.0, *)) {
        for (UIWindow *currentwindow in currentWindows) {
            if (currentwindow.hidden == NO) {
                if (isDark) {
                    currentwindow.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
                } else {
                    currentwindow.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
                }
            }
        }
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:launchScreenName() bundle:nil];
    UIViewController *launchImageVC = storyboard.instantiateInitialViewController;
    launchImageVC.view.frame = [UIScreen mainScreen].bounds;
    
    if (isPortrait) {
        if (launchImageVC.view.frame.size.width > launchImageVC.view.frame.size.height) {
            launchImageVC.view.frame = CGRectMake(0, 0, launchImageVC.view.frame.size.height, launchImageVC.view.frame.size.width);
        }
    } else {
        if (launchImageVC.view.frame.size.width < launchImageVC.view.frame.size.height) {
            launchImageVC.view.frame = CGRectMake(0, 0, launchImageVC.view.frame.size.height, launchImageVC.view.frame.size.width);
        }
    }
    
    [launchImageVC.view setNeedsLayout];
    [launchImageVC.view layoutIfNeeded];
    
    UIGraphicsBeginImageContextWithOptions(launchImageVC.view.frame.size, NO, [UIScreen mainScreen].scale);
    [launchImageVC.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *launchImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (@available(iOS 13.0, *)) {
        [interfaceStyleArray enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIWindow *window = [currentWindows objectAtIndex:idx];
            window.overrideUserInterfaceStyle = obj.integerValue;
        }];
    }
    
    return launchImage;
}

@end


@implementation UIViewController (LLDark)

+ (void)load {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didFinishLaunching) name:UIApplicationDidFinishLaunchingNotification object:nil];
    self.methodExchange(@selector(viewDidAppear:), @selector(llDark_viewDidAppear:));
}

+ (void)didFinishLaunching {
    [LLLaunchScreen didFinishLaunching];
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIApplicationDidFinishLaunchingNotification object:nil];
}

- (void)llDark_viewDidAppear:(BOOL)animated {
    [self llDark_viewDidAppear:animated];
        
    [LLLaunchScreen backupSystemLaunchImage];
    
    UIViewController.methodExchange(@selector(llDark_viewDidAppear:), @selector(viewDidAppear:));
}

@end
