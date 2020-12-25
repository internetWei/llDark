//
//  SceneDelegate.m
//  LLDark
//
//  Created by LL on 2020/12/4.
//

#import "SceneDelegate.h"

#import "ViewController.h"
#import "OttoFPSButton.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions  API_AVAILABLE(ios(13.0)){
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.windowScene = windowScene;
    self.window.backgroundColor = [UIColor whiteColor];
    
    ViewController * vc = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];

    OttoFPSButton *btn = [OttoFPSButton setTouchWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width - 80, 44, 80, 30) titleFont:[UIFont systemFontOfSize:15.0] backgroundColor:[UIColor colorWithWhite:0.0 alpha:0.7] backgroundImage:nil];
    [self.window addSubview:btn];
}

@end
