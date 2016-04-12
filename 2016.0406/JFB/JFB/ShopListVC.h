//
//  ShopListVC.h
//  JFB
//
//  Created by LYD on 15/9/22.
//  Copyright © 2015年 JY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopListVC : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UIButton *countyBtn;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;
@property (weak, nonatomic) IBOutlet UILabel *locationL;
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UIView *selectBgView;
@property (weak, nonatomic) IBOutlet UITableView *selectTableView;

@property (strong, nonatomic) NSString *menu_subtitle;
@property (strong, nonatomic) NSString *menu_code;
@property (strong, nonatomic) NSString *typeID;

@property (strong,nonatomic) NSDictionary *caoNiMaDic ;

@end
