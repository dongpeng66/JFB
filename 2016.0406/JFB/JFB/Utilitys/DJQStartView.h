//
//  HomeViewController.h
//  JFB
//
//  Created by JY on 15/8/18.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJQStartView : UIView

@property(nonatomic) CGFloat radius;
@property(nonatomic) CGFloat value;// 范围 0到1
@property(nonatomic,strong) UIColor *startColor;
@property(nonatomic,strong) UIColor *boundsColor;
@end
