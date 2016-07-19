//
//  PLMovieViewController.m
//  Joke
//
//  Created by qianfeng on 16/6/23.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import "PLMovieViewController.h"
#import "PLMyTabBar.h"

@interface PLMovieViewController ()

@end

@implementation PLMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

//是否开启旋转功能
- (BOOL)shouldAutorotate {
    return YES;
}

//设置横屏的模式
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (void)viewWillAppear:(BOOL)animated {
    
    for (UIView *view in self.tabBarController.view.subviews) {
        if ([view isKindOfClass:[PLMyTabBar class]]) {
            [UIView animateWithDuration:0.2 animations:^{
                view.hidden = YES;
            }];
            break;
        }
    }
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    for (UIView *view in self.tabBarController.view.subviews) {
        if ([view isKindOfClass:[PLMyTabBar class]]) {
            [UIView animateWithDuration:0.2 animations:^{
                view.hidden = NO;
            }];
            break;
        }
    }
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
