//
//  AppDelegate.m
//  LLDark
//
//  Created by LL on 2020/12/4.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "OttoFPSButton.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"沙盒路径:%@", NSHomeDirectory());
    sleep(2);
    if (@available(iOS 13.0, *)) {} else {
        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        self.window.backgroundColor = [UIColor whiteColor];
        
        ViewController * vc = [[ViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];

        OttoFPSButton *btn = [OttoFPSButton setTouchWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width - 80, 44, 80, 30) titleFont:[UIFont systemFontOfSize:15.0] backgroundColor:[UIColor colorWithWhite:0.0 alpha:0.7] backgroundImage:nil];
        [self.window addSubview:btn];
    }
    return YES;
}

@end
