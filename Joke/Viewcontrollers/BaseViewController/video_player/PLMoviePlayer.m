//
//  PLMoviePlayer.m
//  Joke
//
//  Created by qianfeng on 16/6/12.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import "PLMoviePlayer.h"
#import "PLMovieViewController.h"


typedef NS_ENUM(NSInteger, panTranslationState) {
    panTranslationStateLeft,
    panTranslationStateRight
};

@interface PLMoviePlayer () {
    UIView *_presentSuperView;
    CGRect _presentViewFrame;
}

//播放层,AVPlayer的播放层置于此层上
@property (nonatomic, strong) AVPlayerItem *playerItem;

//结束播放
@property (nonatomic, strong) UIButton *closeButton;

//放大按钮
@property (nonatomic, strong) UIButton *enlargeButton;

//播放返回时间监控
@property (nonatomic, strong) id playbackTimeObserver;

//播放按钮(触摸显示)
@property (nonatomic, strong) UIButton *playButton;

//开始的时间label(触摸显示)
@property (nonatomic, strong) UILabel *beginTimeLabel;

//结束时间label(触摸显示)
@property (nonatomic, strong) UILabel *endTimeLabel;

//进度条
@property (nonatomic, strong) UISlider *slider;

//缓冲进度条
@property (nonatomic, strong) UIProgressView *progressView;

//菊花
@property (nonatomic, strong) UIActivityIndicatorView *activity;

//水平滑动时显示进度
@property (nonatomic, strong) UILabel *horizontalLabel;

//平移方向
@property (nonatomic, assign) panTranslationState state;

@end

@implementation PLMoviePlayer {
    
    //当前视频的总时长
    CGFloat _totalTime;
    
    //当前的播放进度
    CGFloat _currentTime;
}

+ (Class)layerClass {
    return [AVPlayerLayer class];
}


/**
 初始化方法
 */
