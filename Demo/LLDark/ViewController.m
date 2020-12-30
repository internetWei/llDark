//
//  ViewController.m
//  LLDark
//
//  Created by LL on 2020/12/4.
//

#import "ViewController.h"

#import "LLDark.h"

#import "YYText.h"

#define kColorRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define kColorRGB(r,g,b) kColorRGBA(r,g,b,1.0)

#define kWhiteColor UIColor.whiteColor.themeColor(nil)

#define kBlackColor kColorRGB(27, 27, 27).themeColor(nil)

//  状态栏高度
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)lightEvent {
    LLDarkManager.userInterfaceStyle = LLUserInterfaceStyleLight;
}

- (void)darkEvent {
    LLDarkManager.userInterfaceStyle = LLUserInterfaceStyleDark;
}

- (void)systemEvent {
    LLDarkManager.userInterfaceStyle = LLUserInterfaceStyleUnspecified;
}

- (void)changeStatusBarStyle {
    if (LLDarkManager.isDarkMode) {
        UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
    } else {
        if (@available(iOS 13.0, *)) {
            UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDarkContent;
        } else {
            UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
        }
    }
}

- (void)changeDarkVertical {
    if (@available(iOS 13.0, *)) {
        NSString *path = [NSBundle.mainBundle pathForResource:@"customVerticalDarkImage" ofType:@".ktx"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        LLLaunchScreen.verticalDarkImage = image;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"深色竖屏启动图已修改，请切换到对应模式并重启APP" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"此功能仅能在iOS13以上系统使用" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)changeDarkHorizontal {
    if (@available(iOS 13.0, *)) {
        NSString *path = [NSBundle.mainBundle pathForResource:@"customHorizontalDarkImage" ofType:@".ktx"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        LLLaunchScreen.horizontalDarkImage = image;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"深色横屏启动图已修改，请切换到对应模式并重启APP" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"此功能仅能在iOS13以上系统使用" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)changeLightVertical {
    NSString *path = [NSBundle.mainBundle pathForResource:@"customVerticaLightImage" ofType:@".ktx"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    LLLaunchScreen.verticalLightImage = image;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"浅色竖屏启动图已修改，请切换到对应模式并重启APP" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)changeLightHorizontal {
    NSString *path = [NSBundle.mainBundle pathForResource:@"customHorizontalLightImage" ofType:@".ktx"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    LLLaunchScreen.horizontalLightImage = image;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"浅色横屏启动图已修改，请切换到对应模式并重启APP" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)restoreScreen {
    [LLLaunchScreen restoreLaunchScreeen];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"启动图已恢复至初始化状态，请重启APP" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName : kBlackColor}];
    self.navigationController.navigationBar.barTintColor = kWhiteColor;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(changeStatusBarStyle) name:ThemeDidChangeNotification object:nil];
    [NSNotificationCenter.defaultCenter postNotificationName:ThemeDidChangeNotification object:nil];

    self.themeDidChange = ^(UIViewController * _Nonnull bindView) {
        switch (LLDarkManager.userInterfaceStyle) {
            case LLUserInterfaceStyleUnspecified:
            {
                bindView.navigationItem.title = @"跟随系统";
            }
                break;
            case LLUserInterfaceStyleLight:
            {
                bindView.navigationItem.title = @"浅色模式";
            }
                break;
            case LLUserInterfaceStyleDark:
            {
                bindView.navigationItem.title = @"深色模式";
            }
                break;
        }
    };

    !self.themeDidChange ?: self.themeDidChange(self);
    
    self.view.backgroundColor = kWhiteColor;
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = UIColor.clearColor;
    [self.view addSubview:scrollView];
    scrollView.frame = CGRectMake(0, 0, screenWidth, UIScreen.mainScreen.bounds.size.height - (kStatusBarHeight + 44.0));

    UIButton *lightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    lightButton.backgroundColor = kBlackColor;
    [lightButton setTitle:@"浅色模式" forState:UIControlStateNormal];
    [lightButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [lightButton addTarget:self action:@selector(lightEvent) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:lightButton];
    CGFloat buttonWidth = (screenWidth - 2 * 30 - 2 * 30) / 3.0;
    lightButton.frame = CGRectMake(30.0, 10.0, buttonWidth, 35.0);

    UIButton *darkButton = [UIButton buttonWithType:UIButtonTypeSystem];
    darkButton.backgroundColor = kBlackColor;
    [darkButton setTitle:@"深色模式" forState:UIControlStateNormal];
    [darkButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [darkButton addTarget:self action:@selector(darkEvent) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:darkButton];
    darkButton.frame = CGRectMake(CGRectGetMaxX(lightButton.frame) + 30.0, CGRectGetMinY(lightButton.frame), buttonWidth, 35.0);

    UIButton *systemButton = [UIButton buttonWithType:UIButtonTypeSystem];
    systemButton.backgroundColor = kBlackColor;
    [systemButton setTitle:@"跟随系统" forState:UIControlStateNormal];
    [systemButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [systemButton addTarget:self action:@selector(systemEvent) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:systemButton];
    systemButton.frame = CGRectMake(CGRectGetMaxX(darkButton.frame) + 30.0, CGRectGetMinY(lightButton.frame), buttonWidth, 35.0);
    
    UIButton *darkVerticalScreenButton = [UIButton buttonWithType:UIButtonTypeSystem];
    darkVerticalScreenButton.backgroundColor = kBlackColor;
    [darkVerticalScreenButton setTitle:@"修改深色竖屏启动图" forState:UIControlStateNormal];
    [darkVerticalScreenButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [darkVerticalScreenButton addTarget:self action:@selector(changeDarkVertical) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:darkVerticalScreenButton];
    darkVerticalScreenButton.frame = CGRectMake(CGRectGetMinX(lightButton.frame), CGRectGetMaxY(systemButton.frame) + 10.0, (screenWidth - 2 * 30.0) / 2.0 - 5.0, 35.0);
    
    UIButton *darkHorizontalScreenButton = [UIButton buttonWithType:UIButtonTypeSystem];
    darkHorizontalScreenButton.backgroundColor = kBlackColor;
    [darkHorizontalScreenButton setTitle:@"修改深色横屏启动图" forState:UIControlStateNormal];
    [darkHorizontalScreenButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [darkHorizontalScreenButton addTarget:self action:@selector(changeDarkHorizontal) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:darkHorizontalScreenButton];
    darkHorizontalScreenButton.frame = CGRectMake(CGRectGetMaxX(darkVerticalScreenButton.frame) + 10.0, CGRectGetMinY(darkVerticalScreenButton.frame), CGRectGetWidth(darkVerticalScreenButton.frame), CGRectGetHeight(darkVerticalScreenButton.frame));
    
    UIButton *lightVerticalScreenButton = [UIButton buttonWithType:UIButtonTypeSystem];
    lightVerticalScreenButton.backgroundColor = kBlackColor;
    [lightVerticalScreenButton setTitle:@"修改浅色竖屏启动图" forState:UIControlStateNormal];
    [lightVerticalScreenButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [lightVerticalScreenButton addTarget:self action:@selector(changeLightVertical) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:lightVerticalScreenButton];
    lightVerticalScreenButton.frame = CGRectMake(CGRectGetMinX(darkVerticalScreenButton.frame), CGRectGetMaxY(darkVerticalScreenButton.frame) + 10.0, CGRectGetWidth(darkVerticalScreenButton.frame), CGRectGetHeight(darkVerticalScreenButton.frame));
    
    UIButton *lightHorizontalScreenButton = [UIButton buttonWithType:UIButtonTypeSystem];
    lightHorizontalScreenButton.backgroundColor = kBlackColor;
    [lightHorizontalScreenButton setTitle:@"修改浅色横屏启动图" forState:UIControlStateNormal];
    [lightHorizontalScreenButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [lightHorizontalScreenButton addTarget:self action:@selector(changeLightHorizontal) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:lightHorizontalScreenButton];
    lightHorizontalScreenButton.frame = CGRectMake(CGRectGetMinX(darkHorizontalScreenButton.frame), CGRectGetMaxY(darkHorizontalScreenButton.frame) + 10.0, CGRectGetWidth(darkVerticalScreenButton.frame), CGRectGetHeight(darkVerticalScreenButton.frame));
    
    UIButton *restoreScreenButton = [UIButton buttonWithType:UIButtonTypeSystem];
    restoreScreenButton.backgroundColor = kBlackColor;
    [restoreScreenButton setTitle:@"恢复为初始启动图" forState:UIControlStateNormal];
    [restoreScreenButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [restoreScreenButton addTarget:self action:@selector(restoreScreen) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:restoreScreenButton];
    restoreScreenButton.frame = CGRectMake(CGRectGetMinX(darkVerticalScreenButton.frame), CGRectGetMaxY(lightVerticalScreenButton.frame) + 10.0, screenWidth - 2 * 30.0, CGRectGetHeight(darkVerticalScreenButton.frame));

    UIImageView *imageView1 = [[UIImageView alloc] init];
    imageView1.backgroundColor = self.view.backgroundColor;
    imageView1.image = [UIImage themeImage:@"background_light"];
    [scrollView addSubview:imageView1];
    imageView1.frame = CGRectMake(30.0, CGRectGetMaxY(restoreScreenButton.frame) + 10.0, screenWidth - 2 * 30.0, (screenWidth - 2 * 30.0) / 3.0);

    UILabel *imageView1Label = [[UILabel alloc] init];
    imageView1Label.text = @"本地图片";
    imageView1Label.textAlignment = NSTextAlignmentCenter;
    imageView1Label.backgroundColor = kWhiteColor;
    imageView1Label.textColor = kBlackColor;
    imageView1Label.font = [UIFont systemFontOfSize:12.0];
    [imageView1 addSubview:imageView1Label];
    imageView1Label.frame = CGRectMake(CGRectGetWidth(imageView1.frame) - 65.0, CGRectGetHeight(imageView1.frame) - 25.0, 60.0, 20.0);

    UIImageView *imageView2 = [[UIImageView alloc] init];
    imageView2.backgroundColor = self.view.backgroundColor;
    imageView2.contentMode = UIViewContentModeScaleAspectFill;
    imageView2.clipsToBounds = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIImage *image = UIImage.imageNamed(@"webImage");
        imageView2.image = image;
    });
    imageView2.darkStyle(LLDarkStyleSaturation, 0.1, @"webImage_1");
    [scrollView addSubview:imageView2];
    imageView2.frame = CGRectMake(30.0, CGRectGetMaxY(imageView1.frame) + 10.0, (CGRectGetWidth(imageView1.frame) - 10.0) / 2.0, CGRectGetHeight(imageView1.frame));

    UILabel *imageView2Label = [[UILabel alloc] init];
    imageView2Label.numberOfLines = 2;
    imageView2Label.textAlignment = NSTextAlignmentCenter;
    imageView2Label.text = @"网络图片\n饱合度适配";
    imageView2Label.font = [UIFont systemFontOfSize:12.0];
    imageView2Label.backgroundColor = kWhiteColor;
    imageView2Label.textColor = kBlackColor;
    [imageView2 addSubview:imageView2Label];
    imageView2Label.frame = CGRectMake(CGRectGetWidth(imageView2.frame) - 75.0, CGRectGetHeight(imageView2.frame) - 35.0, 70.0, 30.0);

    UIImageView *imageView3 = [[UIImageView alloc] init];
    imageView3.contentMode = UIViewContentModeScaleAspectFill;
    imageView3.backgroundColor = self.view.backgroundColor;
    imageView3.clipsToBounds = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIImage *image = UIImage.imageNamed(@"webImage");
        imageView3.image = image;
    });
    imageView3.darkStyle(LLDarkStyleMask, 0.5, @"webImage_2");
    [scrollView addSubview:imageView3];
    imageView3.frame = CGRectMake(CGRectGetMaxX(imageView2.frame) + 10.0, CGRectGetMinY(imageView2.frame), CGRectGetWidth(imageView2.frame), CGRectGetHeight(imageView2.frame));

    UILabel *imageView3Label = [[UILabel alloc] init];
    imageView3Label.numberOfLines = 2;
    imageView3Label.textAlignment = NSTextAlignmentCenter;
    imageView3Label.text = @"网络图片\n蒙层适配";
    imageView3Label.font = [UIFont systemFontOfSize:12.0];
    imageView3Label.backgroundColor = kWhiteColor;
    imageView3Label.textColor = kBlackColor;
    [imageView3 addSubview:imageView3Label];
    imageView3Label.frame = CGRectMake(CGRectGetWidth(imageView3.frame) - 65.0, CGRectGetHeight(imageView3.frame) - 35.0, 60.0, 30.0);
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = CGRectMake(30.0, CGRectGetMaxY(imageView2.frame) + 10.0, screenWidth - 2 * 30.0, 80.0);
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 1);
    [scrollView.layer addSublayer:layer];
    layer.colors = @[UIColor.redColor.themeColor(UIColor.blueColor), UIColor.greenColor, UIColor.blueColor.themeColor(UIColor.redColor)];
    layer.locations = @[@0.3, @0.6, @0.9];
    
    YYLabel *textLabel = [[YYLabel alloc] init];
    textLabel.numberOfLines = 0;
    textLabel.backgroundColor = UIColor.clearColor;
    [scrollView addSubview:textLabel];
    textLabel.frame = CGRectMake(30.0, CGRectGetMaxY(layer.frame) + 20.0, screenWidth - 2 * 30.0, 120);
    
    /*
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"《游子吟》 \n 慈母手中线，游子身上衣。\n 临行密密缝，意恐迟迟归。 \n 谁言寸草心，报得三春晖。" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0], NSForegroundColorAttributeName : kBlackColor}];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 10.0;
    style.alignment = NSTextAlignmentCenter;
    [attr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attr.length)];
    [attr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17.0] range:NSMakeRange(0, 4)];
    [attr addAttribute:NSBackgroundColorAttributeName value:UIColor.redColor.themeColor(UIColor.orangeColor) range:NSMakeRange(8, 5)];
     
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = UIColor.redColor.themeColor(UIColor.orangeColor);
    shadow.shadowOffset = CGSizeMake(3, 5);
    [attr addAttribute:NSShadowAttributeName value:shadow range:NSMakeRange(14, 5)];
    
    [attr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleThick) range:NSMakeRange(20, 7)];
    [attr addAttribute:NSStrikethroughColorAttributeName value:UIColor.redColor.themeColor(UIColor.orangeColor) range:NSMakeRange(20, 7)];
    [attr addAttribute:NSStrokeWidthAttributeName value:@(1.5) range:NSMakeRange(28, 5)];
    [attr addAttribute:NSStrokeColorAttributeName value:UIColor.blueColor.themeColor(UIColor.redColor) range:NSMakeRange(28, 5)];
    [attr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleDouble) range:NSMakeRange(34, 8)];
    [attr addAttribute:NSUnderlineColorAttributeName value:UIColor.redColor.themeColor(UIColor.orangeColor) range:NSMakeRange(34, 8)];
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage themeImage:@"durk_light"];
    attachment.bounds = CGRectMake(0, 0, 18, 18);
    NSAttributedString *t_attr = [NSAttributedString attributedStringWithAttachment:attachment];
    [attr insertAttributedString:t_attr atIndex:5];
    */
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"《游子吟》 \n 慈母手中线，游子身上衣。\n 临行密密缝，意恐迟迟归。 \n 谁言寸草心，报得三春晖。" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0], NSForegroundColorAttributeName : kBlackColor}];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 10.0;
    style.alignment = NSTextAlignmentCenter;
    [attr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attr.length)];
    
    NSMutableAttributedString *attachment = [NSMutableAttributedString yy_attachmentStringWithEmojiImage:[UIImage themeImage:@"durk_light"] fontSize:21.0];
    [attr insertAttributedString:attachment atIndex:5];
    
    [attr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:21.0] range:NSMakeRange(0, 4)];
    [attr addAttribute:NSBackgroundColorAttributeName value:UIColor.redColor.themeColor(UIColor.orangeColor) range:NSMakeRange(9, 5)];
    
    /*
     NSString *const YYTextBackedStringAttributeName = @"YYTextBackedString";
     NSString *const YYTextBindingAttributeName = @"YYTextBinding";
     
     NSString *const YYTextShadowAttributeName = @"YYTextShadow";
     NSString *const YYTextInnerShadowAttributeName = @"YYTextInnerShadow";
     NSString *const YYTextUnderlineAttributeName = @"YYTextUnderline";
     NSString *const YYTextStrikethroughAttributeName = @"YYTextStrikethrough";
     NSString *const YYTextBorderAttributeName = @"YYTextBorder";
     NSString *const YYTextBackgroundBorderAttributeName = @"YYTextBackgroundBorder";
     NSString *const YYTextBlockBorderAttributeName = @"YYTextBlockBorder";
     NSString *const YYTextAttachmentAttributeName = @"YYTextAttachment";
     NSString *const YYTextHighlightAttributeName = @"YYTextHighlight";
     */
        
    textLabel.attributedText = attr;
    
    scrollView.contentSize = CGSizeMake(screenWidth, CGRectGetMaxY(textLabel.frame));
}

@end
