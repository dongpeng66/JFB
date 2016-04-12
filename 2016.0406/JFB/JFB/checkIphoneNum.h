//
//  checkIphoneNum.h
//  JFB
//
//  Created by IOS on 16/3/10.
//  Copyright © 2016年 李俊阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface checkIphoneNum : NSObject
@property (assign,nonatomic) NSInteger textFont;
@property (assign,nonatomic) NSInteger dayTextFont;
//
@property (nonatomic,assign)NSInteger moveTionLength;
//首页的活动首页的高度
@property (assign,nonatomic) NSInteger homeActivityViewHeight;
/**
 *  创建单例对象
 */
+ (instancetype)shareCheckIphoneNum;
+ (NSInteger)checkIphoneGetNormalLabelFont:(CGRect)frame;
+ (NSInteger)checkIphoneGetDayLabelFont:(CGRect)frame;
+ (NSInteger)checkIphoneGetMoveTionMargin:(CGRect)frame;
+(NSInteger)checkIphoneGetHomeActivityViewHeight:(CGRect)frame;

@end
