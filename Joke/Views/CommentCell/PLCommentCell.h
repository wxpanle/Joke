//
//  PLCommentCell.h
//  Joke
//
//  Created by qianfeng on 16/6/15.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import "PLBaseCell.h"
#import "PLCommentModel.h"

@interface PLCommentCell : PLBaseCell

//评论者头像
@property (nonatomic, strong) UIImageView *commentHeaderImageView;

//评论者姓名
@property (nonatomic, strong) UILabel *nameLabel;

//评论
@property (nonatomic, strong) UILabel *contentLabel;

/**
 添加约束
 */
- (void)plAddRestrainForPresentCellIsNeedRefreshFont:(BOOL)is;

/**
 刷新当前cell的数据
 */
- (void)plRefreshPresentCellDataWithModel:(PLCommentModel *)model;

@end
