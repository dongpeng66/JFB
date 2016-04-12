//
//  MyOrderTableViewCell.h
//  JFB
//
//  Created by JY on 15/8/24.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *orderIM;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *numberL;
@property (weak, nonatomic) IBOutlet UILabel *statusL;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;


@end
