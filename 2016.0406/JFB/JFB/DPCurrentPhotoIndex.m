//
//  DPCurrentPhotoIndex.m
//  JFB
//
//  Created by IOS on 16/3/21.
//  Copyright © 2016年 李俊阳. All rights reserved.
//

#import "DPCurrentPhotoIndex.h"

@implementation DPCurrentPhotoIndex
+ (instancetype)shareCurrentPhotoIndex{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DPCurrentPhotoIndex alloc] init];
    });
    return instance;
}
@end
