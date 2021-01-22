//
//  ViewController.m
//  LLDark <https://github.com/internetWei/llDark>
//
//  Created by LL on 2020/12/4.
//

#import "ViewController.h"

#import "LLDark.h"

#import "YYText.h"
#import "UIImage+YYWebImage.h"

#define kColorRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define kColorRGB(r,g,b) kColorRGBA(r,g,b,1.0)

#define kWhiteColor UIColor.whiteColor.themeColor(nil)

#define kBlackColor kColorRGB(27, 27, 27).themeColor(nil)

#define kHightColor kColorRGB(255, 69, 0).themeColor(kColorRGB(14, 224, 0))

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
        [LLLaunchScreen replaceLaunchImage:image launchImageType:LLDarkLaunchImageTypeVerticalDark compressionQuality:0.8 validation:nil];
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
        [LLLaunchScreen replaceLaunchImage:image launchImageType:LLDarkLaunchImageTypeHorizontalDark compressionQuality:0.8 validation:nil];
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
    [LLLaunchScreen replaceLaunchImage:image launchImageType:LLDarkLaunchImageTypeVerticalLight compressionQuality:0.8 validation:nil];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"浅色竖屏启动图已修改，请切换到对应模式并重启APP" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)changeLightHorizontal {
    NSString *path = [NSBundle.mainBundle pathForResource:@"customHorizontalLightImage" ofType:@".ktx"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    [LLLaunchScreen replaceLaunchImage:image launchImageType:LLDarkLaunchImageTypeHorizontalLight compressionQuality:0.8 validation:nil];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"浅色横屏启动图已修改，请切换到对应模式并重启APP" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)restoreScreen {
    [LLLaunchScreen restoreAsBefore];
    
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
    [lightButton setTitleColor:kHightColor forState:UIControlStateHighlighted];
    [lightButton addTarget:self action:@selector(lightEvent) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:lightButton];
    CGFloat buttonWidth = (screenWidth - 2 * 30 - 2 * 30) / 3.0;
    lightButton.frame = CGRectMake(30.0, 10.0, buttonWidth, 35.0);

    UIButton *darkButton = [UIButton buttonWithType:UIButtonTypeSystem];
    darkButton.backgroundColor = kBlackColor;
    [darkButton setTitle:@"深色模式" forState:UIControlStateNormal];
    [darkButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [darkButton setTitleColor:kHightColor forState:UIControlStateHighlighted];
    [darkButton addTarget:self action:@selector(darkEvent) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:darkButton];
    darkButton.frame = CGRectMake(CGRectGetMaxX(lightButton.frame) + 30.0, CGRectGetMinY(lightButton.frame), buttonWidth, 35.0);

    UIButton *systemButton = [UIButton buttonWithType:UIButtonTypeSystem];
    systemButton.backgroundColor = kBlackColor;
    [systemButton setTitle:@"跟随系统" forState:UIControlStateNormal];
    [systemButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [systemButton setTitleColor:kHightColor forState:UIControlStateHighlighted];
    [systemButton addTarget:self action:@selector(systemEvent) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:systemButton];
    systemButton.frame = CGRectMake(CGRectGetMaxX(darkButton.frame) + 30.0, CGRectGetMinY(lightButton.frame), buttonWidth, 35.0);
    
    UIButton *darkVerticalScreenButton = [UIButton buttonWithType:UIButtonTypeSystem];
    darkVerticalScreenButton.backgroundColor = kBlackColor;
    [darkVerticalScreenButton setTitle:@"修改深色竖屏启动图" forState:UIControlStateNormal];
    [darkVerticalScreenButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [darkVerticalScreenButton setTitleColor:kHightColor forState:UIControlStateHighlighted];
    [darkVerticalScreenButton addTarget:self action:@selector(changeDarkVertical) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:darkVerticalScreenButton];
    darkVerticalScreenButton.frame = CGRectMake(CGRectGetMinX(lightButton.frame), CGRectGetMaxY(systemButton.frame) + 10.0, (screenWidth - 2 * 30.0) / 2.0 - 5.0, 35.0);
    
    UIButton *darkHorizontalScreenButton = [UIButton buttonWithType:UIButtonTypeSystem];
    darkHorizontalScreenButton.backgroundColor = kBlackColor;
    [darkHorizontalScreenButton setTitle:@"修改深色横屏启动图" forState:UIControlStateNormal];
    [darkHorizontalScreenButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [darkHorizontalScreenButton setTitleColor:kHightColor forState:UIControlStateHighlighted];
    [darkHorizontalScreenButton addTarget:self action:@selector(changeDarkHorizontal) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:darkHorizontalScreenButton];
    darkHorizontalScreenButton.frame = CGRectMake(CGRectGetMaxX(darkVerticalScreenButton.frame) + 10.0, CGRectGetMinY(darkVerticalScreenButton.frame), CGRectGetWidth(darkVerticalScreenButton.frame), CGRectGetHeight(darkVerticalScreenButton.frame));
    
    UIButton *lightVerticalScreenButton = [UIButton buttonWithType:UIButtonTypeSystem];
    lightVerticalScreenButton.backgroundColor = kBlackColor;
    [lightVerticalScreenButton setTitle:@"修改浅色竖屏启动图" forState:UIControlStateNormal];
    [lightVerticalScreenButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [lightVerticalScreenButton setTitleColor:kHightColor forState:UIControlStateHighlighted];
    [lightVerticalScreenButton addTarget:self action:@selector(changeLightVertical) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:lightVerticalScreenButton];
    lightVerticalScreenButton.frame = CGRectMake(CGRectGetMinX(darkVerticalScreenButton.frame), CGRectGetMaxY(darkVerticalScreenButton.frame) + 10.0, CGRectGetWidth(darkVerticalScreenButton.frame), CGRectGetHeight(darkVerticalScreenButton.frame));
    
    UIButton *lightHorizontalScreenButton = [UIButton buttonWithType:UIButtonTypeSystem];
    lightHorizontalScreenButton.backgroundColor = kBlackColor;
    [lightHorizontalScreenButton setTitle:@"修改浅色横屏启动图" forState:UIControlStateNormal];
    [lightHorizontalScreenButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [lightHorizontalScreenButton setTitleColor:kHightColor forState:UIControlStateHighlighted];
    [lightHorizontalScreenButton addTarget:self action:@selector(changeLightHorizontal) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:lightHorizontalScreenButton];
    lightHorizontalScreenButton.frame = CGRectMake(CGRectGetMinX(darkHorizontalScreenButton.frame), CGRectGetMaxY(darkHorizontalScreenButton.frame) + 10.0, CGRectGetWidth(darkVerticalScreenButton.frame), CGRectGetHeight(darkVerticalScreenButton.frame));
    
    UIButton *restoreScreenButton = [UIButton buttonWithType:UIButtonTypeSystem];
    restoreScreenButton.backgroundColor = kBlackColor;
    [restoreScreenButton setTitle:@"恢复为初始启动图" forState:UIControlStateNormal];
    [restoreScreenButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [restoreScreenButton setTitleColor:kHightColor forState:UIControlStateHighlighted];
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
    layer.colors = @[UIColor.redColor, UIColor.greenColor, UIColor.blueColor];
    layer.locations = @[@0.3, @0.4, @0.7];
    
    YYLabel *textLabel = [[YYLabel alloc] init];
    textLabel.numberOfLines = 0;
    textLabel.backgroundColor = UIColor.clearColor;
    [scrollView addSubview:textLabel];
    textLabel.frame = CGRectMake(30.0, CGRectGetMaxY(layer.frame) + 20.0, screenWidth - 2 * 30.0, 220);
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"《清明日对酒》 \n 南北山头多墓田，清明祭扫各纷然。\n 纸灰飞作白蝴蝶，泪血染成红杜鹃。 \n 日落狐狸眠冢上，夜归儿女笑灯前。 \n 人生有酒须当醉，一滴何曾到九泉。" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0], NSForegroundColorAttributeName : kBlackColor}];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 10.0;
    style.alignment = NSTextAlignmentCenter;
    [attr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attr.length)];
    
    NSMutableAttributedString *attachment = [NSMutableAttributedString yy_attachmentStringWithEmojiImage:[UIImage themeImage:@"durk_light"] fontSize:21.0];
    [attr insertAttributedString:attachment atIndex:7];
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.color = UIColor.redColor.themeColor(UIColor.orangeColor);
    [indicatorView startAnimating];
    indicatorView.hidesWhenStopped = NO;
    NSMutableAttributedString *attachment1 = [NSMutableAttributedString yy_attachmentStringWithContent:indicatorView contentMode:UIViewContentModeScaleAspectFit width:20 ascent:15 descent:0];
    [attr insertAttributedString:attachment1 atIndex:8];
    
    [attr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:21.0] range:NSMakeRange(0, 7)];
    [attr addAttribute:NSBackgroundColorAttributeName value:UIColor.redColor.themeColor(UIColor.orangeColor) range:NSMakeRange(12, 7)];
    
    YYTextShadow *shadow = [YYTextShadow shadowWithColor:UIColor.redColor.themeColor(UIColor.orangeColor) offset:CGSizeMake(3, 5) radius:0.0];
    [attr addAttribute:YYTextShadowAttributeName value:shadow range:NSMakeRange(20, 7)];
        
    YYTextDecoration *underline = [YYTextDecoration decorationWithStyle:YYTextLineStyleSingle width:@1.0 color:UIColor.redColor.themeColor(UIColor.orangeColor)];
    [attr addAttribute:YYTextUnderlineAttributeName value:underline range:NSMakeRange(30, 7)];
    
    [attr yy_setTextHighlightRange:NSMakeRange(30, 7) color:kBlackColor backgroundColor:UIColor.orangeColor.themeColor(UIColor.redColor) userInfo:nil];
    
    [attr addAttribute:YYTextStrikethroughAttributeName value:underline range:NSMakeRange(38, 7)];
    
    YYTextBorder *border = [YYTextBorder borderWithLineStyle:YYTextLineStylePatternDot lineWidth:1.0 strokeColor:UIColor.redColor.themeColor(UIColor.orangeColor)];
    [attr addAttribute:YYTextBorderAttributeName value:border range:NSMakeRange(49, 7)];
    
    [attr addAttribute:NSStrokeWidthAttributeName value:@(1.5) range:NSMakeRange(68, 7)];
    [attr addAttribute:NSStrokeColorAttributeName value:kColorRGB(0, 250, 0).themeColor(kColorRGB(255, 215, 0)) range:NSMakeRange(68, 7)];
    //设置中文倾斜
    CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(25 * (CGFloat)M_PI / 180), 1, 0, 0);
    //设置反射。倾斜角度。
    UIFontDescriptor *desc = [UIFontDescriptor fontDescriptorWithName:[UIFont systemFontOfSize:15].fontName matrix:matrix];
    //取得系统字符并设置反射。
    UIFont *italicFont = [UIFont fontWithDescriptor:desc size:14];
    [attr addAttribute:NSFontAttributeName value:italicFont range:NSMakeRange(68, 7)];
    
    textLabel.attributedText = attr;
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(CGFLOAT_MAX, 145) text:textLabel.attributedText];
    
    [textLabel sizeToFit];
    CGRect frame = textLabel.frame;
    frame.size.width = layout.textBoundingRect.size.width;
    CGFloat minX = (screenWidth - CGRectGetWidth(frame)) / 2.0;
    frame.origin.x = minX;
    textLabel.frame = frame;
    
    YYTextBorder *border2 = [YYTextBorder borderWithLineStyle:YYTextLineStyleSingle lineWidth:1.0 strokeColor:UIColor.redColor.themeColor(UIColor.orangeColor)];
    border2.cornerRadius = 5.0;
    border2.insets = UIEdgeInsetsMake(0, CGRectGetWidth(textLabel.frame) / 2.0, 0, 10);
    [attr addAttribute:YYTextBlockBorderAttributeName value:border2 range:NSMakeRange(59, 5)];
    textLabel.attributedText = attr;
    
    textLabel.appearanceBindUpdater = ^(YYLabel * _Nonnull bindView) {
        NSMutableAttributedString *t_attr = [bindView.attributedText mutableCopy];
        CGSize size = CGSizeMake(20, 20);
        if (LLDarkManager.isDarkMode) {
            UIImage *background = [UIImage yy_imageWithSize:size drawBlock:^(CGContextRef context) {
                UIColor *c0 = kColorRGB(221, 255, 7.65);
                UIColor *c1 = kColorRGB(241, 148, 138);
                                
                [c0 setFill];
                CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
                [c1 setStroke];
                CGContextSetLineWidth(context, 2);
                for (int i = 0; i < size.width * 2; i+= 4) {
                    CGContextMoveToPoint(context, i, -2);
                    CGContextAddLineToPoint(context, i - size.height, size.height + 2);
                }
                CGContextStrokePath(context);
            }];
            [t_attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithPatternImage:background] range:NSMakeRange(76, 7)];
            [t_attr addAttribute:(id)kCTForegroundColorAttributeName value:(id)[UIColor colorWithPatternImage:background].CGColor range:NSMakeRange(76, 7)];
        } else {
            UIImage *background = [UIImage yy_imageWithSize:size drawBlock:^(CGContextRef context) {
                UIColor *c0 = kColorRGB(221, 255, 7.65);
                UIColor *c1 = kColorRGB(13.77, 224, 0);
                
                [c0 setFill];
                CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
                [c1 setStroke];
                CGContextSetLineWidth(context, 2);
                for (int i = 0; i < size.width * 2; i+= 4) {
                    CGContextMoveToPoint(context, i, -2);
                    CGContextAddLineToPoint(context, i - size.height, size.height + 2);
                }
                CGContextStrokePath(context);
            }];
            [t_attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithPatternImage:background] range:NSMakeRange(76, 7)];
            [t_attr addAttribute:(id)kCTForegroundColorAttributeName value:(id)[UIColor colorWithPatternImage:background].CGColor range:NSMakeRange(76, 7)];
        }
        bindView.attributedText = t_attr;
    };
    
    scrollView.contentSize = CGSizeMake(screenWidth, CGRectGetMaxY(textLabel.frame));
}

@end
