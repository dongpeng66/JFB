//
//  goodsDetailDescriptionEvaluateCell.h
//  JFB
//
//  Created by IOS on 16/3/16.
//  Copyright © 2016年 李俊阳. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DJQRateView;
@interface goodsDetailDescriptionEvaluateCell : UITableViewCell
//商品评价字
@property (nonatomic,strong) UILabel *ealuateLabel;
//商品评价人数
@property (nonatomic,strong) UILabel *ealuateNumLabel;
//星级条
@property (nonatomic,strong) DJQRateView *rateView;
//评的分数
@property (nonatomic,strong) UILabel *scoreLabel;
//箭头
@property (nonatomic,strong) UIImageView *myImageView;
@end
