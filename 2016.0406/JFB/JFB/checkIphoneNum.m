//
//  checkIphoneNum.m
//  JFB
//
//  Created by IOS on 16/3/10.
//  Copyright © 2016年 李俊阳. All rights reserved.
//

#import "checkIphoneNum.h"

@implementation checkIphoneNum
// 创建单例
+ (instancetype)shareCheckIphoneNum{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[checkIphoneNum alloc] init];
    });
    return instance;
}
+ (NSInteger)checkIphoneGetNormalLabelFont:(CGRect)frame{
    int labelFont=14;
    int height=(int)frame.size.height;
    if (height==480) {
        labelFont=12;
    }else if (height==568){
        labelFont=12;
    }else if (height==667){
        labelFont=14;
    }else if (height==736){
        labelFont=14;
    }
    return labelFont;
}
+ (NSInteger)checkIphoneGetDayLabelFont:(CGRect)frame{
    int labelFont=12;
    int height=(int)frame.size.height;
    if (height==480) {
        labelFont=12;
    }else if (height==568){
        labelFont=12;
    }else if (height==667){
        labelFont=14;
    }else if (height==736){
        labelFont=14;
    }
    return labelFont;
}
+(NSInteger)checkIphoneGetMoveTionMargin:(CGRect)frame{
    int labelFont=478;
    int height=(int)frame.size.height;
    if (height==480) {
        //4/4s
        labelFont=478-70;
    }else if (height==568){
        //5/5s
        labelFont=320;
    }else if (height==667){
        //6/6s
        labelFont=270;
    }else if (height==736){
        //6plus 6splus
        labelFont=316-70;
    }
    return labelFont;
}
+(NSInteger)checkIphoneGetHomeActivityViewHeight:(CGRect)frame{
    float activityViewH=667.0;;
    int height=(int)frame.size.height;
    if (height==480) {
        //4/4s
        activityViewH=787.0;
    }else if (height==568){
        //5/5s
        activityViewH=752.0;
    }else if (height==667){
        //6/6s
        activityViewH=742.0;
    }else if (height==736){
        //6plus 6splus
        activityViewH=737.0;
    }
    return activityViewH;
}
@end
