//
//  PLMyViewController.m
//  Joke
//
//  Created by qianfeng on 16/6/21.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import "PLMyViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "PLMyTabBar.h"

@interface PLMyViewController () <UITableViewDataSource, UITableViewDelegate> {
    UITableView *_tableView;
    UIView *_nightView;
    UIButton *_showTypeButton;
    BOOL _fontType;
    UILabel *_txLabel;
    UIView *_headView;
}

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *typeArray;
@end

@implementation PLMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的";
    
    _fontType = [[[NSUserDefaults standardUserDefaults] objectForKey:@"typeface"] boolValue];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建tablView
    [self plCreatetableViewUI];
}

#pragma mark ----导航栏相关----
/**
 修改导航栏属性
 */
- (void)plChangeNavigationControllerNavigationBarTitleTextAttributes {
    
    _fontType = [[[NSUserDefaults standardUserDefaults] objectForKey:@"typeface"] boolValue];
    
    if (_fontType) {
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:50 / 255.0 green:150 / 255.0 blue:220 / 255.0 alpha:1.0f], NSFontAttributeName : [UIFont fontWithName:@"chen  dai  ming" size:20]};
    } else {
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:50 / 255.0 green:150 / 255.0 blue:220 / 255.0 alpha:1.0f], NSFontAttributeName : [UIFont systemFontOfSize:20]};
    }
}

#pragma mark ----创建tableView----
- (void)plCreatetableViewUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64 - 49) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, -200, SCREEN_W, 200)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 200)];
    imageView.image = [UIImage imageNamed:@"pl_myheaderview.jpg"];
    
    _txLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _headView.frame.size.height / 2.0 - 50, SCREEN_W, 80)];
    _txLabel.numberOfLines = 0;
    _txLabel.lineBreakMode = NSLineBreakByWordWrapping;
    if (_fontType) {
        _txLabel.font = [UIFont fontWithName:@"chen  dai  ming" size:18];
    } else {
        _txLabel.font = [UIFont systemFontOfSize:18];
    }
    _txLabel.textAlignment = NSTextAlignmentCenter;
    _txLabel.textColor = [UIColor blackColor];
    NSString *str = @"愿段子带给你的不仅仅是开怀一笑,而是真正的快乐.\n---by路人甲";
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 24)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(24, 8)];
    [_txLabel setAttributedText:string];
    [_headView addSubview:imageView];
    [_headView addSubview:_txLabel];
    [_tableView addSubview:_headView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //纵向偏移量
    float yOffset = scrollView.contentOffset.y;
    
    //横向偏移量
    float xOffset = (yOffset + 200) / 2;
    
    if (yOffset < -200) {
        CGRect frame = _headView.frame;
        
        //横向偏移量
        frame.origin.x = xOffset;
        
        //纵向偏移量
        frame.origin.y = yOffset;
        
        //宽度
        frame.size.width = SCREEN_W + fabsf(xOffset) * 2;
        
        //高度
        frame.size.height = -yOffset;
        
        _headView.frame = frame;
        
        for (UIView *view in _headView.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
            }
            
            if ([view isKindOfClass:[UILabel class]]) {
                view.frame = CGRectMake(fabsf(xOffset), _headView.frame.size.height / 2.0 - 50, SCREEN_W, view.frame.size.height);
            }
        }
    }
}

