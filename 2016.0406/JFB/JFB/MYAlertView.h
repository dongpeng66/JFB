//
//  MYAlertView.h
//  自定义弹窗
//
//  Created by 积分宝 on 16/3/23.
//  Copyright © 2016年 积分宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYAlertView : UIView
-(void)show:(NSString *)string;
-(void)hide;
-(void)yesAndNo:(NSString *)string;
@end
