//
//  PLBaseViewController.m
//  Joke
//
//  Created by qianfeng on 16/6/15.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import "PLBaseViewController.h"

#pragma mark ----model----
#import "PLCommentModel.h"
#import "PLTextModel.h"
#import "PLUserModel.h"
#import "PLVideoModel.h"
#import "PLGifModel.h"
#import "PLHtmlModel.h"
#import "PLImageModel.h"

#pragma mark ----cell----
#import "PLCommentCell.h"
#import "PLTextCell.h"
#import "PLVideoCell.h"
#import "PLImageCell.h"
#import "PLGifCell.h"
#import "PLHtmlCell.h"

#pragma mark ----other----
#import "PLMoviePlayer.h"
#import "PLBigImage.h"
#import "PLAddView.h"
#import "PLMyTabBar.h"

@interface PLBaseViewController () {
    //刷新的url
    NSString *_dataUrl;
    
    //刷新需要的页数
    NSInteger _page;
}

//数据源
@property (nonatomic, strong) NSMutableArray *dataArray;

//高度数据源
@property (nonatomic, strong) NSMutableArray *heightArray;

//可提供切换的资源数组
@property (nonatomic, strong) NSArray *resourceArray;

@end

@implementation PLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fontFace = [[[NSUserDefaults standardUserDefaults] objectForKey:@"typeface"] boolValue];
    
    //创建tableView
    [self plCreateTableViewUI];
    
    //创建刷新控件
    [self plCreateMJRefreshUI];

}

#pragma mark ----导航栏相关----
/**
 修改导航栏属性
 */
- (void)plChangeNavigationControllerNavigationBarTitleTextAttributes {
    
    BOOL fontType = [[[NSUserDefaults standardUserDefaults] objectForKey:@"typeface"] boolValue];
    
    if (fontType) {
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:50 / 255.0 green:150 / 255.0 blue:220 / 255.0 alpha:1.0f], NSFontAttributeName : [UIFont fontWithName:@"chen  dai  ming" size:20]};
    } else {
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:50 / 255.0 green:150 / 255.0 blue:220 / 255.0 alpha:1.0f], NSFontAttributeName : [UIFont systemFontOfSize:20]};
    }
}

#pragma mark ----tableView相关----
/**
 创建tableView
 */
