//
//  PLHtmlCell.m
//  Joke
//
//  Created by qianfeng on 16/6/15.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import "PLHtmlCell.h"
#import "PLHtmlViewController.h"
#import "ViewController.h"

@implementation PLHtmlCell

- (void)plCreateOtherUIForPresentCell {

    //创建跳转按钮
    self.htmlButton = [self plCreateButtonWithimageName:@"pl_link" target:self selector:@selector(htmlButtonClicked:)];
}

- (void)plAddRestrainForTxLabelAndOtherAttributesandIsNeedRefreshFont:(BOOL)is {
    __weak typeof(self) weakSelf = self;
    
    [self plRefreshFontTypeWithBoolIs:is];
    
    CGFloat padding = 5.0f;
    
    //作者名字
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //上
        make.top.mas_equalTo(weakSelf.contentView).offset(2 * padding);
        
        //下
        make.bottom.mas_equalTo(weakSelf.userHeaderImageView.mas_bottom);
        
        //右
        make.right.mas_equalTo(weakSelf.contentView).offset(0);
        
        //左
        make.left.mas_equalTo(weakSelf.userHeaderImageView.mas_right).offset(padding);
        
    }];
    
    //作者头像
    [self.userHeaderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //上
        make.top.mas_equalTo(weakSelf.contentView).offset(2 * padding);
        
        //左
        make.left.mas_equalTo(weakSelf.contentView).offset(padding);
        
        //宽
        make.width.mas_equalTo(35);
        
        //高
        make.height.mas_equalTo(35);
        
    }];
    
    
    //文本
    [self.txLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.top.mas_equalTo(weakSelf.userHeaderImageView.mas_bottom).offset(2 * padding);
        
        //下
        make.bottom.mas_equalTo(weakSelf.contentView).offset(-2 * padding);
        
        //左
        make.left.mas_equalTo(weakSelf.userName.mas_left);
        
        //右
        make.right.mas_equalTo(weakSelf.contentView).offset(-padding);
        
    }];
    
    //播放按钮
    [self.htmlButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        //上
        make.top.mas_equalTo(weakSelf.userName.mas_bottom).offset(padding + 5);
        
        //左
        make.left.mas_equalTo(weakSelf.userHeaderImageView.mas_left).offset(2 * padding);
        
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
        
    }];

    
}

- (void)plRefreshPresentCellDataWithModel:(PLHtmlModel *)model {
    
    self.userName.text = model.name;
    [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:model.header]];
    self.txLabel.text = [NSString stringWithFormat:@" %@", model.desc];
    self.body = model.body;
}

- (void)htmlButtonClicked:(UIButton *)btn {
    
    //加载网页
    PLHtmlViewController *htmlVC = [[PLHtmlViewController alloc] init];
    htmlVC.htmlUrl = self.body;
    
    ViewController *vc = (ViewController *)[self plGetViewController];
    if (vc) {
        [vc.navigationController pushViewController:htmlVC animated:YES];
    } else {
        NSLog(@"没有找到");
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
