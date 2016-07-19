//
//  PLCommentCell.m
//  Joke
//
//  Created by qianfeng on 16/6/15.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import "PLCommentCell.h"

@implementation PLCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self plCreateOtherUIForPresentCell];
    }
    return self;
}

- (void)plCreateOtherUIForPresentCell {
    
    //评论者头像
    self.commentHeaderImageView = [self plCreateCustomImageView];
    self.commentHeaderImageView.layer.cornerRadius = 10;
    self.commentHeaderImageView.clipsToBounds = YES;
    
    //评论者姓名
    self.nameLabel = [self plCreateLabelWithTextAlignment:NSTextAlignmentLeft textColor:[UIColor blackColor] font:15 numberOfLines:0 lineBreakMode:NSLineBreakByWordWrapping];
    
    //评论
    self.contentLabel = [self plCreateLabelWithTextAlignment:NSTextAlignmentLeft textColor:[UIColor lightGrayColor] font:14 numberOfLines:0 lineBreakMode:NSLineBreakByWordWrapping];
}

- (void)plAddRestrainForPresentCellIsNeedRefreshFont:(BOOL)is {
    
    __weak typeof(self) weakSelf = self;
    
    CGFloat padding = 5.0f;
    
    //评论者头像
    [self.commentHeaderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        //上
        make.top.mas_equalTo(weakSelf.contentView).offset(padding);
        
        //下
        make.bottom.mas_equalTo(weakSelf.contentLabel.mas_top).offset(-2 * padding);
        
        //左
        make.left.mas_equalTo(30);
        
        //右
        make.right.mas_equalTo(weakSelf.nameLabel.mas_left).offset(-padding);
        
        //宽
        make.width.mas_equalTo(30);
        
        //高
        make.height.mas_equalTo(30);
    }];
    
    //评论者姓名
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //上
        make.top.mas_equalTo(weakSelf.contentView).offset(padding);
        
        //下
        make.bottom.mas_equalTo(weakSelf.contentLabel.mas_top).offset(-2 * padding);
        
        //右
        make.right.mas_equalTo(weakSelf.contentView);
        
    }];
    
    //评论
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //下
        make.bottom.mas_equalTo(weakSelf.contentView).offset(-padding);
        
        //左
        make.left.mas_equalTo(weakSelf.nameLabel.mas_left);
        
        //右
        make.right.mas_equalTo(weakSelf.contentView).offset(-padding);
        
    }];
    
    if (is) {
        self.nameLabel.font = [UIFont fontWithName:@"chen  dai  ming" size:17];
        self.contentLabel.font = [UIFont fontWithName:@"chen  dai  ming" size:15];
    } else {
        self.nameLabel.font = [UIFont systemFontOfSize:17];
        self.contentLabel.font = [UIFont systemFontOfSize:15];
    }
    
}

- (void)plRefreshPresentCellDataWithModel:(PLCommentModel *)model {
    
    self.nameLabel.text = model.name;
    
    [self.commentHeaderImageView sd_setImageWithURL:[NSURL URLWithString:model.header]];
    
    self.contentLabel.text = model.content;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
