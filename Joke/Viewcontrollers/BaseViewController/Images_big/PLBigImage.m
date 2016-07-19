//
//  PLBigImage.m
//  VideoPlayer
//
//  Created by qianfeng on 16/6/17.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import "PLBigImage.h"
#import "UIImageView+WebCache.h"

#define PL_SCREEN_WIDTH_OF_SCROLL [[UIScreen mainScreen] bounds].size.width
#define PL_SCREEN_HEIGHT_OF_SCROLL [[UIScreen mainScreen] bounds].size.height
@implementation PLBigImage {
    UIScrollView *_scrollView;
    CGFloat _imageMaxWidth;
    CGFloat _imageMaxHeight;
    UIImageView *_imageView;
}

- (instancetype)initWithUrl:(NSString *)url andImageWidth:(CGFloat)imageWidth andImageHeight:(CGFloat)imageHeight {
    
    if (self = [super initWithFrame:CGRectMake(0, 0, PL_SCREEN_WIDTH_OF_SCROLL, PL_SCREEN_HEIGHT_OF_SCROLL - 64 - 49)]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _imageMaxHeight = imageHeight;
        _imageMaxWidth = imageWidth;
        
        //先添加scrollView
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, PL_SCREEN_WIDTH_OF_SCROLL, PL_SCREEN_HEIGHT_OF_SCROLL - 64 - 49)];
        
        //根据屏幕比例计算适合屏幕的高度
        CGFloat height = PL_SCREEN_WIDTH_OF_SCROLL * imageHeight / imageWidth;
        
        _scrollView.contentSize = CGSizeMake(PL_SCREEN_WIDTH_OF_SCROLL, height);
        
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        //添加imageView
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = CGRectMake(0, 0, PL_SCREEN_WIDTH_OF_SCROLL, height);
        [_scrollView addSubview:_imageView];
        //加载图片
        [_imageView sd_setImageWithURL:[NSURL URLWithString:url]];
        
        //添加双击手势
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapForReleasePresentView:)];
        //设置点击的数目
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        //设置点击的最小次数
        tapGestureRecognizer.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tapGestureRecognizer];
        
        //添加捏合手势
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchForScaleImageView:)];
        [self addGestureRecognizer:pinchGestureRecognizer];
    }
    
    return self;
}

- (void)pinchForScaleImageView:(UIPinchGestureRecognizer *)pinch {
    CGFloat scale = pinch.scale;
    
    //保留高度
    CGFloat y = _imageView.frame.origin.y;
    
    //根据缩放的大小改变图片和scrollview的contentSize
    _imageView.transform = CGAffineTransformMakeScale(scale, scale);
    
    CGRect frame = _imageView.frame;
    
    CGRect tempFrame = CGRectMake(frame.origin.x, y, frame.size.width, frame.size.height);
    
    _imageView.frame = tempFrame;
    
    _scrollView.contentSize = CGSizeMake(_imageView.frame.size.width, _imageView.frame.size.height);
}

- (void)tapForReleasePresentView:(UITapGestureRecognizer *)tap {
    
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
