//
//  PLBaseViewController.h
//  Joke
//
//  Created by qianfeng on 16/6/15.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLBaseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

//tableView
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL fontFace;

/**
 创建按钮进行更换资源和title
 */
- (void)plAddButtonForChangeResourcesAndNavagationTitle;

/**
 释放button界面
 */
- (void)plReleseButtonFromPresentViews;

/**
 切换资源
 */
- (void)plResfreshDataUrlAndRenewDataForCellWithindex:(NSInteger)index;

/**
 修改导航栏属性
 */
- (void)plChangeNavigationControllerNavigationBarTitleTextAttributes;

@end
