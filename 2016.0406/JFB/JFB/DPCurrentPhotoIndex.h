//
//  DPCurrentPhotoIndex.h
//  JFB
//
//  Created by IOS on 16/3/21.
//  Copyright © 2016年 李俊阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPCurrentPhotoIndex : NSObject
//当前的图片index
@property (assign,nonatomic) NSInteger photoIndex;
/**
 *  创建单例对象
 */
+ (instancetype)shareCurrentPhotoIndex;
@end
