//
//  PLBigImage.h
//  VideoPlayer
//
//  Created by qianfeng on 16/6/17.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLBigImage : UIView

/**
 初始化方法
 */
- (instancetype)initWithUrl:(NSString *)url andImageWidth:(CGFloat)imageWidth andImageHeight:(CGFloat)imageHeight;

@end
