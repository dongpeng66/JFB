//
//  ReceiveAddressViewController.h
//  JFB
//
//  Created by LYD on 15/8/21.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol ADDRESSDELEGATE <NSObject>
-(void)returnAddress:(NSMutableArray *)addressArr;
@end
@interface ReceiveAddressViewController : UIViewController

@property (nonatomic,strong) NSString *panduan;
@property (nonatomic,strong) id<ADDRESSDELEGATE>address;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong)NSString *nimabi;

@end
