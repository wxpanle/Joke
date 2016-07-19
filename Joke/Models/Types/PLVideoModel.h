//
//  PLVideoModel.h
//  Joke
//
//  Created by qianfeng on 16/6/15.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import "PLUserModel.h"

@interface PLVideoModel : PLUserModel

//文本
@property (nonatomic, strong) NSString *text;

//视频
@property (nonatomic, strong) NSString *video;

//视频展示图
@property (nonatomic, strong) NSString *thumbnail;

//视频宽度
@property (nonatomic, strong) NSString *width;

//视频高度
@property (nonatomic, strong) NSString *height;

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
