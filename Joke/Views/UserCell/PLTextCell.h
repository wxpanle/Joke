//
//  PLTextCell.h
//  Joke
//
//  Created by qianfeng on 16/6/15.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import "PLBaseCell.h"
#import "PLTextModel.h"

@interface PLTextCell : PLBaseCell

/**
 添加自己的约束
 */
- (void)plAddRestrainForTxLabelAndOtherAttributesWithTextHeight:(CGFloat)textHeight andIsNeedRefreshFont:(BOOL)is;

/**
 刷新当前cell的数据
 */
- (void)plRefreshPresentCellDataWithModel:(PLTextModel *)model;

@end
