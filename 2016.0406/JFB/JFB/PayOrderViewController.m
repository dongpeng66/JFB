//
//  PayOrderViewController.m
//  JFB
//
//  Created by JY on 15/9/4.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import "PayOrderViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "Order.h"
#import "PayFinishViewController.h"

@interface PayOrderViewController ()
{
    MBProgressHUD *_hud;
    MBProgressHUD *_networkConditionHUD;
    NSString *payment_id;   //1：现金，2：支付宝，3：微信，4：银联
}

@end

@implementation PayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
      self.extendedLayoutIncludesOpaqueBars=YES;
    self.title = @"订单支付";
    
    payment_id = @"2";  //默认支付宝支付
    
    self.orderNumberL.text = [NSString stringWithFormat:@"%@",self.orderInfoDic [@"orderNum"]];
    self.goodsNameL.text = self.goods_name;
    self.allPriceL.text = self.amount;
    
    
    
    NSLog(@"%@",_orderInfoDic);
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (! _hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_hud];
    }
    
    if (!_networkConditionHUD) {
        _networkConditionHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_networkConditionHUD];
    }
    _networkConditionHUD.mode = MBProgressHUDModeText;
    _networkConditionHUD.yOffset = APP_HEIGHT/2 - HUDBottomH;
    _networkConditionHUD.margin = HUDMargin;
}

- (IBAction)alipayAction:(id)sender {
    if (! self.alipayBtn.selected) {
        self.alipayBtn.selected = YES;
        self.weixinpayBtn.selected = NO;
        payment_id = @"2";
    }
}

- (IBAction)weixinpayAction:(id)sender {
    _networkConditionHUD.labelText = @"微信支付暂未开放！";
    [_networkConditionHUD show:YES];
    [_networkConditionHUD hide:YES afterDelay:HUDDelay];
    
    
//    if (! self.weixinpayBtn.selected) {
//        self.alipayBtn.selected = NO;
//        self.weixinpayBtn.selected = YES;
//        payment_id = @"3";
//    }
}

- (IBAction)payAction:(id)sender {
    [self requestPayOrder];

}


#pragma mark - 支付宝钱包快捷支付相关
-(void)zhifubao_pay {
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088711189454077";
    NSString *seller = @"2088711189454077";
    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBANHqi58UMnhUQUmzvi2lNnPCXc80KQzsnFgmruLXBMV/x8vDEh7uJddWlLonIEruCA4tUcKHPng8nugp65vRvWfU1k6zqVplvyp2XfAsLkFYMykXmjXJ0ti70emH1KHnJ2MZ7nxrfQHjOCsuK9fHq9QIFGU0DRCTEqhmjBHpa1qjAgMBAAECgYBal0kYJwQ878eZQgvR8RnVzUzkzhLlM/upA1C4Lqktfp6/7fiVBpuoGgJnb9k83Qr261H8jJdGFotRkD3Q6iw9qdGhS9a/afyx2SwJqizte3H5Ev7eB6SUGxGnoT6WPVO2nl0+IBnsbA/Th4cvCWrl5mDMkamy4TudlWa9KaYQCQJBAPJExDB6luVR9RohvlZva6/DIaOgPrlL+16e72FUwQHppIHTY/8d3rVkreQLtEQN2e5tKRKQZkJFExCIDnzzOMUCQQDd0FtHMuXaobCWPxVicZWP0qOd3eDiUraEzRIJsjMjFKI3p9lQZLVU6F/n1Ila0GiIlKAwhyajChNJJEbDLexHAkEArI6MSpdWWPnaIQW9w2TTB7ptgFUHuAVFgmyjxeiPHGSk9o9xXumQkhSmwpIPkJVpDyiTI5TUMQlv/ctavmainQJBAKnvc87TVreuQlyJTffSr1O1e7Z5g03BMqYBej1FcdoBd9oN1Pa7gRTgxoEVGnohysRAoY0sLdSg5m+VxETKDQcCQBILEiZ+i89hPyQY8mOLy9acVKhz5xW0qfuW5V/hIco0OUmWafF+yFiVNzkJ1BM5Dibgmc6a4zgRSW16Anipxhg=";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [NSString stringWithFormat:@"%@",self.orderInfoDic [@"orderNum"]]; //订单ID（由商家自行制定）
    order.productName = self.goods_name; //商品标题
    order.productDescription = self.goods_detail; //商品描述
    order.amount = self.amount; //商品价格
//    order.amount = @"0.01"; //1分钱测试
    order.notifyURL =  @"http://shop.jfb315.cn/alipay/notify.htm"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"AliPay2088711189454077";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            
//            NSString *strMsg = [NSString stringWithFormat:@"memo:%@", resultDic [@"memo"]];
//            NSString *strTitle = [NSString stringWithFormat:@"result:%@", resultDic [@"result"]];;
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
            
            //发送支付宝支付完成通知
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"success",@"RespResult", resultDic, @"RespData",nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:AliPayNotification object:nil userInfo:userInfo];
            
        }];
    }
    
}


