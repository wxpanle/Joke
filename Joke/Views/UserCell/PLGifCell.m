//
//  PLGifCell.m
//  Joke
//
//  Created by qianfeng on 16/6/15.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import "PLGifCell.h"

@implementation PLGifCell

- (void)plCreateOtherUIForPresentCell {

    //视频展示图
    self.gif_thumbnailImageView = [self plCreateCustomImageView];
    
    //gif
    self.gifButton = [self plCreateButtonWithimageName:@"pl_gif.png" target:self selector:@selector(plGifButtonClick:)];
}

- (void)plAddRestrainForPresentCellWithGifImageWidth:(CGFloat)gifWidth andGifHeight:(CGFloat)gifHeight andTextHeight:(CGFloat)textHeight andIsNeedRefreshFont:(BOOL)is {
    
    [self plRefreshFontTypeWithBoolIs:is];

    
    CGFloat x = (SCREEN_W - gifWidth) / 2.f;
    
    self.txLabel.frame = CGRectMake(self.userName.frame.origin.x, CGRectGetMaxX(self.userHeaderImageView.frame) + 10, SCREEN_W - CGRectGetMaxX(self.userHeaderImageView.frame) - 5 - 5, textHeight);
    self.gif_thumbnailImageView.frame = CGRectMake(x, CGRectGetMaxY(self.txLabel.frame) + 5, gifWidth, gifHeight);
    self.gifButton.center = self.gif_thumbnailImageView.center;
}

- (void)plRefreshPresentCellDataWithModel:(PLGifModel *)model {
    
    self.userName.text = model.name;
    [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:model.header]];
    self.txLabel.text = model.text;
    [self.gif_thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:model.gif_thumbnail]];
    //保存缓冲图
    self.images = model.images;
    
    if (self.gifButton.hidden) {
        self.gifButton.hidden = NO;
    }
}

/**
 按钮事件
 */
- (void)plGifButtonClick:(UIButton *)btn {
    
    //将按钮隐藏
    self.gifButton.hidden = YES;
    
    //添加一个菊花
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] init];
    activity.frame = self.gif_thumbnailImageView.frame;
    activity.color = [UIColor whiteColor];
    activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [activity startAnimating];
    [self.contentView addSubview:activity];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.images]];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //加载图片
            self.gif_thumbnailImageView.image = [UIImage sd_animatedGIFWithData:data];
            
            //移除菊花
            [activity removeFromSuperview];
            
        });
    });
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
