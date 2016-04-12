//
//  MoneyView.h
//  商品详情
//
//  Created by 积分宝 on 15/12/21.
//  Copyright © 2015年 积分宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoneyView : UIView
@property (nullable,nonatomic,strong) UILabel *content;
@property (nullable,nonatomic,strong) NSMutableAttributedString *attributedText;

@property (nullable,nonatomic,strong) NSString *pilck;
@property (nullable,nonatomic,strong) NSString *yanglao;
-(void)pilck:(NSString*)pilcks :(NSString *)usedPilck;
@end
