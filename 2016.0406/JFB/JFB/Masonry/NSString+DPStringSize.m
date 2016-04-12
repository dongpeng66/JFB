//
//  NSString+DPStringSize.m
//  JFB
//
//  Created by IOS on 16/3/17.
//  Copyright © 2016年 李俊阳. All rights reserved.
//

#import "NSString+DPStringSize.h"

@implementation NSString (DPStringSize)
-(CGSize)stringGetSizeWithFont:(CGFloat)font{
    CGSize labelSize = CGSizeMake(320,2000);
    CGSize fontStringSize = [self boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size;
    return fontStringSize;
}
@end
