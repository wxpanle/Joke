//
//  PLCommentModel.h
//  Joke
//
//  Created by qianfeng on 16/6/15.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLCommentModel : NSObject

//评论者头像
@property (nonatomic, strong) NSString *header;

//评论者姓名
@property (nonatomic, strong) NSString *name;

//评论
@property (nonatomic, strong) NSString *content;

@end
//"top_comment": {
//    "content": "花格衣服的大姐终于转身了，她将会选择谁加入她的战队呢，敬请期待下次",
//    "u": {
//        "header": [
//                   "http://wimg.spriteapp.cn/profile/large/2016/01/10/56925f9da58c8_mini.jpg",
//                   "http://dimg.spriteapp.cn/profile/large/2016/01/10/56925f9da58c8_mini.jpg"
//                   ],
//        
//        "name": "\\猎~艳·√"
//    },