- (void)plCreateTableViewUI {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64 - 49) style:UITableViewStyleGrouped];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    //设置cell的虚拟高度,默认情况下为0
    self.tableView.estimatedRowHeight = 50.f;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    
    //注册cell
    [self.tableView registerClass:[PLTextCell class] forCellReuseIdentifier:@"plTextCell"];
    [self.tableView registerClass:[PLImageCell class] forCellReuseIdentifier:@"plImageCell"];
    [self.tableView registerClass:[PLGifCell class] forCellReuseIdentifier:@"plGifCell"];
    [self.tableView registerClass:[PLVideoCell class] forCellReuseIdentifier:@"plVideoCell"];
    [self.tableView registerClass:[PLHtmlCell class] forCellReuseIdentifier:@"plHtmlCell"];
    [self.tableView registerClass:[PLCommentCell class] forCellReuseIdentifier:@"plCommentCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count ? ((NSArray *)[self.dataArray objectAtIndex:section]).count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *resued = @"cell";
    
    //判断调用哪种cell
    PLUserModel *userModel = [[self.dataArray objectAtIndex:indexPath.section] firstObject];
    NSString *str = userModel.type;
    
    
    if ([str isEqualToString:@"text"]) {
        
        PLTextModel *textModel = [[self.dataArray objectAtIndex:indexPath.section] firstObject];
        
        if (indexPath.row == 0) {
            
            PLTextCell *textCell = [tableView dequeueReusableCellWithIdentifier:@"plTextCell" forIndexPath:indexPath];
            [textCell plAddRestrainForTxLabelAndOtherAttributesWithTextHeight:textModel.textHeight andIsNeedRefreshFont:self.fontFace];
            [textCell plRefreshPresentCellDataWithModel:textModel];
            return textCell;
            
        } else if (indexPath.row == 1) {
            
            PLCommentCell *commentCell = [self plHandleCommentCellWithTbaleView:tableView andIndexPath:indexPath andCommentModel:textModel.commentModel];
            
            return commentCell;
            
        }
        
    } else if ([str isEqualToString:@"gif"]) {
        
        PLGifModel *gifModel = [[self.dataArray objectAtIndex:indexPath.section] firstObject];
        
        if (indexPath.row == 0) {
            
            PLGifCell *gifCell = [tableView dequeueReusableCellWithIdentifier:@"plGifCell" forIndexPath:indexPath];
            [gifCell plAddRestrainForPresentCellWithGifImageWidth:[gifModel.width floatValue] andGifHeight:[gifModel.height floatValue] andTextHeight:gifModel.textHeight andIsNeedRefreshFont:self.fontFace];
            [gifCell plRefreshPresentCellDataWithModel:gifModel];
            return gifCell;
            
        } else if (indexPath.row == 1) {
            
            PLCommentCell *commentCell = [self plHandleCommentCellWithTbaleView:tableView andIndexPath:indexPath andCommentModel:gifModel.commentModel];
            
            return commentCell;
        }
        
    } else if ([str isEqualToString:@"image"]) {
        
        PLImageModel *imageModel = [[self.dataArray objectAtIndex:indexPath.section] firstObject];
        
        if (indexPath.row == 0) {
            
            PLImageCell *imageCell = [tableView dequeueReusableCellWithIdentifier:@"plImageCell" forIndexPath:indexPath];
            [imageCell plAddRestrainForPresentCellWithImageWidth:[imageModel.width floatValue] andImageHeight:[imageModel.height floatValue] andTextHeight:imageModel.textHeight andIsNeedRefreshFont:self.fontFace];
            [imageCell plRefreshPresentCellDataWithModel:imageModel];
            return imageCell;
            
        } else if (indexPath.row == 1) {
            
            PLCommentCell *commentCell = [self plHandleCommentCellWithTbaleView:tableView andIndexPath:indexPath andCommentModel:imageModel.commentModel];
            
            return commentCell;
        }
        
    } else if ([str isEqualToString:@"video"]) {
        
        PLVideoModel *videoModel = [[self.dataArray objectAtIndex:indexPath.section] firstObject];
        if (indexPath.row == 0) {
            PLVideoCell *videoCell = [tableView dequeueReusableCellWithIdentifier:@"plVideoCell" forIndexPath:indexPath];
            [videoCell plAddRestrainForPresentCellWithVideoWidth:[videoModel.width floatValue] andVideoHeight:[videoModel.height floatValue] andTextHeight:videoModel.textHeight andIsNeedRefreshFont:self.fontFace];
            [videoCell plRefreshPresentCellDataWithModel:videoModel];
            return videoCell;
            
        } else if (indexPath.row == 1) {
            
            PLCommentCell *commentCell = [self plHandleCommentCellWithTbaleView:tableView andIndexPath:indexPath andCommentModel:videoModel.commentModel];
            
            return commentCell;
        }
        
    } else if ([str isEqualToString:@"html"]) {
        
        PLHtmlModel *htmlModel = [[self.dataArray objectAtIndex:indexPath.section] firstObject];
        
        if (indexPath.row == 0) {
            
            PLHtmlCell *htmlCell = [tableView dequeueReusableCellWithIdentifier:@"plHtmlCell" forIndexPath:indexPath];
            [htmlCell plAddRestrainForTxLabelAndOtherAttributesandIsNeedRefreshFont:self.fontFace];
            [htmlCell plRefreshPresentCellDataWithModel:htmlModel];
            return htmlCell;
            
        } else if (indexPath.row == 1) {
            
            PLCommentCell *commentCell = [self plHandleCommentCellWithTbaleView:tableView andIndexPath:indexPath andCommentModel:htmlModel.commentModel];
            
            return commentCell;
        }
        
    }
    
    
    //如果不是任何一种类型
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resued];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resued];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10.f;
    }
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PLUserModel *userModel = [[self.dataArray objectAtIndex:indexPath.section] firstObject];
    NSString *str = userModel.type;
    if ([str isEqualToString:@"html"]) {
        return UITableViewAutomaticDimension;
    } else if (indexPath.row == 0) {
        return [[self.heightArray objectAtIndex:indexPath.section] floatValue];
    }
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    //清除cell上的视频属性
    [self plRemovePresentCellAllAttributesWithTableViewCell:cell];
    
    
    CGFloat caches = [[SDImageCache sharedImageCache] getSize];
    
    CGFloat size = caches / 1024 / 1024 ;
    
    if (size >= 5) {
        //清除缓存
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
    }
}