#pragma mark ----tableView代理相关---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        if (_showTypeButton.selected == YES) {
            return self.typeArray.count + 1;
        } else {
            return 1;
        }
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *typeResued= @"typeCell";
    
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"clearCell"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"clearCell"];
            
            UIButton *btn = [self plCreateButtonWithimageName:@"pl_clear_cache.png" andSelecteImageName:nil target:nil selector:nil];
            cell.accessoryView = btn;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [self plChangeTextLabelFontWithCell:cell andIndexPath:indexPath];
        
        return cell;
    } else if (indexPath.section == 1) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nightCell"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nihgtCell"];
            
            UISwitch *swit = [[UISwitch alloc] init];
            swit.onTintColor = [UIColor greenColor];
            [swit addTarget:self action:@selector(openOrCloseNightModel:) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView = swit;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [self plChangeTextLabelFontWithCell:cell andIndexPath:indexPath];
        
        return cell;
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"typeCell"];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"typeCell"];
                
                _showTypeButton = [self plCreateButtonWithimageName:@"pl_type_hidden.png" andSelecteImageName:@"pl_type_show.png" target:self selector:@selector(plButtonToShowOrHiddenType:)];
                cell.accessoryView = _showTypeButton;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [self plChangeTextLabelFontWithCell:cell andIndexPath:indexPath];
            
            return cell;
        } else {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:typeResued];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:typeResued];
                cell.textLabel.font = [UIFont systemFontOfSize:13];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.textLabel.textColor = [UIColor lightGrayColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if (_fontType) {
                cell.textLabel.font = [UIFont fontWithName:@"chen  dai  ming" size:15];
            } else {
                cell.textLabel.font = [UIFont systemFontOfSize:15];
            }

            
            NSString *type = [[NSUserDefaults standardUserDefaults] objectForKey:@"typeIndex"];
            
            if (indexPath.row == [type floatValue]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }

            cell.textLabel.text = [self.typeArray objectAtIndex:indexPath.row - 1];
            
            return cell;
        }
    } else if (indexPath.section == 3) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fontCell"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fontCell"];
            
            UISwitch *swit = [[UISwitch alloc] init];
            swit.onTintColor = [UIColor greenColor];
            [swit addTarget:self action:@selector(openOrCloseTypeFace:) forControlEvents:UIControlEventTouchUpInside];
            BOOL on = [[[NSUserDefaults standardUserDefaults] objectForKey:@"typeface"] boolValue];
            swit.on = on;
            cell.accessoryView = swit;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [self plChangeTextLabelFontWithCell:cell andIndexPath:indexPath];
        
        return cell;
    }
    
    static NSString *resued = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resued];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resued];
    }
    
    return cell;
}

/**
 cell的公共部分
 */
- (void)plChangeTextLabelFontWithCell:(UITableViewCell *)cell andIndexPath:(NSIndexPath *)indexPath {
    
    if (_fontType) {
        cell.textLabel.font = [UIFont fontWithName:@"chen  dai  ming" size:15];
    } else {
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.section];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        [self plPresentAnAlertWithSize:[self plCalculateCachesSizeWithPath:[self plGetCacheFilePath]]];
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            return;
        } else {
            //保存一下点击了哪一行
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%ld" ,(long)indexPath.row] forKey:@"typeIndex"];
            //保存相对应的名字
            [[NSUserDefaults standardUserDefaults] setValue:[self.typeArray objectAtIndex:indexPath.row - 1] forKey:@"typeName"];
            [_tableView reloadData];
        }
    }
}

#pragma mark ----懒加载----

- (NSArray *)dataArray {
    return @[@"清理缓存", @"夜间模式", @"主页加载的第一类型(点击选择)", @"是否切换为便于阅读的书香体"];
}

- (NSArray *)typeArray {
    return @[@"排行榜", @"段子", @"网红", @"趣图", @"视频", @"冷知识", @"美女", @"社会", @"游戏"];
}

#pragma mark ----cell点击----
/**
 夜间模式
 */
- (void)openOrCloseNightModel:(UISwitch *)swi {
    if (swi.on) {
        
        //添加视图
        UIApplication *application = [UIApplication sharedApplication];
        AppDelegate *delegate = application.delegate;
        _nightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
        _nightView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        _nightView.userInteractionEnabled = NO;
        [delegate.window addSubview:_nightView];
    } else {
        [_nightView removeFromSuperview];
    }
}

/**
 切换字体
 */
- (void)openOrCloseTypeFace:(UISwitch *)swi {
    
    if (swi.on) {
        _fontType = YES;
    } else {
        _fontType = NO;
    }
    
    PLMyTabBar *myTabBar = [PLMyTabBar sharedPLMyTabBarWithFrame:CGRectMake(0, SCREEN_H - 49, SCREEN_W, 49)];
    for (UIView *view in myTabBar.subviews) {
        for (UIView *subView in view.subviews) {
            if ([subView isKindOfClass:[UILabel class]]) {
                if (swi.on) {
                    ((UILabel *)subView).font = [UIFont fontWithName:@"chen  dai  ming" size:15];
                } else {
                    ((UILabel *)subView).font = [UIFont systemFontOfSize:15];
                }
            }
        }
    }
    
     [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", swi.on] forKey:@"typeface"];
    
    //本页刷新
    ((ViewController *)((UINavigationController *)self.tabBarController.viewControllers.firstObject).viewControllers.firstObject).fontFace = swi.on;
    
    //主页刷新
    [((ViewController *)((UINavigationController *)self.tabBarController.viewControllers.firstObject).viewControllers.firstObject).tableView reloadData];
    
    //刷新导航栏数据
    
    //本页
    [self plChangeNavigationControllerNavigationBarTitleTextAttributes];
    
    if (_fontType) {
        ((UINavigationController *)self.tabBarController.viewControllers.firstObject).navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:50 / 255.0 green:150 / 255.0 blue:220 / 255.0 alpha:1.0f], NSFontAttributeName : [UIFont fontWithName:@"chen  dai  ming" size:20]};
    } else {
         ((UINavigationController *)self.tabBarController.viewControllers.firstObject).navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:50 / 255.0 green:150 / 255.0 blue:220 / 255.0 alpha:1.0f], NSFontAttributeName : [UIFont systemFontOfSize:20]};
    }
    
    [_tableView reloadData];
    
    if (_fontType) {
        _txLabel.font = [UIFont fontWithName:@"chen  dai  ming" size:18];
    } else {
        _txLabel.font = [UIFont systemFontOfSize:18];
    }
}

