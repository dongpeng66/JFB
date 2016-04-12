//
//  OrederEntityViewController.h
//  JFB
//
//  Created by 积分宝 on 16/1/8.
//  Copyright © 2016年 李俊阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrederEntityViewController : UIViewController
@property (strong, nonatomic) UITableView *myTableView;
@property (strong, nonatomic) NSString *order_no;//订单id
@property (strong, nonatomic) NSString *statle;//状态
@property (strong, nonatomic) NSString *comment;//是否已评论
@end