/**
 清除cell上的视频属性
 */
- (void)plRemovePresentCellAllAttributesWithTableViewCell:(UITableViewCell *)cell {
    
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[PLMoviePlayer class]]) {
            [((PLMoviePlayer *)view).player pause];
            [((PLMoviePlayer *)view) plMoviePlayDidEnd];
        }
    }
}

/**
 处理评论的cell
 */
- (PLCommentCell *)plHandleCommentCellWithTbaleView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath andCommentModel:(PLCommentModel *)model {
    
    PLCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"plCommentCell" forIndexPath:indexPath];
    
    [commentCell plAddRestrainForPresentCellIsNeedRefreshFont:self.fontFace];
    
    [commentCell plRefreshPresentCellDataWithModel:model];
    
    return commentCell;
}

#pragma mark ----加载数据----
/**
 加载数据
 */
- (void)plLoadData {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:[NSString stringWithFormat:_dataUrl, _page] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //整理数据
        
        //1.为下一次刷新数据做准备
        _page = [[[responseObject objectForKey:@"info"] objectForKey:@"np"] integerValue];
        
        //2.决定调用哪一个处理方法
        
        //2.1获得数组
        NSArray *dataArray = [responseObject objectForKey:@"list"];
        
        //2.2遍历数组
        for (NSDictionary *dict in dataArray) {
            NSString *type = [dict objectForKey:@"type"];
            
            if ([type isEqualToString:@"text"]) {
                
                [self plHandleDataOfTypeIsTextWithTextDictionary:dict];
                
            } else if ([type isEqualToString:@"image"]) {
                
                [self plHandleDataOfTypeIsImageWithimageDictionary:dict];
                
            } else if ([type isEqualToString:@"video"]) {
                
                [self plHandleDataOfTypeIsVideoWithVideoDictionary:dict];
                
            } else if ([type isEqualToString:@"gif"]) {
                
                [self plHandleDataOfTypeIsGifWithgifDictionary:dict];
                
            } else if ([type isEqualToString:@"html"]) {
                
                [self plHandleDataOfTypeIsHtmlWithHtmlDictionary:dict];
                
            } else {
                NSLog(@"我没发现的类型 -- %@", type);
            }
        }
        
        //停止刷新
        [self plIsCheckToEndRefrsehOfCommon];
        
        //刷新整个tableView
        [self.tableView reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //停止刷新
        [self plIsCheckToEndRefrsehOfCommon];
        
    }];
    
}

/**
 刷新成功/失败调用
 */
- (void)plIsCheckToEndRefrsehOfCommon {
    
    //停止刷新
    if ([self.tableView.header isRefreshing]) {
        [self.tableView.header endRefreshing];
    }
    
    if ([self.tableView.footer isRefreshing]) {
        [self.tableView.footer endRefreshing];
    }
}

