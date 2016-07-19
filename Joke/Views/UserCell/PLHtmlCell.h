//
//  PLHtmlCell.h
//  Joke
//
//  Created by qianfeng on 16/6/15.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import "PLBaseCell.h"
#import "PLHtmlModel.h"

@interface PLHtmlCell : PLBaseCell

//html网页
@property (nonatomic, strong) NSString *body;

//html按钮网页
@property (nonatomic, strong) UIButton *htmlButton;

/**
 添加其他约束
 */
- (void)plAddRestrainForTxLabelAndOtherAttributesandIsNeedRefreshFont:(BOOL)is;


/**
 刷新当前cell的数据
 */
- (void)plRefreshPresentCellDataWithModel:(PLHtmlModel *)model;

@end