- (instancetype)initWithFrame:(CGRect)frame MovieUrl:(NSString *)url {
    if (self = [super initWithFrame:frame]) {
        
        
        //添加自定义的控件
        self.backgroundColor = [UIColor lightGrayColor];
        
        //播放器
        //先将在线视频链接存放在videoUrl中，然后初始化playerItem，playerItem是管理资源的对象（A player item manages the presentation state of an asset with which it is associated. A player item contains player item tracks—instances ofAVPlayerItemTrack—that correspond to the tracks in the asset.）
        self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:url]];
        //监听status属性
        //当status等于AVPlayerStatusReadyToPlay时代表视频已经可以播放了，我们就可以调用play方法播放了。
        [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        
        //监听loadedTimeRanges属性
        //loadedTimeRange属性代表已经缓冲的进度，监听此属性可以在UI中更新缓冲进度，也是很有用的一个属性。
        /*!
         @property loadedTimeRanges
         @abstract This property provides a collection of time ranges for which the player has the media data readily available. The ranges provided might be discontinuous.
         @discussion Returns an NSArray of NSValues containing CMTimeRanges.
         */
        [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        
        //播放
        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(plMoviePlayDidEnd) name:@"AVPlayerItemDidPlayToEndTime" object:self.playerItem];
        
        //播放层
        ((AVPlayerLayer *)self.layer).player = self.player;
        
        //播放按钮(触摸显示)
        self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.playButton.frame = CGRectMake(0, 0, 32, 32);
        self.playButton.hidden = YES;
        self.playButton.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        [self.playButton setImage:[UIImage imageWithContentsOfFile:[self plReturnFilePathWithImageName:@"pl_play.png"]] forState:UIControlStateNormal];
        [self.playButton setImage:[UIImage imageWithContentsOfFile:[self plReturnFilePathWithImageName:@"pl_stop.png"]] forState:UIControlStateSelected];
        [self.playButton addTarget:self action:@selector(plPlayButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.playButton];
        
        
        //开始的时间label(触摸显示)
        self.beginTimeLabel = [self plCreateLabelWithTextAlignment:NSTextAlignmentRight textColor:[UIColor blueColor] font:13 numberOfLines:0 lineBreakMode:NSLineBreakByWordWrapping];
        [self addSubview:self.beginTimeLabel];
        
        //结束时间label(触摸显示)
        self.endTimeLabel = [self plCreateLabelWithTextAlignment:NSTextAlignmentLeft textColor:[UIColor blueColor] font:13 numberOfLines:0 lineBreakMode:NSLineBreakByWordWrapping];
        [self addSubview:self.endTimeLabel];
        
        //进度条
        self.slider = [[UISlider alloc] init];
        self.slider.backgroundColor = [UIColor clearColor];
        self.slider.tintColor = [UIColor whiteColor];
        self.slider.hidden = YES;
        //添加滑动时间
        [self.slider addTarget:self action:@selector(plSliderAction:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.slider];
        
        //缓冲条
        self.progressView = [[UIProgressView alloc] init];
        self.progressView.progressTintColor = [UIColor whiteColor];
        //背景色
        self.progressView.trackTintColor = [UIColor clearColor];
        self.progressView.progress = 0;
        self.progressView.hidden = YES;
        [self addSubview:self.progressView];
        
        //菊花
        self.activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2.0 - 50, self.bounds.size.height / 2.0 - 50, 100, 100)];
        self.activity.color = [UIColor redColor];;
        self.activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self.activity startAnimating];
        [self addSubview:self.activity];
        
        //水平滑动时显示进度
        self.horizontalLabel = [self plCreateLabelWithTextAlignment:NSTextAlignmentCenter textColor:[UIColor blueColor] font:13 numberOfLines:0 lineBreakMode:NSLineBreakByWordWrapping];
        [self addSubview:self.horizontalLabel];
        
        //关闭按钮
        self.closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.closeButton addTarget:self action:@selector(plMoviePlayDidEnd) forControlEvents:UIControlEventTouchUpInside];
        [self.closeButton setImage:[UIImage imageWithContentsOfFile:[self plReturnFilePathWithImageName:@"pl_close.png"]] forState:UIControlStateNormal];
        self.closeButton.frame = CGRectMake(0, 0, 20, 20);
        self.closeButton.hidden = YES;
        [self addSubview:self.closeButton];
        
        //放大按钮
        self.enlargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.enlargeButton addTarget:self action:@selector(plEnlargeVideoForFullScreen:) forControlEvents:UIControlEventTouchUpInside];
        [self.enlargeButton setImage:[UIImage imageWithContentsOfFile:[self plReturnFilePathWithImageName:@"pl_enlargeVideo.png"]] forState:UIControlStateNormal];
        [self.enlargeButton setImage:[UIImage imageWithContentsOfFile:[self plReturnFilePathWithImageName:@"pl_enlargeVideo.png"]] forState:UIControlStateSelected];
        self.enlargeButton.frame = CGRectMake(0, 0, 20, 20);
        self.enlargeButton.hidden = YES;
        [self addSubview:self.enlargeButton];
    }
    
    return self;
}

#pragma mark ----适配----
/**
 适配
 */
- (void)plAddUIFrameWithPresentViewFrame {
    
    //当前view的宽
    CGRect viewFrame = self.frame;
    CGFloat view_W = viewFrame.size.width;
    CGFloat view_H = viewFrame.size.height;
    
    //当前加载的video的属性
    CGRect videoFrame = ((AVPlayerLayer *)self.layer).videoRect;
    CGFloat video_X = videoFrame.origin.x;
    CGFloat video_Y = videoFrame.origin.y;
    CGFloat video_W = videoFrame.size.width;
    CGFloat video_H = videoFrame.size.height;
    
    //播放按钮(触摸显示)
    self.playButton.center = CGPointMake(view_W / 2.0, view_H / 2.0);
    
    //结束播放
    self.closeButton.center = CGPointMake(video_X + 20, video_Y + 20);
    
    //放大按钮
    self.enlargeButton.center = CGPointMake(video_W + video_X - 15, video_Y + 15);
    
    //开始的时间label(触摸显示)
    self.beginTimeLabel.frame = CGRectMake(video_X, video_Y + video_H - 20, 60, 20);
    
    //结束时间label(触摸显示)
    self.endTimeLabel.frame = CGRectMake(video_X + video_W - 60, video_Y + video_H - 20, 60, 20);
    
    //进度条
    self.slider.frame = CGRectMake( CGRectGetMaxX(self.beginTimeLabel.frame) + 5, video_Y + video_H - 10, video_W - self.beginTimeLabel.frame.size.width - self.endTimeLabel.frame.size.width - 10, 2);
    
    //缓冲进度条
    self.progressView.frame = self.slider.frame;
    
    //水平滑动时显示进度
    self.horizontalLabel.frame = CGRectMake(video_X, CGRectGetMaxY(self.playButton.frame) + 5, video_W, 20);
}


