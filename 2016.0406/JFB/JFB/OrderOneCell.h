//
//  OrderOneCell.h
//  订单详情
//
//  Created by 积分宝 on 16/1/7.
//  Copyright © 2016年 积分宝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoneyView.h"
@interface OrderOneCell : UITableViewCell
@property (nonatomic,strong) UIImageView *leftIM;
@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong)MoneyView *moneyView;
@end
