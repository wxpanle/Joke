//
//  PLVideoCell.h
//  Joke
//
//  Created by qianfeng on 16/6/15.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import "PLBaseCell.h"
#import "PLVideoModel.h"

@interface PLVideoCell : PLBaseCell

//视频
@property (nonatomic, strong) UIButton *videoButton;

//视频展示图
@property (nonatomic, strong) UIImageView *thumbnailImageView;

//视频连接
@property (nonatomic, strong) NSString *videoUrl;

/**
 添加约束
 */
- (void)plAddRestrainForPresentCellWithVideoWidth:(CGFloat)videoWidth andVideoHeight:(CGFloat)videoHeight andTextHeight:(CGFloat)textHeight andIsNeedRefreshFont:(BOOL)is;
/**
 刷新当前cell的数据
 */
- (void)plRefreshPresentCellDataWithModel:(PLVideoModel *)model;

/**
 由video的宽和屏幕的宽高获得等比例的屏幕适配
 */
+ (CGRect)plGetEqualHeightByVideoWidthAnd:(CGFloat)videoWidth andVideoHeight:(CGFloat)videoHeight;

@end