#pragma mark ----监听函数----
/**
 监听视频播放的状态
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    //转化当前的对象
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    //判断状态
    if ([keyPath isEqualToString:@"status"]) {
        
        //准备去播放
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            
            NSLog(@"AVPlayerStatusReadyToPlay");
            
            //开始播放
            [self.player play];
            
            //添加适配
            [self plAddUIFrameWithPresentViewFrame];
            
            //释放掉菊花
            [self.activity removeFromSuperview];
            
            //改变按钮的状态
            self.playButton.selected = YES;
            
            //添加轻拍手势(用于显示或者隐藏mouxie)
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(plTapGestureRecognizerClick:)];
            tap.numberOfTouchesRequired = 1;
            tap.numberOfTapsRequired = 2;
            [self addGestureRecognizer:tap];
            
            //添加滑动手势用于和slider一样的用处
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(plPanDirectionForChangeMovieValue:)];
            [self addGestureRecognizer:pan];
            
            //获取视频总长度
            CMTime duration = playerItem.duration;
            
            //转换成秒
            CGFloat totalSecond = CMTimeGetSeconds(duration);
            
            //为总时长赋值
            _totalTime = totalSecond;
            
            //转换成播放时间
            self.endTimeLabel.text = [self plConvertTime:totalSecond];
            
            //监听播放状态
            [self plMonitoringPlayback:self.playerItem];
            
        } else if ([playerItem status] == AVPlayerStatusFailed) {//播放失败
            
            NSLog(@"AVPlayerStatusFailed");
            
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        //计算缓冲进度
        NSTimeInterval timeInterval = [self plAvailableDuration];
        
        /*
        typedef struct
        {
            分子 / 分母 代表当前的时间秒数
            CMTimeValue	value;   时间的分子
            CMTimeScale	timescale; 时间的分母
            CMTimeFlags	flags; 位掩码
            CMTimeEpoch	epoch; 时间状态
        } CMTime, *q_CMTime;
        */
         
        //self.playerItem.duration   AVPlayerItem的一个只读属性,可以读取到当前视频播放的时间
        CMTime duration = self.playerItem.duration;
        
        
        //CMTimeGetSeconds(duration)  获得时间的秒数
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        
        //更新缓冲条
        [self.progressView setProgress:timeInterval / totalDuration animated:YES];
    }
}

/**
 计算缓冲的进度
 */
- (NSTimeInterval)plAvailableDuration {
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    
    // 获取缓冲区域
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
    
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    
    //计算缓冲总进度
    NSTimeInterval result = startSeconds + durationSeconds;
    
    return result;
}

#pragma mark ----转换时间的格式----
/**
 转换成播放时间
 */
- (NSString *)plConvertTime:(CGFloat)second{
    
    //返回以1970时间为基准,返回当前多少秒的时间.便于取值
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}

#pragma mark ----用于不断更新文本的值-----
//monitoringPlayback用于监听每秒的状态，- (id)addPeriodicTimeObserverForInterval:(CMTime)interval queue:(dispatch_queue_t)queue usingBlock:(void (^)(CMTime time))block;此方法就是关键，interval参数为响应的间隔时间，这里设为每秒都响应，queue是队列，传NULL代表在主线程执行。可以更新一个UI，比如进度条的当前时间等。
- (void)plMonitoringPlayback:(AVPlayerItem *)playerItem {
    
    __weak typeof(self) weakSelf = self;
    
    self.playbackTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        
        //计算当前在第几秒
        CGFloat currentSecond = CMTimeGetSeconds(playerItem.currentTime);
        
        //更新slider的值
        [weakSelf plUpdateVideoSliderWithSecond:currentSecond];
        
        NSString *timeString = [weakSelf plConvertTime:currentSecond];
    
        weakSelf.beginTimeLabel.text = [NSString stringWithFormat:@"%@",timeString];
    }];
}

#pragma mark ----视频结束播放----
/**
 结束视频播放
 */
