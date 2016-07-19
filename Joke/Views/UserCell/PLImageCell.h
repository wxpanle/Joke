//
//  PLImageCell.h
//  Joke
//
//  Created by qianfeng on 16/6/15.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import "PLBaseCell.h"
#import "PLImageModel.h"

@interface PLImageCell : PLBaseCell

//图片
@property (nonatomic, strong) UIImageView *showImageView;

//图片(big)
@property (nonatomic, strong) NSString *big;

/**
 添加约束
 */
- (void)plAddRestrainForPresentCellWithImageWidth:(CGFloat)imageWidth andImageHeight:(CGFloat)imageHeight andTextHeight:(CGFloat)textHeight andIsNeedRefreshFont:(BOOL)is;

/**
 刷新当前cell的数据
 */
- (void)plRefreshPresentCellDataWithModel:(PLImageModel *)model;

/**
 由图片的宽和屏幕的宽高获得等比例的屏幕适配
 */
+ (CGRect)plGetEqualHeightByImageWidth:(CGFloat)imageWidth andImageHeight:(CGFloat)imageHeight;

@end