#pragma mark - 支付完成后回调通知
-(void) completePayNotification:(NSNotification *)notification{
    if ([notification.name isEqualToString:AliPayNotification]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AliPayNotification object:nil];
        
        NSDictionary *resultDic = [notification.userInfo objectForKey:@"RespData"];
        int resultStatus = [resultDic [@"resultStatus"] intValue];
        if (resultStatus == 6001) {
            _networkConditionHUD.labelText = @"用户中途取消";
            [_networkConditionHUD show:YES];
            [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        }
        else if (resultStatus == 9000) {
            _networkConditionHUD.labelText = @"订单支付成功";
            [_networkConditionHUD show:YES];
            [_networkConditionHUD hide:YES afterDelay:HUDDelay];
            
            //[self requestPayOrder];
            [self zhiFuJieGuo];
        }
        else if (resultStatus == 8000) {
            _networkConditionHUD.labelText = @"订单正在处理中，请稍后查看订单状态";
            [_networkConditionHUD show:YES];
            [_networkConditionHUD hide:YES afterDelay:HUDDelay];
            [self zhiFuJieGuo];

            //[self requestPayOrder];
        }
        else if (resultStatus == 4000) {
            _networkConditionHUD.labelText = @"订单支付失败";
            [_networkConditionHUD show:YES];
            [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        }
        else if (resultStatus == 6002) {
            _networkConditionHUD.labelText = @"网络连接出错";
            [_networkConditionHUD show:YES];
            [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        }
    }
//    if ([notification.name isEqualToString:WxPayNotification]) {
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:WxPayNotification object:nil];
//        
//        PayResp *resp = [notification.userInfo objectForKey:@"RespData"];
//        
//        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
//        NSString *strTitle;
//        //支付返回结果，实际支付结果需要去微信服务器端查询
//        strTitle = [NSString stringWithFormat:@"支付结果"];
//        
//        switch (resp.errCode) {
//            case WXSuccess:
//                strMsg = @"支付结果：成功！";
//                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
//                
//                [self performSelectorOnMainThread:@selector(wxpayBack:) withObject:@"支付成功" waitUntilDone:NO];
//                
//                break;
//                
//            default:
//                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
//                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
//                
//                [self performSelectorOnMainThread:@selector(wxpayBack:) withObject:@"支付失败！" waitUntilDone:NO];
//                
//                break;
//        }
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }
    
}
#pragma mark - 支付结果
-(void)zhiFuJieGuo{
    
    PayFinishViewController *finishVC = [[PayFinishViewController alloc] init];
    finishVC.finishDic = self.orderInfoDic;
    finishVC.goodsShopName = self.goods_name;
    [self.navigationController pushViewController:finishVC animated:YES];
}
#pragma mark - 发送请求
-(void)requestPayOrder { //支付订单
    [_hud show:YES];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:@"yanzheng" object:nil];
   
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"yanzheng", @"op", nil];
    
    NSString *token = [NSString stringWithFormat:@"%@",[[GlobalSetting shareGlobalSettingInstance] pension]];
    NSString *url = [NSString stringWithFormat:@"pri/order/check_pay.htm?token=%@&orderId=%@",token,_orderInfoDic[@"id"]];
    NSLog(@"%@",NewRequestURL2(url));
    
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL2(url) delegate:nil params:nil info:infoDic];
}

#pragma mark - 网络请求结果数据
-(void) didFinishedRequestData:(NSNotification *)notification{
    [_hud hide:YES];
    if ([[notification.userInfo valueForKey:@"RespResult"] isEqualToString:ERROR]) {
        if (!_networkConditionHUD) {
            _networkConditionHUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:_networkConditionHUD];
        }
        _networkConditionHUD.labelText = [notification.userInfo valueForKey:@"ContentResult"];
        [_networkConditionHUD show:YES];
        [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        return;
    }
    NSDictionary *responseObject = [[NSDictionary alloc] initWithDictionary:[notification.userInfo objectForKey:@"RespData"]];
    
    if ([notification.name isEqualToString:@"yanzheng"]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"yanzheng" object:nil];
        
        NSLog(@"GetMerchantList_responseObject: %@",responseObject);
        
        if ([responseObject[@"code"] intValue] == 0) {
            _networkConditionHUD.labelText = [responseObject objectForKey:MSG];
            [_networkConditionHUD show:YES];
            [_networkConditionHUD hide:YES afterDelay:HUDDelay];
            
            if (self.alipayBtn.selected) {  //调起支付宝支付
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completePayNotification:) name:AliPayNotification object:nil];
                [self zhifubao_pay];
            }
            else {
                
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:MSG] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
}
- (IBAction)fanhui:(id)sender {
    
    PayFinishViewController *finishVC = [[PayFinishViewController alloc] init];
    //finishVC.finishDic = responseObject [DATA];
    [self.navigationController pushViewController:finishVC animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
