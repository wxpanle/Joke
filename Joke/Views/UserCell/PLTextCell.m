//
//  PLTextCell.m
//  Joke
//
//  Created by qianfeng on 16/6/15.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import "PLTextCell.h"

@implementation PLTextCell

- (void)plAddRestrainForTxLabelAndOtherAttributesWithTextHeight:(CGFloat)textHeight andIsNeedRefreshFont:(BOOL)is {
    
    self.txLabel.frame = CGRectMake(self.userName.frame.origin.x, CGRectGetMaxX(self.userHeaderImageView.frame) + 10, SCREEN_W - CGRectGetMaxX(self.userHeaderImageView.frame) - 5 - 5, textHeight);
    
    [self plRefreshFontTypeWithBoolIs:is];
    
}

- (void)plRefreshPresentCellDataWithModel:(PLTextModel *)model {
    
    self.userName.text = model.name;
    [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:model.header]];
    self.txLabel.text = model.text;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
