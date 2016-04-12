//
//  OrderDetailHeaderCell.h
//  JFB
//
//  Created by JY on 15/9/4.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsIM;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameL;
@property (weak, nonatomic) IBOutlet UILabel *goodsIntroduceL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;

@end
