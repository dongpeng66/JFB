//
//  AddressViewController.h
//  JFB
//
//  Created by 积分宝 on 16/1/15.
//  Copyright © 2016年 李俊阳. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol adderDataDelegata <NSObject>
-(void) returnSumitAddress:(NSDictionary *)dic;
@end

@protocol FANHUI <NSObject>
-(void)fanhuiAddress:(NSMutableArray *)arr;
@end
@interface AddressViewController : UIViewController

@property (nonatomic,strong) NSMutableArray *addressData;
@property (nonatomic,strong) id<adderDataDelegata>mydelegate;
@property (nonatomic,strong) id<FANHUI>fanhuiDelegate;
@end