/**
 展开分组
 */
- (void)plButtonToShowOrHiddenType:(UIButton *)btn {
    
    btn.selected = !btn.selected;
    [_tableView reloadData];
}

#pragma mark ----清理缓存相关----
/**
 获得缓存的路径
 */
- (NSString *)plGetCacheFilePath {
    
    //获取沙盒缓存文件路径
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
}

/**
 计算缓存文件的大小
 */
- (CGFloat)plCalculateCachesSizeWithPath:(NSString *)path {
    //计算缓存文件夹下所有文件的大小
    
    //获取文件夹管理对象
    NSFileManager *manager = [NSFileManager defaultManager];
    
    //定义一个变量用来承接所有文件的大小
    CGFloat returnFileSize = 0.0;
    
    //判断该目录是否存在,只有存在才可以进行操作
    if ([manager fileExistsAtPath:path]) {
        
        //获取该目录下所有的文件
        NSArray *fileArray = [manager subpathsAtPath:path];
        
        //遍历该目录下所有的文件
        for (NSString *fileName in fileArray) {
            
            //获取每个子文件的路径
            NSString *filePath = [path stringByAppendingPathComponent:fileName];
            
            //每个文件的大小
            unsigned long long fileSize = [manager attributesOfItemAtPath:filePath error:nil].fileSize;
            
            //将字节转化为M
            returnFileSize += fileSize / 1024.0 / 1024.0;
        }
    }
    
    return returnFileSize;
}

/**
 提示框
 */
- (void)plPresentAnAlertWithSize:(CGFloat)size {
    
    //提示框
    UIAlertController *cachesAlert = nil;
    
    if (size < 0.2f) {
        cachesAlert = [UIAlertController alertControllerWithTitle:@"清理缓存" message:@"很干净不需要清理" preferredStyle:UIAlertControllerStyleAlert];
    } else {
        cachesAlert =  [UIAlertController alertControllerWithTitle:@"清理缓存" message:[NSString stringWithFormat:@"当前有%.2fM缓存,是否清理",size] preferredStyle:UIAlertControllerStyleAlert];
    }
    
    
    //添加相关按钮
    
    //取消
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    //OK
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [self plClearCachesWithFilePath:[self plGetCacheFilePath]];
        
    }];
    
    //添加相关按钮
    if (size > 0.2f) {
        [cachesAlert addAction:okAction];
    }
    [cachesAlert addAction:noAction];
    
    [self presentViewController:cachesAlert animated:YES completion:nil];
}

/**
 清理缓存
 */
- (void)plClearCachesWithFilePath:(NSString *)path {
    
    //获取文件夹对象
    NSFileManager *manager = [NSFileManager defaultManager];
    
    //判断目录是否存在
    if ([manager fileExistsAtPath:path]) {
        
        //查找子目录
        NSArray *fileArray = [manager subpathsAtPath:path];
        
        //遍历数组
        for (NSString *fileName in fileArray) {
        
            //删除其余文件
            NSString *filePath = [path stringByAppendingPathComponent:fileName];
            
            [manager removeItemAtPath:filePath error:nil];
        }
    }
}

/**
 创建一个UIButton
 */
- (UIButton *)plCreateButtonWithimageName:(NSString *)imageName andSelecteImageName:(NSString *)selectImageName target:(id)target selector:(SEL)selector {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 32, 32);
    [button setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], imageName]] forState:UIControlStateNormal];
    if (selectImageName.length != 0) {
        [button setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], selectImageName]] forState:UIControlStateSelected];
    }
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
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
