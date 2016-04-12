//
//  GoodsDetailViewController.h
//  JFB
//
//  Created by JY on 15/9/4.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsDetailViewController : UIViewController

//@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) NSString *goods_id;
@property (strong, nonatomic) NSString *prilcText;
@property (strong, nonatomic) NSString *usedprilcText;
@property (strong, nonatomic) NSString *saleText;
@property (strong,nonatomic) NSString *className;
@property (strong,nonatomic) NSDictionary *parm;
@property (strong,nonatomic) NSString *yanglao;

@property (strong,nonatomic)NSString *menberId;
@property (strong,nonatomic) NSString *cao;
@property (strong,nonatomic) NSString *isHome;
@property (assign,nonatomic) int  frameBool;
@end
