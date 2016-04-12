//
//  OrderTwoBCell.h
//  订单详情
//
//  Created by 积分宝 on 16/1/8.
//  Copyright © 2016年 积分宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTwoBCell : UITableViewCell
@property (nonatomic,strong) UILabel *stateL;
@property (nonatomic,strong) UILabel *scheduleL;
@property (nonatomic,strong) UILabel *handleL;
@property (nonatomic,strong) UILabel *auditL;
@property (nonatomic,strong) UILabel *accomplishL;
-(void)accompLishLong:(NSString *)text;
@end
