//
//  ViewController.m
//  LLDark
//
//  Created by LL on 2020/12/4.
//

#import "ViewController.h"

#import "LLDark.h"

#define kColorRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define kColorRGB(r,g,b) kColorRGBA(r,g,b,1.0)

#define kWhiteColor UIColor.whiteColor.themeColor(nil)

#define kBlackColor kColorRGB(27, 27, 27).themeColor(nil)

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

- (void)viewDidLoad {
    [super viewDidLoad];

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

    UIButton *lightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    lightButton.backgroundColor = kBlackColor;
    [lightButton setTitle:@"浅色模式" forState:UIControlStateNormal];
    [lightButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [lightButton addTarget:self action:@selector(lightEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lightButton];
    CGFloat buttonWidth = (screenWidth - 2 * 30 - 2 * 30) / 3.0;
    lightButton.frame = CGRectMake(30.0, 108.0, buttonWidth, 35.0);

    UIButton *darkButton = [UIButton buttonWithType:UIButtonTypeSystem];
    darkButton.backgroundColor = kBlackColor;
    [darkButton setTitle:@"深色模式" forState:UIControlStateNormal];
    [darkButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [darkButton addTarget:self action:@selector(darkEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:darkButton];
    darkButton.frame = CGRectMake(CGRectGetMaxX(lightButton.frame) + 30.0, 108.0, buttonWidth, 35.0);

    UIButton *systemButton = [UIButton buttonWithType:UIButtonTypeSystem];
    systemButton.backgroundColor = kBlackColor;
    [systemButton setTitle:@"跟随系统" forState:UIControlStateNormal];
    [systemButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [systemButton addTarget:self action:@selector(systemEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:systemButton];
    systemButton.frame = CGRectMake(CGRectGetMaxX(darkButton.frame) + 30.0, 108.0, buttonWidth, 35.0);

    UIImageView *imageView1 = [[UIImageView alloc] init];
    imageView1.backgroundColor = self.view.backgroundColor;
    imageView1.image = [UIImage themeImage:@"background_light"];
    [self.view addSubview:imageView1];
    imageView1.frame = CGRectMake(30.0, CGRectGetMaxY(systemButton.frame) + 10.0, screenWidth - 2 * 30.0, (screenWidth - 2 * 30.0) / 3.0);

    UILabel *imageView1Label = [[UILabel alloc] init];
    imageView1Label.text = @"我是本地图片";
    imageView1Label.textAlignment = NSTextAlignmentCenter;
    imageView1Label.backgroundColor = kWhiteColor;
    imageView1Label.textColor = kBlackColor;
    imageView1Label.font = [UIFont systemFontOfSize:12.0];
    [imageView1 addSubview:imageView1Label];
    imageView1Label.frame = CGRectMake(CGRectGetWidth(imageView1.frame) - 85.0, CGRectGetHeight(imageView1.frame) - 25.0, 80.0, 20.0);

    UIImageView *imageView2 = [[UIImageView alloc] init];
    imageView2.backgroundColor = self.view.backgroundColor;
    NSString *url = @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQdtAQN_zfOEnQCm7BIslj9KoF4YenOe7pYbw&usqp=CAU";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView2.image = image;
        });
    });
    imageView2.darkStyle(LLDarkStyleSaturation, 0.1, url);
    [self.view addSubview:imageView2];
    imageView2.frame = CGRectMake(30.0, CGRectGetMaxY(imageView1.frame) + 10.0, CGRectGetWidth(imageView1.frame) / 2.0, CGRectGetHeight(imageView1.frame));

    UILabel *imageView2Label = [[UILabel alloc] init];
    imageView2Label.numberOfLines = 2;
    imageView2Label.textAlignment = NSTextAlignmentCenter;
    imageView2Label.text = @"我是网络图片\n饱合度适配";
    imageView2Label.font = [UIFont systemFontOfSize:12.0];
    imageView2Label.backgroundColor = kWhiteColor;
    imageView2Label.textColor = kBlackColor;
    [imageView2 addSubview:imageView2Label];
    imageView2Label.frame = CGRectMake(CGRectGetWidth(imageView2.frame) - 85.0, CGRectGetHeight(imageView2.frame) - 45.0, 80.0, 40.0);

    UIImageView *imageView3 = [[UIImageView alloc] init];
    imageView3.backgroundColor = self.view.backgroundColor;
    url = @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTq6_irvtrL7374-mW6_a1f_ly9RuuMpPRV0w&usqp=CAU";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView3.image = image;
        });
    });
    imageView3.darkStyle(LLDarkStyleMask, 0.5, url);
    [self.view addSubview:imageView3];
    imageView3.frame = CGRectMake(CGRectGetMaxX(imageView2.frame), CGRectGetMinY(imageView2.frame), CGRectGetWidth(imageView2.frame), CGRectGetHeight(imageView2.frame));

    UILabel *imageView3Label = [[UILabel alloc] init];
    imageView3Label.numberOfLines = 2;
    imageView3Label.textAlignment = NSTextAlignmentCenter;
    imageView3Label.text = @"我是网络图片\n蒙层适配";
    imageView3Label.font = [UIFont systemFontOfSize:12.0];
    imageView3Label.backgroundColor = kWhiteColor;
    imageView3Label.textColor = kBlackColor;
    [imageView3 addSubview:imageView3Label];
    imageView3Label.frame = CGRectMake(CGRectGetWidth(imageView3.frame) - 85.0, CGRectGetHeight(imageView3.frame) - 45.0, 80.0, 40.0);

    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = kBlackColor;
    label.textColor = kWhiteColor;
    label.text = @"我是一行UILabel";
    label.font = [UIFont systemFontOfSize:14.0];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    label.frame = CGRectMake(CGRectGetMinX(imageView2.frame), CGRectGetMaxY(imageView2.frame) + 10.0, 120.0, 35.0);

    UILabel *label1 = [[UILabel alloc] init];
    label1.numberOfLines = 0;
    label1.backgroundColor = kBlackColor;
    [self.view addSubview:label1];
    label1.frame = CGRectMake(CGRectGetMaxX(label.frame) + 15.0, CGRectGetMinY(label.frame), screenWidth - CGRectGetMaxX(label.frame) - 30.0 - 15.0, 35.0);

    NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:@"我是一行富文本" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName : kWhiteColor}];

    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage themeImage:@"durk_light"];
    attach.bounds = CGRectMake(0, 0, 20.0, 20.0);
    NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
    [text1 appendAttributedString:attachString];

    label1.attributedText = text1;

    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width - 100) / 2.0, UIScreen.mainScreen.bounds.size.height - 130, 100, 100);
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 1);
    [self.view.layer addSublayer:layer];
    layer.colors = @[UIColor.redColor.themeColor(UIColor.blueColor), UIColor.greenColor, UIColor.blueColor.themeColor(UIColor.redColor)];
    layer.locations = @[@0.3, @0.6, @0.9];
}

@end