#pragma mark ----刷新控件----
- (void)plCreateMJRefreshUI {
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        //下拉刷新
        _page = 0;
        
        //清空数据源
        [self.dataArray removeAllObjects];
        [self.heightArray removeAllObjects];
        [self.tableView scrollsToTop];
        
        //加载数据
        [self plLoadData];
        
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        //上啦加载
        [self plLoadData];
        
    }];
    
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"typeName"];
    
    if ([str isEqualToString:@"排行榜"]) {
        self.navigationItem.title = str;
        _dataUrl = JOKE_RECOMMEND;
    } else if ([str isEqualToString:@"段子"]) {
        self.navigationItem.title = str;
        _dataUrl = JOKE_JOKE;
    } else if ([str isEqualToString:@"网红"]) {
        self.navigationItem.title = str;
        _dataUrl = JOKE_NET;
    } else if ([str isEqualToString:@"趣图"]) {
        self.navigationItem.title = str;
        _dataUrl = JOKE_IMAGE;
    } else if ([str isEqualToString:@"视频"]) {
        self.navigationItem.title = str;
        _dataUrl = JOKE_VIDEO;
    } else if ([str isEqualToString:@"冷知识"]) {
        self.navigationItem.title = str;
        _dataUrl = JOKE_COLDKNOWLEDGE;
    } else if ([str isEqualToString:@"美女"]) {
        self.navigationItem.title = str;
        _dataUrl = JOKE_BEAUTY;
    } else if ([str isEqualToString:@"社会"]) {
        self.navigationItem.title = str;
        _dataUrl = JOKE_SOCIETY;
    } else if ([str isEqualToString:@"游戏"]) {
        self.navigationItem.title = str;
        _dataUrl = JOKE_GAME;
    } else if (str.length == 0) {
        self.navigationItem.title = @"排行榜";
        _dataUrl = JOKE_RECOMMEND;
    }

    //开始调用刷新,刷新起始页..
    [self.tableView.header beginRefreshing];
    
}

#pragma mark ----懒加载----
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return _dataArray;
}

- (NSMutableArray *)heightArray {
    if (_heightArray == nil) {
        _heightArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return _heightArray;
}

- (NSArray *)resourceArray {
    
    return @[@{@"title" : @"排行", @"image" : @"pl_recommend.png"}, @{@"title" : @"段子", @"image" : @"pl_joke.png"}, @{@"title" : @"趣图", @"image" : @"pl_image.png"}, @{@"title" : @"视频", @"image" : @"pl_video.png"}, @{@"title" : @"冷门", @"image" : @"pl_coldKnowLedge.png"}, @{@"title" : @"网红", @"image" : @"pl_net.png"}, @{@"title" : @"社会", @"image" : @"pl_society.png"}, @{@"title" : @"美女", @"image" : @"pl_beauty.png"}, @{@"title" : @"游戏", @"image" : @"pl_game.png"}];
    
}

#pragma mark ----创建切换资源的按钮----
- (void)plAddButtonForChangeResourcesAndNavagationTitle {
    
    PLAddView *addView = [[PLAddView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64 - 49) andButtonArray:self.resourceArray andRadiu:120];
    [self.view addSubview:addView];
    
}

/**
 切换资源
 */
- (void)plResfreshDataUrlAndRenewDataForCellWithindex:(NSInteger)index {
    
    [self.dataArray removeAllObjects];
    
    [self.tableView reloadData];
    
    [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    if (index == 0) {
        _dataUrl = JOKE_RECOMMEND;
        self.navigationItem.title = @"排行榜";
    } else if (index == 1) {
        _dataUrl = JOKE_JOKE;
        self.navigationItem.title = @"段子";
    } else if (index == 2) {
        _dataUrl = JOKE_IMAGE;
        self.navigationItem.title = @"游戏";
    } else if (index == 3) {
        _dataUrl = JOKE_VIDEO;
        self.navigationItem.title = @"视频";
    } else if (index == 4) {
        _dataUrl = JOKE_COLDKNOWLEDGE;
        self.navigationItem.title = @"冷知识";
    } else if (index == 5) {
        _dataUrl = JOKE_NET;
        self.navigationItem.title = @"网红";
    } else if (index == 6) {
        _dataUrl = JOKE_SOCIETY;
        self.navigationItem.title = @"社会";
    } else if (index == 7) {
        _dataUrl = JOKE_BEAUTY;
        self.navigationItem.title = @"美女";
    } else if (index == 8) {
        _dataUrl = JOKE_GAME;
        self.navigationItem.title = @"游戏";
    } else {
        self.navigationItem.title = @"主页";
    }
    
    //设置重新刷新数据
    [self plIsCheckToEndRefrsehOfCommon];
    
    [self.tableView.header beginRefreshing];
    
    [self plReleseButtonFromPresentViews];
}

#pragma mark ----释放button-----
- (void)plReleseButtonFromPresentViews {
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[PLAddView class]]) {

            for (UIView *subView in view.subviews) {
                [subView removeFromSuperview];
            }
            
            [view removeFromSuperview];
        }
    }
    
    //将tabBar的添加按钮变换为原来的
    PLMyTabBar *tabBar = [PLMyTabBar sharedPLMyTabBarWithFrame:CGRectMake(0, SCREEN_H - 49, SCREEN_W, 49)];
    
    if (tabBar.addButton.selected == YES) {
        tabBar.addButton.selected = !tabBar.addButton.selected;
    }
}

