//
//  OrderEntityTwoCell.h
//  订单详情
//
//  Created by 积分宝 on 16/1/7.
//  Copyright © 2016年 积分宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderEntityTwoCell : UITableViewCell
@property (nonatomic,strong) UILabel *stateL;
@property (nonatomic,strong) UILabel *leftStateL;
@property (nonatomic,strong) UILabel *consigneeL;//收货人
@property (nonatomic,strong) UILabel *phoneNumberL;//电话号码
@property (nonatomic,strong) UILabel *addressL;//地址
@property (nonatomic,strong) UIButton *payBtn;
@property (nonatomic,strong) UILabel *tishiL;

@end
