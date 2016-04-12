//
//  goodsDetailDescriptionSatateCell.h
//  JFB
//
//  Created by IOS on 16/3/16.
//  Copyright © 2016年 李俊阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface goodsDetailDescriptionSatateCell : UITableViewCell
//当前的价格
@property (nonatomic,strong) UILabel *currentPriceLabel;
//实际价格
@property (nonatomic,strong) UILabel *realPriceLabel;
//养老金
@property (nonatomic,strong) UILabel *oldAgePensionLabel;
//快递费用
@property (nonatomic,strong) UILabel *expressLabel;
//已收的数量
@property (nonatomic,strong) UILabel *soldNumLabel;
//地区
@property (nonatomic,strong) UILabel *areaNameLabel;
@end