#pragma mark ----处理数据----
/**
 text
 */
- (void)plHandleDataOfTypeIsTextWithTextDictionary:(NSDictionary *)textDict {
    
    PLTextModel *textModel = [[PLTextModel alloc] init];
    
    //赋值
    textModel.type = [textDict objectForKey:@"type"];
    textModel.text = [textDict objectForKey:@"text"];
    textModel.name = [[textDict objectForKey:@"u"] objectForKey:@"name"];
    textModel.header = [[[textDict objectForKey:@"u"] objectForKey:@"header"] firstObject];
    
    NSDictionary *topComment = [textDict objectForKey:@"top_comment"];
    
    if (topComment != 0) {
        textModel.commentModel = [self plHandleDataOfTypeIsCommentWithCommentDictionary:topComment];
    }
    
    if (textModel.commentModel == nil) {
        //添加到数组
        [self.dataArray addObject:@[textModel]];
        
    } else {
        
        [self.dataArray addObject:@[textModel,@"YES"]];
    }
    
    //计算高度
    //10(头像距上) + 35(头像高度) + 10(头像距文本) + 本身字高度(?) + 距下高度(5)
    CGFloat textHeight = [self plGetHeightForString:textModel.text andFontSize:15];
    NSString *height = [NSString stringWithFormat:@"%f", 10 + 35 + 10 + textHeight + 10];
    textModel.textHeight = textHeight;
    [self.heightArray addObject:height];
}

/**
 image
 */
- (void)plHandleDataOfTypeIsImageWithimageDictionary:(NSDictionary *)imageDict {
    
    PLImageModel *imageModel = [[PLImageModel alloc] init];
    
    imageModel.type = [imageDict objectForKey:@"type"];
    imageModel.name = [[imageDict objectForKey:@"u"] objectForKey:@"name"];
    imageModel.header = [[[imageDict objectForKey:@"u"] objectForKey:@"header"] firstObject];
    imageModel.text = [imageDict objectForKey:@"text"];
    
    NSDictionary *topComment = [imageDict objectForKey:@"top_comment"];
    
    if (topComment.count != 0) {
        imageModel.commentModel = [self plHandleDataOfTypeIsCommentWithCommentDictionary:topComment];
    }
    
    //处理图片
    NSDictionary *tempImageDict = [imageDict objectForKey:@"image"];
    
    //宽高
    imageModel.width = [NSString stringWithFormat:@"%@", [tempImageDict objectForKey:@"width"]];
    imageModel.height = [NSString stringWithFormat:@"%@", [tempImageDict objectForKey:@"height"]];
    
    if (((NSArray *)[tempImageDict objectForKey:@"small"]).count != 0) {
        imageModel.small = [[tempImageDict objectForKey:@"small"] firstObject];
    }
    
    if (((NSArray *)[tempImageDict objectForKey:@"medium"]).count != 0) {
        imageModel.medium = [[tempImageDict objectForKey:@"medium"] firstObject];
    }
    
    if (((NSArray *)[tempImageDict objectForKey:@"big"]).count != 0) {
        imageModel.big = [[tempImageDict objectForKey:@"big"] firstObject];
    }
    
    if (imageModel.commentModel == nil) {
        //添加到数组
        [self.dataArray addObject:@[imageModel]];
        
    } else {
        
        [self.dataArray addObject:@[imageModel,@"YES"]];
    }

    
    //计算高度
//    10(头像距上) + 35(头像) + 10(文本和上空隙) + 文本(?) + 图片距上(5) + 图片高度(?) + 图片距下(5)
    CGFloat textHeight = [self plGetHeightForString:imageModel.text andFontSize:15];
    imageModel.textHeight = textHeight;
    CGFloat imageHeight = [PLImageCell plGetEqualHeightByImageWidth:[imageModel.width floatValue] andImageHeight:[imageModel.height floatValue]].size.height;
    CGFloat totalHeight = 10 + 35 + 10 + textHeight + 5 + imageHeight + 5;
    [self.heightArray addObject:[NSString stringWithFormat:@"%f", totalHeight]];
    
}

