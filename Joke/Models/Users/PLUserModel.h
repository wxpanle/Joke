//
//  PLUserModel.h
//  Joke
//
//  Created by qianfeng on 16/6/15.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PLCommentModel;
@interface PLUserModel : NSObject

//作者头像
@property (nonatomic, strong) NSString *header;

//作者名字
@property (nonatomic, strong) NSString *name;

//当前作者发表的类型
@property (nonatomic, strong) NSString *type;

//当前评论者
@property (nonatomic, strong) PLCommentModel *commentModel;

//文字高度
@property (nonatomic, assign) CGFloat textHeight;


@end
/*视频
 "text": "I Really Like You - Carly Rae Jepsen 猝不及防啊！一开口跪了，完全太好听了！",
 "share_url": "http://a.f.winapp111.mobi/share/18895632.html?wx.qq.com",
 "u": {
    "header": [
    "http://dimg.spriteapp.cn/profile/picture1/M00/10/B2/wKiFQ1SFWpWAXCunAAAMc8vQUq0.cn_145",
    "http://wimg.spriteapp.cn/profile/picture1/M00/10/B2/wKiFQ1SFWpWAXCunAAAMc8vQUq0.cn_145"
    ],
    "name": "一男优梦"
 },
 "video": {
    "height": 480,
    "width": 854,
    "video": [
    "http://wvideo.spriteapp.cn/video/2016/0612/575d2faccbb87_wpd.mp4",
    "http://bvideo.spriteapp.cn/video/2016/0612/575d2faccbb87_wpd.mp4"
    ],
    "thumbnail": [
    "http://dimg.spriteapp.cn/picture/2016/0612/575d2fa9bf76e__b.jpg",
    "http://wimg.spriteapp.cn/picture/2016/0612/575d2fa9bf76e__b.jpg"
    ],
    "download": [
    "http://wvideo.spriteapp.cn/video/2016/0612/575d2faccbb87_wpc.mp4",
    "http://bvideo.spriteapp.cn/video/2016/0612/575d2faccbb87_wpc.mp4"
    ]
 },
 type:video
 */
