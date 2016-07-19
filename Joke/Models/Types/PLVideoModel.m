//
//  PLVideoModel.m
//  Joke
//
//  Created by qianfeng on 16/6/15.
//  Copyright © 2016年 潘乐. All rights reserved.
//

#import "PLVideoModel.h"

@implementation PLVideoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"width"] || [key isEqualToString:@"height"]) {
        [self setValue:[NSString stringWithFormat:@"%@",value] forKey:key];
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"width---%@ height----%@", self.width, self.height];
}

@end