/**
 gif
 */
- (void)plHandleDataOfTypeIsGifWithgifDictionary:(NSDictionary *)gifDict {
    
    PLGifModel *gifModel = [[PLGifModel alloc] init];
    
    gifModel.type = [gifDict objectForKey:@"type"];
    gifModel.name = [[gifDict objectForKey:@"u"] objectForKey:@"name"];
    gifModel.header = [[[gifDict objectForKey:@"u"] objectForKey:@"header"] firstObject];
    gifModel.text = [gifDict objectForKey:@"text"];
    
    NSDictionary *topComment = [gifDict objectForKey:@"top_comment"];
    
    if (topComment.count != 0) {
        gifModel.commentModel = [self plHandleDataOfTypeIsCommentWithCommentDictionary:topComment];
    }
    
    NSDictionary *tempGifDict = [gifDict objectForKey:@"gif"];
    
    gifModel.width = [NSString stringWithFormat:@"%@", [tempGifDict objectForKey:@"width"]];
    gifModel.height = [NSString stringWithFormat:@"%@", [tempGifDict objectForKey:@"height"]];
    
    if (((NSArray *)[tempGifDict objectForKey:@"gif_thumbnail"]).count != 0) {
        gifModel.gif_thumbnail = [[tempGifDict objectForKey:@"gif_thumbnail"] firstObject];
    }
    
    if (((NSArray *)[tempGifDict objectForKey:@"images"]).count != 0) {
        gifModel.images = [[tempGifDict objectForKey:@"images"] firstObject];
    }
    
    if (gifModel.commentModel == nil) {
        //添加到数组
        [self.dataArray addObject:@[gifModel]];
        
    } else {
        
        [self.dataArray addObject:@[gifModel,@"YES"]];
    }
 
    //计算高度
    CGFloat textHeight = [self plGetHeightForString:gifModel.text andFontSize:15];
    gifModel.textHeight = textHeight;
    CGFloat totalHeight = 10 + 35 + 10 + textHeight + 5 + [gifModel.height floatValue] + 5;
    [self.heightArray addObject:[NSString stringWithFormat:@"%f", totalHeight]];
}

/**
 video
 */
