//
//  PLImageCell.m
//  Joke
//
//  Created by qianfeng on 16/6/15.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import "PLImageCell.h"
#import "PLBigImage.h"
#import "ViewController.h"

@implementation PLImageCell {
    NSString *_imageWidth;
    NSString *_imageHeight;
}

- (void)plCreateOtherUIForPresentCell {
    
    //图片
    self.showImageView = [self plCreateCustomImageView];
    self.showImageView.userInteractionEnabled = YES;
    
    //放大图片手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(plTapEnlargeImageButtonClick:)];
    //设置点击的数目
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    //设置点击的最小次数
    tapGestureRecognizer.numberOfTapsRequired = 2;
    [self.showImageView addGestureRecognizer:tapGestureRecognizer];
}

- (void)plAddRestrainForPresentCellWithImageWidth:(CGFloat)imageWidth andImageHeight:(CGFloat)imageHeight andTextHeight:(CGFloat)textHeight andIsNeedRefreshFont:(BOOL)is {
    
    [self plRefreshFontTypeWithBoolIs:is];
    
    //计算当前小图的CGRect
    CGRect frame = [PLImageCell plGetEqualHeightByImageWidth:imageWidth andImageHeight:imageHeight];
    
    //距离左
    CGFloat x = frame.origin.x;
    CGFloat w = frame.size.width;
    CGFloat h = frame.size.height;
    
    self.txLabel.frame = CGRectMake(self.userName.frame.origin.x, CGRectGetMaxX(self.userHeaderImageView.frame) + 10, SCREEN_W - CGRectGetMaxX(self.userHeaderImageView.frame) - 5 - 5, textHeight);
    
    self.showImageView.frame = CGRectMake(x, CGRectGetMaxY(self.txLabel.frame) + 5, w, h);
}

- (void)plRefreshPresentCellDataWithModel:(PLImageModel *)model {
    
    self.userName.text = model.name;
    [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:model.header]];
    self.txLabel.text = model.text;
    if (model.small.length != 0) {
        [self.showImageView sd_setImageWithURL:[NSURL URLWithString:model.small]];
    } else if (model.medium.length != 0) {
        [self.showImageView sd_setImageWithURL:[NSURL URLWithString:model.medium]];
    } else if (model.big.length != 0) {
        [self.showImageView sd_setImageWithURL:[NSURL URLWithString:model.big]];
    } else {
        NSLog(@"没有图片可用的url");
    }
    
    //保留当前的宽高以便放大图片时使用
    _imageWidth = model.width;
    _imageHeight = model.height;
    self.big = model.big;
}

/**
 由图片的宽和屏幕的宽高获得等比例的屏幕适配
 */
+ (CGRect)plGetEqualHeightByImageWidth:(CGFloat)imageWidth andImageHeight:(CGFloat)imageHeight {
    
    CGFloat smallWidth = 240.f;
    
    if (imageWidth <= SCREEN_W) {
        CGFloat x = (SCREEN_W - imageWidth) / 2.f;
        return CGRectMake(x, 0, imageWidth, imageHeight);
    }
    
    CGFloat x = (SCREEN_W - smallWidth) / 2.f;
    CGFloat y = 0;
    CGFloat w = smallWidth;
    CGFloat h = imageHeight * smallWidth / imageWidth;
    
    return CGRectMake(x, y, w, h);
    
}

- (void)plTapEnlargeImageButtonClick:(UIButton *)btn {
    
    //加载页面
    PLBigImage *bigImageView = [[PLBigImage alloc] initWithUrl:self.big andImageWidth:[_imageWidth floatValue] andImageHeight:[_imageHeight floatValue]];
    ViewController *vc = (ViewController *)[self plGetViewController];
    
    if (vc) {
        [vc.view addSubview:bigImageView];
        [vc.view bringSubviewToFront:bigImageView];
    } else {
        NSLog(@"没有找到");
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
