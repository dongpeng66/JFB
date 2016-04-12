//
//  ChangePWDViewController.h
//  JFB
//
//  Created by JY on 15/8/21.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePWDViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTF;
@property (weak, nonatomic) IBOutlet UITextField *onenewPwdTF;
@property (weak, nonatomic) IBOutlet UITextField *renewPwdTF;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end
