//
//  LoginViewController.h
//  JFB
//
//  Created by JY on 15/8/21.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet CustomTextField *phoneTF;
@property (weak, nonatomic) IBOutlet CustomTextField *passwordTF;

@end