- (void)plMoviePlayDidEnd {
    
    //切换button的值 并且移除所有的监控和通知
    if (self.playButton.selected == YES) {
        self.playButton.selected = NO;
    } else if (self.playButton.selected == NO) {
        NSLog(@"之前没有开启");
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self    name:@"AVPlayerItemDidPlayToEndTime" object:self.playerItem];
    
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    
    [self.player removeTimeObserver:self.playbackTimeObserver];
    
    self.playbackTimeObserver = nil;
    
    [self.player pause];
    
    //获取父视图
    if (self.enlargeButton.selected == YES) {
        for (UIView *next = self.superview; next; next = next.superview) {
            UIResponder *nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[AVPlayerViewController class]]) {
                
                [self removeFromSuperview];
                
                [(AVPlayerViewController *)nextResponder dismissViewControllerAnimated:YES completion:^{
                    
                }];
                
                break;
            }
        }
    } else {
        //释放本页
        [self removeFromSuperview];
    }
}

#pragma mark ----监控用于更新左文本的时间值----
/**
 更新slider的值
 */
- (void)plUpdateVideoSliderWithSecond:(CGFloat)second {
    
    //获取总时长
    self.slider.value = second / _totalTime;
    
    if (self.slider.value == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AVPlayerItemDidPlayToEndTime" object:self.playerItem userInfo:nil];
    }
    
}

#pragma mark ----播放和暂停按钮----
/**
 播放和暂停
 */
- (void)plPlayButtonClicked:(UIButton *)btn {
    if (btn.selected == NO) {
        btn.selected = YES;
        
        //开始播放
        [self.player play];
        
    } else if (btn.selected == YES) {
        
        //停止播放
        btn.selected = NO;
        
        //暂停播放
        [self.player pause];
    }
    
}

#pragma mark -----slider相关----
/**
 滑动
 */
- (void)plSliderAction:(UISlider *)slider {
    [self.player pause];
    
    CGFloat currentTime = slider.value * _totalTime;
    
    NSString *showTime = [self plConvertTime:currentTime];
    
    //更新当前的时间标签
    self.beginTimeLabel.text = [NSString stringWithFormat:@"%@", showTime];
    
    //改变播放器的总时长
    CMTime time =  CMTimeMake(currentTime, 1);
    
    //滚动到指定时间
    [self.playerItem seekToTime:time];
    
    [self.player play];
    
}

#pragma mark ----手势相关----
/**
 触摸显示相关按钮
 */
- (void)plTapGestureRecognizerClick:(UITapGestureRecognizer *)tapClick {
    
    [self plUseForTapAndAutoCancelSomeView];
    
    // 先取消一个3秒后的方法，保证不管点击多少次，都只有一个方法在3秒后执行
    [UIView cancelPreviousPerformRequestsWithTarget:self selector:@selector(plAutoCancelTapSomeView) object:nil];
    
    //添加一个3秒的方法用于自动取消视图
    [self performSelector:@selector(plAutoCancelTapSomeView) withObject:nil afterDelay:3];
}

/**
 自动取消相关按钮
 */
- (void)plAutoCancelTapSomeView {
    [self plUseForTapAndAutoCancelSomeView];
}

/**
 相关触摸按钮的隐藏和显示
 */
- (void)plUseForTapAndAutoCancelSomeView {
    self.playButton.hidden = !self.playButton.hidden;
    self.beginTimeLabel.hidden = !self.beginTimeLabel.hidden;
    self.endTimeLabel.hidden = !self.endTimeLabel.hidden;
    self.slider.hidden = !self.slider.hidden;
    self.progressView.hidden = !self.progressView.hidden;
    self.closeButton.hidden = !self.closeButton.hidden;
    self.enlargeButton.hidden = !self.enlargeButton.hidden;
}

/**
 平移手势相关按钮
 */
- (void)plPanDirectionForChangeMovieValue:(UIPanGestureRecognizer *)pan {
    
    //根据平移的
    CGPoint panVeloctyPoint = [pan velocityInView:self];
    
    switch (pan.state) {
        //平移开始
        case UIGestureRecognizerStateBegan: {
            
            //先暂停播放
            [self.player pause];
            
            //保留一个当前的播放进度
            _currentTime = CMTimeGetSeconds(self.player.currentTime);
            
            //显示horizontalLabel的值
            NSString *currentLabel = [self plConvertTime:_currentTime];
            NSString *totalLabel = [self plConvertTime:_totalTime];
            self.horizontalLabel.hidden = NO;
            self.horizontalLabel.text = [NSString stringWithFormat:@"<<%@/%@>>", currentLabel, totalLabel];
            
        }
            break;
            
        //正在平移
        case UIGestureRecognizerStateChanged: {
            
            //不断累加播放进度.需要x
            [self plAreProgressOfTranslationWithValue:panVeloctyPoint.x];
            
        }
            break;
            
        //平移取消 / 失败
        case UIGestureRecognizerStateCancelled | UIGestureRecognizerStateFailed:{
            
            //清空保存的进度
            _currentTime = 0.0f;
            
            //接着当前开始播放
            [self.player play];
            
            //隐藏horizontalLabel
            self.horizontalLabel.hidden = YES;
        }
            break;
            
        //平移结束
        case UIGestureRecognizerStateEnded: {
         
            //开始播放(从指定地方)
            CMTime time =  CMTimeMake(_currentTime, 1);
            
            //滚动到指定时间
            [self.playerItem seekToTime:time];
            
            [self.player play];
            
            //隐藏horizontalLabel
            self.horizontalLabel.hidden = YES;
        }
            break;

            
        default:
            break;
    }
}