- (void)plHandleDataOfTypeIsVideoWithVideoDictionary:(NSDictionary *)videoDict {
    
    PLVideoModel *videoModel = [[PLVideoModel alloc] init];
    
    videoModel.type = [videoDict objectForKey:@"type"];
    videoModel.name = [[videoDict objectForKey:@"u"] objectForKey:@"name"];
    videoModel.header = [[[videoDict objectForKey:@"u"] objectForKey:@"header"] firstObject];
    videoModel.text = [videoDict objectForKey:@"text"];
    
    NSDictionary *topComment = [videoDict objectForKey:@"top_comment"];
    
    if (topComment.count != 0) {
        videoModel.commentModel = [self plHandleDataOfTypeIsCommentWithCommentDictionary:topComment];
    }
    
    NSDictionary *tempVideoDict = [videoDict objectForKey:@"video"];
    
    videoModel.width = [NSString stringWithFormat:@"%@", [tempVideoDict objectForKey:@"width"]];
    videoModel.height = [NSString stringWithFormat:@"%@", [tempVideoDict objectForKey:@"height"]];
    
    if (((NSArray *)[tempVideoDict objectForKey:@"video"]).count != 0) {
        videoModel.video = [[tempVideoDict objectForKey:@"video"] firstObject];
    }
    
    if (((NSArray *)[tempVideoDict objectForKey:@"thumbnail"]).count != 0) {
        videoModel.thumbnail = [[tempVideoDict objectForKey:@"thumbnail"] firstObject];
    }
    
    if (videoModel.commentModel == nil) {
        [self.dataArray addObject:@[videoModel]];
    } else {
        [self.dataArray addObject:@[videoModel, @"YES"]];
    }
    
    //计算高度
    //10(头像距上) + 35(头像) + 10(文本和上空隙) + 文本(?) + 图片距上(5) + 图片高度(?) + 图片距下(5)
    CGFloat textHeight = [self plGetHeightForString:videoModel.text andFontSize:15];
    videoModel.textHeight = textHeight;
    CGFloat videoHeight = [PLVideoCell plGetEqualHeightByVideoWidthAnd:[videoModel.width floatValue] andVideoHeight:[videoModel.height floatValue]].size.height;
    CGFloat totalHeight = 10 + 35 + 10 + textHeight + 5 + videoHeight + 5;
    [self.heightArray addObject:[NSString stringWithFormat:@"%f", totalHeight]];
}

/**
 html
 */
- (void)plHandleDataOfTypeIsHtmlWithHtmlDictionary:(NSDictionary *)htmlDict {
    
    PLHtmlModel *htmlModel = [[PLHtmlModel alloc] init];
    
    htmlModel.type = [htmlDict objectForKey:@"type"];
    htmlModel.name = [[htmlDict objectForKey:@"u"] objectForKey:@"name"];
    htmlModel.header = [[[htmlDict objectForKey:@"u"] objectForKey:@"header"] firstObject];
    
    NSDictionary *topComment = [htmlDict objectForKey:@"top_comment"];
    
    if (topComment.count != 0) {
        htmlModel.commentModel = [self plHandleDataOfTypeIsCommentWithCommentDictionary:topComment];
    }
    
    htmlModel.desc = [[htmlDict objectForKey:@"html"] objectForKey:@"desc"];
    htmlModel.body = [[htmlDict objectForKey:@"html"] objectForKey:@"body"];
    
    if (htmlModel.commentModel == nil) {
        [self.dataArray addObject:@[htmlModel]];
    } else {
        [self.dataArray addObject:@[htmlModel, @"YES"]];
    }
    
    //添加高度,防止崩坏
    [self.heightArray addObject:@""];
}

/**
 处理评论者
 */
- (PLCommentModel *)plHandleDataOfTypeIsCommentWithCommentDictionary:(NSDictionary *)commentDict {
    
    PLCommentModel *commentModel = [[PLCommentModel alloc] init];
    commentModel.header = [[[commentDict objectForKey:@"u"] objectForKey:@"header"] firstObject];
    commentModel.name = [[commentDict objectForKey:@"u"] objectForKey:@"name"];
    commentModel.content = [commentDict objectForKey:@"content"];
    
    return commentModel;
}

- (float) plGetHeightForString:(NSString *)value andFontSize:(CGFloat)size
{
    CGFloat titleHeight;
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGRect frame = [value boundingRectWithSize:CGSizeMake(325, CGFLOAT_MAX) options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil];
    
    titleHeight = ceilf(frame.size.height);
    
    return titleHeight+2;  // 加两个像素,防止emoji被切掉.
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
