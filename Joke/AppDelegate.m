//
//  AppDelegate.m
//  Joke
//
//  Created by qianfeng on 16/6/15.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "PLMyViewController.h"
#import "PLMyTabBar.h"

@interface AppDelegate () {
    UIView *_view;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    //初始化tabBar
    [self plCreateTabBarController];
    
    BOOL is = [[[NSUserDefaults standardUserDefaults] objectForKey:@"plAgreeToProvision"] boolValue];
    if (!is) {
        //添加视图用于同意条款
        [self plAgreeToProvision];
    }
    
    return YES;
}

/**
 条款
 */
- (void)plAgreeToProvision {
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor whiteColor];
    _view = view;
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [view addSubview:label];
    label.text = @"请仔细阅读以下条款\n(1)该app的所有内容目的仅仅是为了娱乐.\n(2)若有内容使你反感,请忽略此内容,为此给你带来的不悦,我们深表歉意.\n(3)所有内容不提供下载和转发,在您app结束进程后,会自动消失.\n(4)由于技术有限,我们会在之后的版本中提供反馈机制,以用来消除反感内容.\n(5)非常感谢您的理解.";
    [self.window addSubview:view];
    
    CGFloat height = [self plGetHeightForString:label.text andFontSize:15];
    
    label.frame = CGRectMake(0, 40, self.window.bounds.size.width, height);
    
    //添加按钮
    UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    agreeBtn.frame = CGRectMake(self.window.bounds.size.width / 2.0 - 30, label.frame.size.height + 100 , 60, 30);
    [agreeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    agreeBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
    [agreeBtn addTarget:self action:@selector(plAgreeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:agreeBtn];
}

- (void)plAgreeButtonClicked:(UIButton *)btn {
    [_view removeFromSuperview];
    _view = nil;
    
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"plAgreeToProvision"];
}

- (void)plCreateTabBarController {
    
    ViewController *VC = [[ViewController alloc] init];
    UINavigationController *vcNAV = [[UINavigationController alloc] initWithRootViewController:VC];
    [self plChangeNavigationBarTitleTextAttributesWithNavigationController:vcNAV];
    
    PLMyViewController *myVC = [[PLMyViewController alloc] init];
    UINavigationController *myNAV = [[UINavigationController alloc] initWithRootViewController:myVC];
    [self plChangeNavigationBarTitleTextAttributesWithNavigationController:myNAV];
    
    UITabBarController *tbc = [[UITabBarController alloc] init];
    tbc.viewControllers = @[vcNAV, myNAV];

    PLMyTabBar *myTabBar = [PLMyTabBar sharedPLMyTabBarWithFrame:CGRectMake(0, SCREEN_H - 49, SCREEN_W, 49)];
    [myTabBar plCreateMyTabBarWithTabBarController:tbc];
    [tbc.view addSubview:myTabBar];
    
    [tbc.tabBar setHidden:YES];
    
    self.window.rootViewController = tbc;
}

#pragma mark ----导航栏相关----
/**
 修改导航栏属性
 */
- (void)plChangeNavigationBarTitleTextAttributesWithNavigationController:(UINavigationController *)nav {
    
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"pl_tabbarbg.jpg"] forBarMetrics:UIBarMetricsDefault];
    
    BOOL fontType = [[[NSUserDefaults standardUserDefaults] objectForKey:@"typeface"] boolValue];
    
    if (fontType) {
        nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:50 / 255.0 green:150 / 255.0 blue:220 / 255.0 alpha:1.0f], NSFontAttributeName : [UIFont fontWithName:@"chen  dai  ming" size:20]};
    } else {
        nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:50 / 255.0 green:150 / 255.0 blue:220 / 255.0 alpha:1.0f], NSFontAttributeName : [UIFont systemFontOfSize:20]};
    }
}

- (float) plGetHeightForString:(NSString *)value andFontSize:(CGFloat)size
{
    CGFloat titleHeight;
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGRect frame = [value boundingRectWithSize:CGSizeMake(self.window.bounds.size.width, CGFLOAT_MAX) options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil];
    
    titleHeight = ceilf(frame.size.height);
    
    return titleHeight+2;  // 加两个像素,防止emoji被切掉.
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
