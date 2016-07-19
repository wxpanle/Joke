//
//  PLMyTabBar.m
//  Joke
//
//  Created by qianfeng on 16/6/21.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import "PLMyTabBar.h"
#import "ViewController.h"

@implementation PLMyTabBar {
    UIBezierPath *_leftPath;
    UIBezierPath *_middlePath;
    UIBezierPath *_rightPath;
    UITabBarController *_tbc;
}

static PLMyTabBar *_sharedMyTabBar;

+ (instancetype)sharedPLMyTabBarWithFrame:(CGRect)frame {
    
    if (!_sharedMyTabBar) {
        _sharedMyTabBar = [[PLMyTabBar alloc] initWithFrame:frame];
    }
   
    return _sharedMyTabBar;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1.f];
    }
    
    return self;
}

- (void)plCreateMyTabBarWithTabBarController:(UITabBarController *)tabBarController {
    tabBarController.selectedIndex = 0;
    _tbc = tabBarController;
    
    //创建item
    
    //获取工程路径
    NSString *plistPath = [NSString stringWithFormat:@"%@/PLMyTabBar.plist", [[NSBundle mainBundle] resourcePath]];
    NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    //创建item
    NSInteger index = 0;
    
    for (NSDictionary *dict in [plistDict objectForKey:@"itemArray"]) {
        [self plCReateItemWithItemDictionary:dict andButtonTag:index];
        index++;
    }
    
    //创建add按钮
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addButton setImage:[UIImage imageNamed:@"pl_add.png"] forState:UIControlStateNormal];
    [self.addButton setImage:[UIImage imageNamed:@"pl_reduce.png"] forState:UIControlStateSelected];
    self.addButton.frame = CGRectMake(SCREEN_W / 2.0 - 32 / 2.0, (self.frame.size.height - 32) / 2, 32, 32);
    [self.addButton addTarget:self action:@selector(addButtonClickToChangeResource:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addButton];
    
    _tbc.selectedIndex = 0;
}

/**
 切换资源
 */
- (void)addButtonClickToChangeResource:(UIButton *)btn {
    
    btn.selected = !btn.selected;
    
    UINavigationController *nav = [[_tbc viewControllers] firstObject];
    
    ViewController *vc = [[nav viewControllers] firstObject];
    
    //添加主页
    if (btn.selected == NO) {
        //取消界面
        [vc plReleseButtonFromPresentViews];
    } else if (btn.selected == YES) {
        //弹出界面
        [vc plAddButtonForChangeResourcesAndNavagationTitle];
    }

}

/**
 创建item
 */
- (void)plCReateItemWithItemDictionary:(NSDictionary *)itemDict andButtonTag:(NSInteger)tag {
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_W / 2.0 * tag, 0, SCREEN_W / 2.0, self.frame.size.height)];
    baseView.backgroundColor = [UIColor clearColor];
    baseView.tag = tag;
    [self addSubview:baseView];
    
    //按钮
    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (tag == 0) {
        imageButton.frame = CGRectMake(10, (self.frame.size.height - 32) / 2, 32, 32);
        imageButton.selected = YES;
    } else if (tag == 1) {
        imageButton.frame = CGRectMake(baseView.frame.size.width - 50, (self.frame.size.height - 32) / 2, 32, 32);
    }
    imageButton.tag = tag;
    [imageButton setImage:[UIImage imageNamed:[itemDict objectForKey:@"image"]] forState:UIControlStateNormal];
    [imageButton setImage:[UIImage imageNamed:[itemDict objectForKey:@"image_s"]] forState:UIControlStateSelected];
    [imageButton addTarget:self action:@selector(plBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:imageButton];
    
    //文字
    UILabel *label = [[UILabel alloc] init];
    
    if (tag == 0) {
        label.frame = CGRectMake(CGRectGetMaxX(imageButton.frame) + 5, (self.frame.size.height - 20) / 2, 60, 20);
        label.textAlignment = NSTextAlignmentLeft;
    } else if (tag == 1) {
        label.frame = CGRectMake(baseView.frame.size.width - 50 - 5 - 60, (self.frame.size.height - 20) / 2, 60, 20);
        label.textAlignment = NSTextAlignmentRight;
    }
    
    label.textColor = [UIColor colorWithRed:0.66f green:0.72f blue:0.72f alpha:1.00f];
    
    BOOL is = [[[NSUserDefaults standardUserDefaults] objectForKey:@"typeface"] boolValue];
    if (is) {
        label.font = [UIFont fontWithName:@"chen  dai  ming" size:15];
    } else {
        label.font = [UIFont systemFontOfSize:15];
    }
    label.text = [itemDict objectForKey:@"name"];
    [baseView addSubview:label];
    
}

- (void)plBtnClick:(UIButton *)btn {
    
    NSInteger tag = btn.tag;
    
    _tbc.selectedIndex = btn.tag;
    
    if (btn.tag == 1) {
        self.addButton.hidden = YES;
    } else {
        self.addButton.hidden = NO;
    }
    
    for (UIView *view in self.subviews) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            
        } else if (view.tag != tag) {
            ((UIButton *)[view.subviews objectAtIndex:0]).selected = NO;
            ((UILabel *)[view.subviews objectAtIndex:1]).textColor = [UIColor colorWithRed:0.66f green:0.72f blue:0.72f alpha:1.00f];
        } else {
            ((UIButton *)[view.subviews objectAtIndex:0]).selected = YES;
            ((UILabel *)[view.subviews objectAtIndex:1]).textColor = [UIColor colorWithRed:50 / 255.0 green:150 / 255.0 blue:220 / 255.0 alpha:1.0f];
        }
    }
}

- (void)drawRect:(CGRect)rect {
    
    UIColor *color = [UIColor colorWithRed:0 / 255.0 green:190 / 255.0 blue:95 / 255.0 alpha:1.0f];
    
    
    _leftPath = [UIBezierPath bezierPath];
    [_leftPath moveToPoint:CGPointMake(0, self.frame.size.height)];
    [_leftPath addQuadCurveToPoint:CGPointMake(SCREEN_W / 2.0, self.frame.size.height) controlPoint:CGPointMake(0, -45)];
    [color set];
    _leftPath.lineWidth = 2.f;
    _leftPath.lineCapStyle = kCGLineCapRound;
    _leftPath.lineJoinStyle = kCGLineJoinRound;
    [_leftPath stroke];
    
    _middlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(SCREEN_W / 2.0 - 33 / 2.0, (self.frame.size.height - 33) / 2, 33, 33)];
    _middlePath.lineWidth = 2.f;
    _rightPath.lineCapStyle = kCGLineCapRound;
    _rightPath.lineJoinStyle = kCGLineJoinRound;
    [_middlePath stroke];
    
    _rightPath = [UIBezierPath bezierPath];
    [_rightPath moveToPoint:CGPointMake(SCREEN_W, self.frame.size.height)];
    [_rightPath addQuadCurveToPoint:CGPointMake(SCREEN_W / 2.0, self.frame.size.height) controlPoint:CGPointMake(SCREEN_W, -45)];
    _rightPath.lineWidth = 2.f;
    _rightPath.lineCapStyle = kCGLineCapRound;
    _rightPath.lineJoinStyle = kCGLineJoinRound;
    [_rightPath stroke];
}

@end
