//
//  NSDate+DPExtension.m
//  JFB
//
//  Created by IOS on 16/3/10.
//  Copyright © 2016年 李俊阳. All rights reserved.
//

#import "NSDate+DPExtension.h"

@implementation NSDate (DPExtension)
-(NSString *)getCurrentMonthDayTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM月dd日";
    NSString *dateStr = [formatter stringFromDate:self];
    return dateStr;
}
-(NSString *)getCurrentMonthDayHourMinuteTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM月dd日 HH:mm";
    NSString *dateStr = [formatter stringFromDate:self];
    return dateStr;
}
-(NSString *)getCurrentYearMonthDayTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月dd日";
    NSString *dateStr = [formatter stringFromDate:self];
    return dateStr;
}
-(NSString *)getCurrentYearMonthTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月";
    NSString *dateStr = [formatter stringFromDate:self];
    return dateStr;
}
-(NSString *)getCurrentYearTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年";
    NSString *dateStr = [formatter stringFromDate:self];
    return dateStr;
}
-(NSString *)getCurrentMonthTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM月";
    NSString *dateStr = [formatter stringFromDate:self];
    return dateStr;
}
@end
