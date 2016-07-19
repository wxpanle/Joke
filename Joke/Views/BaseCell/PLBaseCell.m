//
//  PLBaseCell.m
//  Joke
//
//  Created by qianfeng on 16/6/15.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import "PLBaseCell.h"

@implementation PLBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //创建基本控件
        [self plCreateCommonUserHeaderImageViewAndUserName];
        
        //添加其它控件
        [self plCreateOtherUIForPresentCell];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

/**
 创建作者名和作者头像
 */
- (void)plCreateCommonUserHeaderImageViewAndUserName {
    
    //作者头像
    self.userHeaderImageView = [self plCreateCustomImageView];
    self.userHeaderImageView.layer.cornerRadius = 10;
    self.userHeaderImageView.frame = CGRectMake(5, 10, 35, 35);
    self.userHeaderImageView.clipsToBounds = YES;
    
    //作者名字
    self.userName = [self plCreateLabelWithTextAlignment:NSTextAlignmentLeft textColor:[UIColor blackColor] font:17 numberOfLines:0 lineBreakMode:NSLineBreakByWordWrapping];
    self.userName.frame = CGRectMake(CGRectGetMaxX(self.userHeaderImageView.frame) + 5, 10 + 7.5, SCREEN_W - 50, 20);
    
    //文本
    self.txLabel = [self plCreateLabelWithTextAlignment:NSTextAlignmentLeft textColor:[UIColor lightGrayColor] font:15 numberOfLines:0 lineBreakMode:NSLineBreakByWordWrapping];
    
}

/**
 添加其它UI
 */
- (void)plCreateOtherUIForPresentCell {
    
    //各自调用
}


/**
 更新字体
 */
- (void)plRefreshFontTypeWithBoolIs:(BOOL)is {
    

    if (is) {
        self.userName.font = [UIFont fontWithName:@"chen  dai  ming" size:17];
        self.txLabel.font = [UIFont fontWithName:@"chen  dai  ming" size:15];
    } else {
        self.userName.font = [UIFont systemFontOfSize:17];
        self.txLabel.font = [UIFont systemFontOfSize:15];
    }
}

/**
 创建一个UIImageView
 */
- (UIImageView *)plCreateCustomImageView {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:imageView];
    
    return imageView;
}

/**
 创建一个UILabel
 */
- (UILabel *)plCreateLabelWithTextAlignment:(NSTextAlignment)textAlignment textColor:(UIColor *)textColor font:(CGFloat)fontSize numberOfLines:(NSInteger)numberOfLines lineBreakMode:(NSLineBreakMode)lineBreakMode {
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = textAlignment;
    label.textColor = textColor;
    BOOL fontFace = [[[NSUserDefaults standardUserDefaults] objectForKey:@"typeface"] boolValue];
    if (fontFace) {
        label.font = [UIFont fontWithName:@"chen  dai  ming" size:fontSize];
    } else {
        label.font = [UIFont systemFontOfSize:fontFace];
    }
    label.numberOfLines = numberOfLines;
    label.lineBreakMode = lineBreakMode;
    [self.contentView addSubview:label];
    
    return label;
}

/**
 创建一个UIButton
 */
- (UIButton *)plCreateButtonWithimageName:(NSString *)imageName target:(id)target selector:(SEL)selector {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageWithContentsOfFile:[self plGetImageBundelPathWithImageName:imageName]] forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 40, 40);
    [self.contentView addSubview:button];
    
    return button;
}

/**
 获取工程图片的路径
 */
- (NSString *)plGetImageBundelPathWithImageName:(NSString *)imageName {
    return [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], imageName];
}

/**
 查找到当前的页面controller
 */
- (UIViewController *)plGetViewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
