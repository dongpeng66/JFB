//
//  OrderTwoACell.h
//  订单详情
//
//  Created by 积分宝 on 16/1/11.
//  Copyright © 2016年 积分宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTwoACell : UITableViewCell
@property (nonatomic,strong) UILabel *stateL;
@property (nonatomic,strong) UILabel *timeL;
@property (nonatomic,strong) UIButton *giveUpBtn;
@property (nonatomic,strong) UILabel *authCodeL;
@property (nonatomic,strong) NSMutableAttributedString *attributedText;
-(void)addAuthCodeL:(NSString *)text;
@end
