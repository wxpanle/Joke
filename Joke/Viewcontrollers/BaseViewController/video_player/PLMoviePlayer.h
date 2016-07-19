//
//  PLMoviePlayer.h
//  Joke
//
//  Created by qianfeng on 16/6/12.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PLMoviePlayer : UIView

/**
 初始化方法
 */
- (instancetype)initWithFrame:(CGRect)frame MovieUrl:(NSString *)url;

@property (nonatomic, strong) AVPlayer *player;

/**
 移除视频
 */
- (void)plMoviePlayDidEnd;

@end
