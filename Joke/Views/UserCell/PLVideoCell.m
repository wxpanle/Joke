//
//  PLVideoCell.m
//  Joke
//
//  Created by qianfeng on 16/6/15.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import "PLVideoCell.h"
#import "PLMoviePlayer.h"

@implementation PLVideoCell

- (void)plCreateOtherUIForPresentCell {
    
    //视频展示图
    self.thumbnailImageView = [self plCreateCustomImageView];
    
    //视频
    self.videoButton = [self plCreateButtonWithimageName:@"pl_play" target:self selector:@selector(plVideoButtonClick:)];
}

- (void)plAddRestrainForPresentCellWithVideoWidth:(CGFloat)videoWidth andVideoHeight:(CGFloat)videoHeight andTextHeight:(CGFloat)textHeight andIsNeedRefreshFont:(BOOL)is {
    
    [self plRefreshFontTypeWithBoolIs:is];
 
    
    CGRect frame = [PLVideoCell plGetEqualHeightByVideoWidthAnd:videoWidth andVideoHeight:videoHeight];
    
    CGFloat x = frame.origin.x;
    CGFloat w = frame.size.width;
    CGFloat h = frame.size.height;
    
    self.txLabel.frame = CGRectMake(self.userName.frame.origin.x, CGRectGetMaxX(self.userHeaderImageView.frame) + 10, SCREEN_W - CGRectGetMaxX(self.userHeaderImageView.frame) - 5 - 5, textHeight);
    
    self.thumbnailImageView.frame = CGRectMake(x, CGRectGetMaxY(self.txLabel.frame) + 5, w, h);
    self.videoButton.center = self.thumbnailImageView.center;
    
}

- (void)plRefreshPresentCellDataWithModel:(PLVideoModel *)model {
    
    self.userName.text = model.name;
    [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:model.header]];
    self.txLabel.text = model.text;
    [self.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]];
    self.videoUrl = model.video;
}

/**
 点击加载视频
 */
- (void)plVideoButtonClick:(UIButton *)btn {
    
    //创建视频页面
    PLMoviePlayer *moviePlayer = [[PLMoviePlayer alloc] initWithFrame:self.thumbnailImageView.frame MovieUrl:self.videoUrl];
    
    [self.contentView addSubview:moviePlayer];
    
}

/**
 由video的宽和屏幕的宽高获得等比例的屏幕适配
 */
+ (CGRect)plGetEqualHeightByVideoWidthAnd:(CGFloat)videoWidth andVideoHeight:(CGFloat)videoHeight {
    //
    if (videoWidth <= SCREEN_W) {
        
        CGFloat x = (SCREEN_W - videoWidth) / 2;
        
        CGFloat y = 0.0f;
        
        CGFloat width = videoWidth;
        
        return CGRectMake(x, y, width, videoHeight);
    }
    
    CGFloat x = 15;
    CGFloat y = 0;
    CGFloat width = SCREEN_W - 30;
    CGFloat scale = videoWidth / width;
    CGFloat height = videoHeight / scale;
    
    return CGRectMake(x, y, width, height);
}

/*

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
