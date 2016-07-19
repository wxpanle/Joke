//
//  PLHtmlViewController.m
//  Joke
//
//  Created by qianfeng on 16/6/16.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import "PLHtmlViewController.h"

@interface PLHtmlViewController ()

@end

@implementation PLHtmlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"冷知识";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *str = [NSString stringWithFormat:@"<html> \n"
     "<head> \n"
     "<style type=\"text/css\">\n"
     "body {font-family: \"%@\"; font-size: %f; }\n"
     "</style> \n"
     "</head> \n"
     "<body>%@</body> \n"
     "</html>", @"宋体", 15.0, self.htmlUrl];
   
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64)];
    [self.view addSubview:webView];
    [webView loadHTMLString:str baseURL:nil];
    
    
    //创建左按钮用于返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/pl_back.png",[[NSBundle mainBundle] resourcePath]]] style:UIBarButtonItemStylePlain target:self action:@selector(plBackBarButtonItem)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)plBackBarButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
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
