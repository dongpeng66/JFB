//
//  VoucherEitiysCell.h
//  JFB
//
//  Created by 积分宝 on 16/1/28.
//  Copyright © 2016年 李俊阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoucherEitiysCell : UITableViewCell
@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UILabel *tradingParL;
@property (nonatomic,strong) UIImageView *bigIM;
@property (nonatomic,strong) UILabel *goodsNameL;
@property (nonatomic,strong) UILabel *numberL;
@property (nonatomic,strong) UILabel *priceL;
@property (nonatomic,strong) UILabel *yanglaoL;
@property (nonatomic,strong) UIButton *payBtn;
@property (nonatomic,strong) UILabel *beiJingL;
@property (nonatomic,strong) UIButton *logisticsBtn;

-(void)setHeight:(float)height;
@end
