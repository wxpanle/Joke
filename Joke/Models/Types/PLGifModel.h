//
//  PLGifModel.h
//  Joke
//
//  Created by qianfeng on 16/6/15.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import "PLUserModel.h"

@interface PLGifModel : PLUserModel

//图片文字
@property (nonatomic, strong) NSString *text;

//动态图
@property (nonatomic, strong) NSString *images;

//动态图缓冲
@property (nonatomic, strong) NSString *gif_thumbnail;

//图片宽度
@property (nonatomic, strong) NSString *width;

//图片高度
@property (nonatomic, strong) NSString *height;

@end
/*图片   gif
 "text": "一言不合就开始斗舞",
 "gif": {
 "images": [
 "http://wimg.spriteapp.cn/ugc/2016/06/13/575e4ea884456.gif",
 "http://dimg.spriteapp.cn/ugc/2016/06/13/575e4ea884456.gif"
 ],
 "width": 289,
 "gif_thumbnail": [
 "http://wimg.spriteapp.cn/ugc/2016/06/13/575e4ea884456_a_1.jpg",
 "http://dimg.spriteapp.cn/ugc/2016/06/13/575e4ea884456_a_1.jpg"
 ],
 "download_url": [
 "http://wimg.spriteapp.cn/ugc/2016/06/13/575e4ea884456_d.jpg",
 "http://dimg.spriteapp.cn/ugc/2016/06/13/575e4ea884456_d.jpg",
 "http://wimg.spriteapp.cn/ugc/2016/06/13/575e4ea884456_a_1.jpg",
 "http://dimg.spriteapp.cn/ugc/2016/06/13/575e4ea884456_a_1.jpg"
 ],
 "height": 159
 },
 "share_url": "http://c.f.zk111.cn/share/18906254.html?wx.qq.com",
 "top_comment": {
 "content": "花格衣服的大姐终于转身了，她将会选择谁加入她的战队呢，敬请期待下次",
 "u": {
 "header": [
 "http://wimg.spriteapp.cn/profile/large/2016/01/10/56925f9da58c8_mini.jpg",
 "http://dimg.spriteapp.cn/profile/large/2016/01/10/56925f9da58c8_mini.jpg"
 ],
 
 "name": "\\猎~艳·√"
 },
 },
 "u": {
 "header": [
 "http://wimg.spriteapp.cn/profile/large/2016/06/09/57596c6d8cb16_mini.jpg",
 "http://dimg.spriteapp.cn/profile/large/2016/06/09/57596c6d8cb16_mini.jpg"
 ],
 "name": "搞趣动态图"
 },
 "type": "gif",
 "id": "18906254"
 */