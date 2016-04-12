//
//  JFBCountDownDayView.h
//  JFB
//
//  Created by IOS on 16/3/10.
//  Copyright © 2016年 李俊阳. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TimerStopBlock)();
@interface JFBCountDownDayView : UIView
// 时间戳
@property (nonatomic,assign)NSInteger timestamp;
// 背景
@property (nonatomic,copy)NSString *backgroundImageName;
// 时间停止后回调
@property (nonatomic,copy)TimerStopBlock timerStopBlock;
/**
 *  创建单例对象
 */
+ (instancetype)shareCountDown;// 工程中使用的倒计时是唯一的

/**
 *  创建非单例对象
 */
+ (instancetype)countDown; // 工程中倒计时不是唯一的
@end