/**
 正在平移需要调用的函数
 */
- (void)plAreProgressOfTranslationWithValue:(CGFloat)value {
    
    if (value >= 0) { //正向平移
        
        self.state = panTranslationStateRight;
        _currentTime += 3;
        
    } else if (value < 0) { //负向平移
        
        self.state = panTranslationStateLeft;
        _currentTime -= 3;
    }
    
    //确保在合理的范围内
    if (_currentTime >= _totalTime) {
        
        _currentTime = _totalTime;
        
    } else if (_currentTime <= 0) {
        
        _currentTime = 0;
        
    }
    
    //更新horizontalLabel的值
    NSString *currentLabelStr = [self plConvertTime:_currentTime];
    NSString *toralLabelStr = [self plConvertTime:_totalTime];
    
    if (self.state == panTranslationStateLeft) {
        self.horizontalLabel.text = [NSString stringWithFormat:@"<<%@/%@",currentLabelStr, toralLabelStr];
    } else if (self.state == panTranslationStateRight) {
        self.horizontalLabel.text = [NSString stringWithFormat:@"%@/%@>>", currentLabelStr, toralLabelStr];
    }
}

#pragma mark ----创建一个label----
/**
 创建一个UILabel
 */
- (UILabel *)plCreateLabelWithTextAlignment:(NSTextAlignment)textAlignment textColor:(UIColor *)textColor font:(CGFloat)fontSize numberOfLines:(NSInteger)numberOfLines lineBreakMode:(NSLineBreakMode)lineBreakMode {
    
    UILabel * label = [[UILabel alloc] init];
    
    //文字颜色
    label.textColor = textColor;
    
    //字体大小
    label.font = [UIFont systemFontOfSize:fontSize];
    
    //设置对齐方式
    label.textAlignment = textAlignment;
    
    //设置折行
    label.numberOfLines = numberOfLines;
    
    //设置折行方式
    label.lineBreakMode = lineBreakMode;
    
    label.hidden = YES;
    
    return label;
}

#pragma mark ----放大视频----
- (void)plEnlargeVideoForFullScreen:(UIButton *)btn {
    
    [self.player pause];
    
    if (btn.selected == NO) {
        //查找到该页面
        btn.selected = YES;
        
        //保存当前页面的尺寸
        _presentViewFrame = self.frame;
        
        //保存当前页面的父页面
        _presentSuperView = self.superview;
        
        for (UIView *next = self.superview; next; next = next.superview) {
            UIResponder *nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[UIViewController class]]) {
                
                PLMovieViewController *vc = [[PLMovieViewController alloc] init];
                [vc.view addSubview:self];
                
                [((UIViewController *)nextResponder) presentViewController:vc animated:YES completion:^{
                    self.frame = vc.view.frame;
                    
                    [self plAddUIFrameWithPresentViewFrame];
                    
                    [self.player play];
                }];
                break;
            }
        }
    } else if (btn.selected == YES) {
        //查找到该页面
        btn.selected = NO;
        
        for (UIView *next = self.superview; next; next = next.superview) {
            UIResponder *nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[AVPlayerViewController class]]) {
                
                [(AVPlayerViewController *)nextResponder dismissViewControllerAnimated:YES completion:^{
                    
                    self.frame = _presentViewFrame;
                    
                    [self plAddUIFrameWithPresentViewFrame];
                    
                    [_presentSuperView addSubview:self];
                    
                    [self.player play];
                    
                }];
            }
        }
    }
}

#pragma mark ----返回文件路径----
/**
 返回路径
 */
- (NSString *)plReturnFilePathWithImageName:(NSString *)imageName {
    return [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], imageName];
}
@end
