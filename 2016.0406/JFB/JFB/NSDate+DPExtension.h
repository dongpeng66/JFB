//
//  NSDate+DPExtension.h
//  JFB
//
//  Created by IOS on 16/3/10.
//  Copyright © 2016年 李俊阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DPExtension)
//根据NSDate获取这个时间的月份和天数的字符串
-(NSString *)getCurrentMonthDayTime;
//根据NSDate获取这个时间的月份和天数、小时、分钟的字符串
-(NSString *)getCurrentMonthDayHourMinuteTime;
//根据NSDate获取这个时间的年份、月份、天数的字符串
-(NSString *)getCurrentYearMonthDayTime;
//根据NSDate获取这个时间的年份、月份的字符串
-(NSString *)getCurrentYearMonthTime;
//根据NSDate获取这个时间的年份的字符串
-(NSString *)getCurrentYearTime;
//根据NSDate获取这个时间的月份的字符串
-(NSString *)getCurrentMonthTime;
@end
