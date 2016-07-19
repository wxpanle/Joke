//
//  PLImageModel.h
//  Joke
//
//  Created by qianfeng on 16/6/15.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import "PLUserModel.h"

@interface PLImageModel : PLUserModel

//标题
@property (nonatomic, strong) NSString *text;

//图片(small)
@property (nonatomic, strong) NSString *small;

//图片(medium)
@property (nonatomic, strong) NSString *medium;

//图片(big)
@property (nonatomic, strong) NSString *big;

//图片宽度
@property (nonatomic, strong) NSString *width;

//图片高度
@property (nonatomic, strong) NSString *height;

@end
/*图片
 "comment": "47",
 "text": "一张很有深意的图片！你看的懂吗",
 "image": {
 "medium": [
 "http://ww3.sinaimg.cn/bmiddle/c1e8ffd5jw1f4uvji0oykj20g40lh3zw.jpg"
 ],
 "big": [
 "http://ww3.sinaimg.cn/large/c1e8ffd5jw1f4uvji0oykj20g40lh3zw.jpg",
 "http://wimg.spriteapp.cn/ugc/2016/06/13/575ebbd25a520_1.jpg",
 "http://dimg.spriteapp.cn/ugc/2016/06/13/575ebbd25a520_1.jpg"
 ],
 "download_url": [
 "http://wimg.spriteapp.cn/ugc/2016/06/13/575ebbd25a520_d.jpg",
 "http://dimg.spriteapp.cn/ugc/2016/06/13/575ebbd25a520_d.jpg",
 "http://wimg.spriteapp.cn/ugc/2016/06/13/575ebbd25a520.jpg",
 "http://dimg.spriteapp.cn/ugc/2016/06/13/575ebbd25a520.jpg"
 ],
 "height": 773,
 "width": 580,
 "small": [
 "http://ww3.sinaimg.cn/mw240/c1e8ffd5jw1f4uvji0oykj20g40lh3zw.jpg"
 ]
 },
 "share_url": "http://b.f.zk111.com.cn/share/18911302.html?wx.qq.com",
 "top_comment": {
 "content": "有这样的男室友，每天不敢早睡，只能默默的玩电脑",
 "u": {
 "header": [
 "http://wimg.spriteapp.cn/profile/large/2016/01/19/569ddb7c8c73f_mini.jpg",
 "http://dimg.spriteapp.cn/profile/large/2016/01/19/569ddb7c8c73f_mini.jpg"
 ],
 "name": "好肥一支鱼111"
 },
 },
 "u": {
 "header": [
 "http://wimg.spriteapp.cn/profile/large/2016/05/28/5749bdf0d60b9_mini.jpg",
 "http://dimg.spriteapp.cn/profile/large/2016/05/28/5749bdf0d60b9_mini.jpg"
 ],
 "is_v": false,
 "uid": "16525926",
 "is_vip": true,
 "name": "百思污虫"
 },
 "type": "image",
 "id": "18911302"
 */
