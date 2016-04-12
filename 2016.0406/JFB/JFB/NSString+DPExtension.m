//
//  NSString+DPExtension.m
//  JFB
//
//  Created by IOS on 16/3/10.
//  Copyright © 2016年 李俊阳. All rights reserved.
//

#import "NSString+DPExtension.h"

@implementation NSString (DPExtension)
-(NSDate *)getDateFromTimeString{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* ouputDate = [inputFormatter dateFromString:self];
    return ouputDate;
}
//判断一个字符串是否为空，如果为空赋一个初值
-(NSString *)checkStringIsNullWithNullString:(NSString *)str{
    NSString *oldString=self;
    if (oldString==nil || [oldString isEqualToString:@""] || [oldString isEqualToString:@"<null>"] || [oldString isEqualToString:@"(null)"]) {
        oldString=str;
    }
    return oldString;
}
@end
