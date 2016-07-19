//
//  PLHtmlModel.h
//  Joke
//
//  Created by qianfeng on 16/6/15.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import "PLUserModel.h"

@interface PLHtmlModel : PLUserModel

//冷知识详细
@property (nonatomic, strong) NSString *desc;

//html网页
@property (nonatomic, strong) NSString *body;

@end

/*html
 "comment": "26",
 "bookmark": "128",
 "text": "",
 "up": "762",
 "share_url": "http://c.f.costrub.com/share/18903549.html?wx.qq.com",
 "html": {
 "body": "script>\n\n</body>\n\n</html>\n",
 "title": "失传已久的读心术，99.99%人都被猜对！太准了！ (10030)",
 "source_url": "http://d.api.budejie.com/topic/article/18903549.html?",
 "desc": "【冷知识】失传已久的读心术，99.99%人都被猜对",
 },
 "u": {
 "header": [
 "http://tp1.sinaimg.cn/2649931432/50/5660378678/0",
 "http://tp1.sinaimg.cn/2649931432/50/5660378678/0"
 ],
 "name": "vhbbvv"
 },
 "type": "html",
 */
