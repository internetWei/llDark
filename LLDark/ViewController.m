//
//  ViewController.m
//  LLDark
//
//  Created by LL on 2020/12/1.
//

#import "ViewController.h"

#import <Masonry.h>
#import <YYText.h>
#import <YYWebImage.h>

#import "LLDark.h"

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
    
    NSMutableArray<UIButton *> *t_arr = [NSMutableArray array];
    UIButton *lightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    lightButton.backgroundColor = kBlackColor;
    [lightButton setTitle:@"浅色模式" forState:UIControlStateNormal];
    [lightButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [lightButton addTarget:self action:@selector(lightEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lightButton];
    [t_arr addObject:lightButton];

    UIButton *darkButton = [UIButton buttonWithType:UIButtonTypeSystem];
    darkButton.backgroundColor = kBlackColor;
    [darkButton setTitle:@"深色模式" forState:UIControlStateNormal];
    [darkButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [darkButton addTarget:self action:@selector(darkEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:darkButton];
    [t_arr addObject:darkButton];

    UIButton *systemButton = [UIButton buttonWithType:UIButtonTypeSystem];
    systemButton.backgroundColor = kBlackColor;
    [systemButton setTitle:@"跟随系统" forState:UIControlStateNormal];
    [systemButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [systemButton addTarget:self action:@selector(systemEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:systemButton];
    [t_arr addObject:systemButton];

    [t_arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:30.0 leadSpacing:30.0 tailSpacing:30.0];
    [t_arr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(108.0);
        make.height.mas_equalTo(35.0);
    }];
    
    UIImageView *imageView1 = [[UIImageView alloc] init];
    imageView1.backgroundColor = self.view.backgroundColor;
    imageView1.image = [UIImage themeImage:@"background_light"];
    [self.view addSubview:imageView1];
    [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(systemButton.mas_bottom).offset(15.0);
        make.left.equalTo(self.view).offset(30.0);
        make.right.equalTo(self.view).offset(-30.0);
        make.height.equalTo(imageView1.mas_width).multipliedBy(1.0 / 3.0);
    }];

    UILabel *imageView1Label = [[UILabel alloc] init];
    imageView1Label.text = @"我是本地图片";
    imageView1Label.backgroundColor = kWhiteColor;
    imageView1Label.textColor = kBlackColor;
    imageView1Label.font = [UIFont systemFontOfSize:12.0];
    [imageView1 addSubview:imageView1Label];
    [imageView1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imageView1).offset(-5.0);
        make.bottom.equalTo(imageView1).offset(-5.0);
    }];

    UIImageView *imageView2 = [[UIImageView alloc] init];
    imageView2.backgroundColor = self.view.backgroundColor;
    NSString *url = @"https://cdn.pixabay.com/photo/2017/08/28/14/46/nature-2689795_960_720.jpg";
    [imageView2 yy_setImageWithURL:[NSURL URLWithString:url] options:YYWebImageOptionProgressive];
    imageView2.darkStyle(LLDarkStyleSaturation, 0.1, url);
    [self.view addSubview:imageView2];
    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView1.mas_bottom).offset(10.0);
        make.left.equalTo(self.view).offset(30.0);
        make.width.equalTo(imageView1).multipliedBy(0.5);
        make.height.equalTo(imageView1);
    }];

    UILabel *imageView2Label = [[UILabel alloc] init];
    imageView2Label.numberOfLines = 0;
    imageView2Label.text = @"我是网络图片\n饱合度适配";
    imageView2Label.font = [UIFont systemFontOfSize:12.0];
    imageView2Label.backgroundColor = kWhiteColor;
    imageView2Label.textColor = kBlackColor;
    [imageView2 addSubview:imageView2Label];
    [imageView2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imageView2).offset(-5.0);
        make.bottom.equalTo(imageView2).offset(-5.0);
    }];

    UIImageView *imageView3 = [[UIImageView alloc] init];
    imageView3.backgroundColor = self.view.backgroundColor;
    url = @"https://cdn.pixabay.com/photo/2012/08/06/00/53/bridge-53769_960_720.jpg";
    [imageView3 yy_setImageWithURL:[NSURL URLWithString:url] options:YYWebImageOptionProgressive];
    imageView3.darkStyle(LLDarkStyleMask, 0.5, url);
    [self.view addSubview:imageView3];
    [imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView2.mas_right).offset(10.0);
        make.size.top.equalTo(imageView2);
    }];

    UILabel *imageView3Label = [[UILabel alloc] init];
    imageView3Label.numberOfLines = 0;
    imageView3Label.text = @"我是网络图片\n蒙层适配";
    imageView3Label.font = [UIFont systemFontOfSize:12.0];
    imageView3Label.backgroundColor = kWhiteColor;
    imageView3Label.textColor = kBlackColor;
    [imageView3 addSubview:imageView3Label];
    [imageView3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imageView3).offset(-5.0);
        make.bottom.equalTo(imageView3).offset(-5.0);
    }];

    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = kBlackColor;
    label.textColor = kWhiteColor;
    label.text = @"我是一行UILabel";
    label.font = [UIFont systemFontOfSize:14.0];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView2.mas_bottom).offset(10.0);
        make.left.equalTo(imageView2);
        make.width.mas_equalTo(120.0);
        make.height.mas_equalTo(35.0);
    }];

    YYLabel *yyLabel1 = [[YYLabel alloc] init];
    yyLabel1.numberOfLines = 0;
    yyLabel1.backgroundColor = kBlackColor;
    [self.view addSubview:yyLabel1];
    [yyLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label);
        make.left.equalTo(label.mas_right).offset(15.0);
        make.right.equalTo(self.view).offset(-30.0);
        make.height.equalTo(label);
    }];

    NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:@"我是一行富文本" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName : kWhiteColor}];

    NSMutableAttributedString *attachment = nil;
    attachment = [NSMutableAttributedString yy_attachmentStringWithContent:[UIImage themeImage:@"durk_light"] contentMode:UIViewContentModeCenter width:20.0 ascent:2.0 descent:2.0];
    [text1 appendAttributedString:attachment];

    UISwitch *switchButton = [[UISwitch alloc] init];
    switchButton.onTintColor = kColorRGB(255, 69, 0).themeColor(kColorRGB(30, 144, 255));
    switchButton.thumbTintColor = kColorRGB(30, 144, 255).themeColor(kColorRGB(255, 69, 0));
    attachment = [NSMutableAttributedString yy_attachmentStringWithContent:switchButton contentMode:UIViewContentModeScaleAspectFit width:30.0 ascent:20 descent:0];
    [text1 appendAttributedString:attachment];

    yyLabel1.attributedText = text1;
    
    YYLabel *yyLabel = [[YYLabel alloc] init];
    yyLabel.numberOfLines = 0;
    yyLabel.backgroundColor = kBlackColor;
    [self.view addSubview:yyLabel];
    [yyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(15.0);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(180, 160));
    }];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"秋豫凝仙览，宸游转翠华。 \n 呼鹰下鸟路，戏马出龙沙。 \n 紫菊宜新寿，丹萸辟旧邪。 \n 须陪长久宴，岁岁奉吹花。" attributes:@{NSForegroundColorAttributeName : kWhiteColor, NSFontAttributeName : [UIFont systemFontOfSize:14.0]}];
    [text yy_setTextHighlightRange:NSMakeRange(0, 5) color:kColorRGB(255, 69, 0).themeColor(kColorRGB(30, 144, 255)) backgroundColor:kColorRGB(30, 144, 255).themeColor(kColorRGB(255, 69, 0)) userInfo:nil];
    text.yy_alignment = NSTextAlignmentCenter;
    text.yy_lineSpacing = 10.0;
    
    YYTextBorder *border = [YYTextBorder borderWithLineStyle:YYTextLineStyleSingle lineWidth:1.5 strokeColor:kColorRGB(255, 69, 0).themeColor(kColorRGB(30, 144, 255))];
    border.insets = UIEdgeInsetsMake(-3, -3, -3, -3);
    border.cornerRadius = 10.5;
    [text addAttribute:YYTextBackgroundBorderAttributeName value:border range:NSMakeRange(6, 5)];

    YYTextShadow *shadow = [YYTextShadow shadowWithColor:kColorRGB(255, 69, 0).themeColor(kColorRGB(30, 144, 255)) offset:CGSizeMake(5, 5) radius:0.0];
    [text addAttribute:YYTextShadowAttributeName value:shadow range:NSMakeRange(12, 8)];

    YYTextDecoration *decoration = [YYTextDecoration decorationWithStyle:YYTextLineStyleSingle width:@1.0 color:kColorRGB(255, 69, 0).themeColor(kColorRGB(30, 144, 255))];
    [text addAttribute:YYTextUnderlineAttributeName value:decoration range:NSMakeRange(21, 5)];
    
    yyLabel.attributedText = text;
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width - 100) / 2.0, UIScreen.mainScreen.bounds.size.height - 130, 100, 100);
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 1);
    [self.view.layer addSublayer:layer];
    layer.colors = @[UIColor.redColor.themeColor(UIColor.blueColor), UIColor.greenColor, UIColor.blueColor.themeColor(UIColor.redColor)];
    layer.locations = @[@0.3, @0.6, @0.9];
}


@end
