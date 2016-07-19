//
//  PLGifCell.h
//  Joke
//
//  Created by qianfeng on 16/6/15.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import "PLBaseCell.h"
#import "PLGifModel.h"

@interface PLGifCell : PLBaseCell

//动态图
@property (nonatomic, strong) NSString *images;

//动态图缓冲
@property (nonatomic, strong) UIImageView *gif_thumbnailImageView;

//gif按钮
@property (nonatomic, strong) UIButton *gifButton;

/**
 添加约束
 */
- (void)plAddRestrainForPresentCellWithGifImageWidth:(CGFloat)gifWidth andGifHeight:(CGFloat)gifHeight andTextHeight:(CGFloat)textHeight andIsNeedRefreshFont:(BOOL)is;

/**
 刷新当前cell的数据
 */
- (void)plRefreshPresentCellDataWithModel:(PLGifModel *)model;

@end
