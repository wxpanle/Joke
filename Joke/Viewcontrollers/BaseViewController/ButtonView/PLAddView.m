//
//  PLAddView.m
//  Joke
//
//  Created by qianfeng on 16/6/22.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import "PLAddView.h"
#import "ViewController.h"

@implementation PLAddView {
    
    //button按钮
    NSMutableArray *_buttonArray;
    
    //中心点
    NSMutableArray *_centerArray;
    
}


- (instancetype)initWithFrame:(CGRect)frame andButtonArray:(NSArray *)array andRadiu:(NSInteger)radiu {
    if (self = [super initWithFrame:frame]) {
        
        //初始化数组
        _buttonArray = [[NSMutableArray alloc] initWithCapacity:0];
        _centerArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        self.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1];
        
        [self plCreateButtonWithNameAndImageArray:array andRadiu:radiu];
        
        [self plShowAllButtonWithBeginIndex:0];
    }
    return self;
}

/**
 展示btn
 */
- (void)plShowAllButtonWithBeginIndex:(NSInteger)index {
    [UIView animateWithDuration:0.12 animations:^{
        
        UIButton *btn = [_buttonArray objectAtIndex:index];
        NSDictionary *dict = [_centerArray objectAtIndex:index];
        btn.hidden = NO;
        btn.center = CGPointMake([[dict objectForKey:@"centerx"] floatValue] + 10, [[dict objectForKey:@"centery"] floatValue]);
    } completion:^(BOOL finished) {
        NSInteger nextIndex = index + 1;
        
        if (nextIndex < _buttonArray.count) {
            [self plShowAllButtonWithBeginIndex:nextIndex];
        } else {
            return;
        }
    }];
    
}

/**
 创建button并计算中心点
 */
- (void)plCreateButtonWithNameAndImageArray:(NSArray *)array andRadiu:(NSInteger)radiu {
    
    //设置中心点
    CGFloat centerX = self.frame.size.width / 2.0;
    
    //设置中心点
    CGFloat centerY = self.frame.size.height / 2.0;
    
    //设置初始位置
    CGFloat baseAngle = 360 / array.count;
    
    BOOL is = [[[NSUserDefaults standardUserDefaults] objectForKey:@"typeface"] boolValue];
    
    for (NSInteger i = 0; i < array.count; i++) {
        
        NSDictionary *dict = [array objectAtIndex:i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[dict objectForKey:@"title"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], [dict objectForKey:@"image"]]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.tag = i;
        btn.hidden = YES;
        if (is) {
            btn.titleLabel.font = [UIFont fontWithName:@"chen  dai  ming" size:15];
        } else {
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
        }
        [btn addTarget:self action:@selector(plButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i * baseAngle <= 180) {
            btn.titleEdgeInsets = UIEdgeInsetsMake(40, -40, -10, 0);
        } else {
            btn.titleEdgeInsets = UIEdgeInsetsMake(-40, -40, 10, 0);
        }
        //角度转弧度 π/180×角度
        CGFloat s = M_PI / 180 * (i * baseAngle);
        
        CGFloat x = cos(s) * radiu + centerX;
        
        CGFloat y = sin(s) * radiu + centerY;
        
        [_centerArray addObject:@{@"centerx" : [NSString stringWithFormat:@"%f", x], @"centery" : [NSString stringWithFormat:@"%f", y]}];
        [_buttonArray addObject:btn];
        
        btn.frame = CGRectMake(centerX - 20, centerY - 20, 40, 40);
        
        [self addSubview:btn];
    }
}

- (void)plButtonClick:(UIButton *)btn {
    
    //获取根视图
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *responder = [next nextResponder];
        
        if ([responder isKindOfClass:[ViewController class]]) {
            ViewController *vc = (ViewController *)responder;
            [vc plResfreshDataUrlAndRenewDataForCellWithindex:btn.tag];
        }
    }
}

- (void)drawRect:(CGRect)rect {
    for (NSDictionary *dict in _centerArray) {
        [self createLineWithPoint:CGPointMake([[dict objectForKey:@"centerx"] floatValue], [[dict objectForKey:@"centery"] floatValue])];
    }
}

- (void)createLineWithPoint:(CGPoint)point {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    UIColor *color = [UIColor colorWithRed:2 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.1];
    [color set];
    [path moveToPoint:CGPointMake(self.frame.size.width / 2.0 , self.frame.size.height / 2.0)];
    [path addLineToPoint:point];
    path.lineWidth = 2.f;
    // 将path绘制出来
    [path stroke];
}

@end
