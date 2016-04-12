//
//  XIBView.h
//  xib
//
//  Created by 积分宝 on 15/12/2.
//  Copyright © 2015年 积分宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XIBView : UIView
@property (nullable,nonatomic,strong) UIImageView *personalImageView;//背景图
@property (nullable,nonatomic,strong) UIImageView *headImageView;//头像
@property (nullable,nonatomic,strong) UIImageView *indicateImageView;//指示箭头
@property (nullable,nonatomic,strong) UIImageView *privilegeImageView;//优惠卷图
@property (nullable,nonatomic,strong) UIImageView *annuityImageView;//养老金图
@property (nullable,nonatomic,strong) UIButton *twoDimensionBtn;//二维码
@property (nullable,nonatomic,strong) UIButton *leftBtn;//左边优惠卷按钮
@property (nullable,nonatomic,strong) UIButton *rightBtn;//右边养老金按钮
@property (nullable,nonatomic,strong) UILabel *nameL;//姓名
@property (nullable,nonatomic,strong) UILabel *numberL;//卡号
@property (nullable,nonatomic,strong) UILabel *privilegeL;//优惠卷TEXT
@property (nullable,nonatomic,strong) UILabel *annuityL;//养老金TEXT
@property (nullable,nonatomic,strong) UILabel *numberL1;//张数
@property (nullable,nonatomic,strong) UILabel *numberL2;//元数
@property (nullable,nonatomic,strong) UILabel *verticalL;//竖线
@property (nullable,nonatomic,strong) NSMutableAttributedString *attributedText;
@property (nullable,nonatomic,strong) NSMutableAttributedString *attributedText2;

@property (nonatomic,assign) float yuan;
@property (nonatomic,assign) int zhang;
@end
