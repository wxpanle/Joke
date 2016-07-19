//
//  PLBaseCell.h
//  Joke
//
//  Created by qianfeng on 16/6/15.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLBaseCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

//作者头像
@property (nonatomic, strong) UIImageView *userHeaderImageView;

//作者名字
@property (nonatomic, strong) UILabel *userName;

//对应的文本
@property (nonatomic, strong) UILabel *txLabel;

//是否需要重新布局
@property (nonatomic, assign) BOOL isNeedResfreshLayout;

/**
 添加其它UI
 */
- (void)plCreateOtherUIForPresentCell;

/**
 更新字体
 */
- (void)plRefreshFontTypeWithBoolIs:(BOOL)is;

/**
 创建一个UIImageView
 */
- (UIImageView *)plCreateCustomImageView;

/**
 创建一个UILabel
 */
- (UILabel *)plCreateLabelWithTextAlignment:(NSTextAlignment)textAlignment textColor:(UIColor *)textColor font:(CGFloat)fontSize numberOfLines:(NSInteger)numberOfLines lineBreakMode:(NSLineBreakMode)lineBreakMode;

/**
 创建一个UIButton
 */
- (UIButton *)plCreateButtonWithimageName:(NSString *)imageName target:(id)target selector:(SEL)selector;

/**
 查找到当前的页面controller
 */
- (UIViewController *)plGetViewController;

@end
