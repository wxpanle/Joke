//
//  PLMyTabBar.h
//  Joke
//
//  Created by qianfeng on 16/6/21.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLMyTabBar : UIView

+ (instancetype)sharedPLMyTabBarWithFrame:(CGRect)frame;

@property (nonatomic, strong) UIButton *addButton;

/**
 创建tabBar相关按钮
 */
- (void)plCreateMyTabBarWithTabBarController:(UITabBarController *)tabBarController;

@end
