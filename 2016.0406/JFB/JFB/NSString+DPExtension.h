//
//  NSString+DPExtension.h
//  JFB
//
//  Created by IOS on 16/3/10.
//  Copyright © 2016年 李俊阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DPExtension)
///根据时间转换成一个NSDate对象
-(NSDate *)getDateFromTimeString;
-(NSString *)checkStringIsNullWithNullString:(NSString *)str;
@end
