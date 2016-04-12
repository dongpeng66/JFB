//
//  OrderDetailViewController.h
//  JFB
//
//  Created by JY on 15/9/4.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) NSString *order_no;
@property (strong, nonatomic) NSString *their_type;

@property (strong, nonatomic) NSString *statusStr;
@property (strong, nonatomic) NSString *is_appraisal;

@property (strong, nonatomic) NSString * fraction;

@property (strong, nonatomic)NSDictionary *myParme;
@end
