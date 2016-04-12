//
//  SpecialtyTwoCell.h
//  特产首页
//
//  Created by 积分宝 on 15/12/22.
//  Copyright © 2015年 积分宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialtyTwoCell : UITableViewCell
@property (nonatomic,strong) UIImageView *leftIM;
@property (nonatomic,strong) UILabel *rightL;
@property (nonatomic,strong) UILabel *goodsNameL;
@property (nonatomic,strong) UILabel *countL;
@property (nonatomic,strong) UILabel *priceL;
@property (nonatomic,strong) UILabel *usedPriceL;
@property (nonatomic,strong) UILabel *salesL;
@property (nonatomic,strong) UILabel *lab;
-(void)setHeight:(float)height;
-(void)setrightText:(NSString *)text :(float)height;
@end
