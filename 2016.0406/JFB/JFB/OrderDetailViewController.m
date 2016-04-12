//
//  OrderDetailViewController.m
//  JFB
//
//  Created by JY on 15/9/4.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailHeaderCell.h"
#import "OrderDetailInfoCell.h"
#import "ShopDetailGoodsCel.h"
#import "GoodsDetailShopInfoCell.h"
#import "DetailBottomNextCell.h"
#import "GoodsDetailWebVC.h"
#import "PayOrderViewController.h"
#import "SubmitOrderViewController.h"
#import "ShopMapNavigationViewController.h"
#import "OrderCouponCell.h"
#import "OrderRefundViewController.h"
#import "QRcodeViewController.h"
#import "ReplyViewController.h"
#import "GoodsDetailViewController.h"

#define InfoCell    @"orderDetailInfoCell"
#define HeaderCell      @"oderDetailHeaderCell"
#define GoodsCell    @"shopDetailGoodsCell"
#define ShopInfoCell      @"goodsDetailShopInfoCell"
#define BottomNextCell      @"detailBottomNextCell"
#define OrderCouCell      @"orderCouponCell"


#import "OrderOneCell.h"
#import "OrderTwoCell.h"
#import "OrderThreeCell.h"
#import "OrderForeCell.h"
#import "OrderTwoACell.h"
#import "OrderTwoBCell.h"
#import "OrderTwoCCell.h"
#define WITH  [[UIScreen mainScreen] bounds].size.width
#define HEIGHT  [[UIScreen mainScreen] bounds].size.height
@interface OrderDetailViewController ()
{
    MBProgressHUD *_hud;
    MBProgressHUD *_networkConditionHUD;
    NSDictionary *_goodsdataDic;
    NSDictionary *_orderdataDic;
    NSDictionary *_coupondataDic;
    UILabel *effective_dateL;   //代金券有效期
    UIButton *dobtn;    //代金券操作按钮
    
    NSString *price;
    NSString *usedPrice;
}
@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"代金卷详情";
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.myTableView.frame=CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height);
    [self.myTableView registerNib:[UINib nibWithNibName:@"ShopDetailGoodsCel" bundle:nil] forCellReuseIdentifier:GoodsCell];
    [self.myTableView registerNib:[UINib nibWithNibName:@"GoodsDetailShopInfoCell" bundle:nil] forCellReuseIdentifier:ShopInfoCell];
    [self.myTableView registerNib:[UINib nibWithNibName:@"OrderDetailHeaderCell" bundle:nil] forCellReuseIdentifier:HeaderCell];
    [self.myTableView registerNib:[UINib nibWithNibName:@"OrderDetailInfoCell" bundle:nil] forCellReuseIdentifier:InfoCell];
    [self.myTableView registerNib:[UINib nibWithNibName:@"DetailBottomNextCell" bundle:nil] forCellReuseIdentifier:BottomNextCell];
    [self.myTableView registerNib:[UINib nibWithNibName:@"OrderCouponCell" bundle:nil] forCellReuseIdentifier:OrderCouCell];
      NSLog(@"--------%@",_statusStr);
   
    self.view.backgroundColor = [UIColor whiteColor];
}
//-(void)viewWillAppear:(BOOL)animated{
//    self.myTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+300);
//}
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
    
    [self requestGetOrderDetail];   //放在这里方便订单状态改变时，刷新界面
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self requestGetOrderDetail];   //放在这里方便订单状态改变时，刷新界面
    [_myTableView reloadData];
}
//-(void)toMapView {
//    ShopMapNavigationViewController *mapVC = [[ShopMapNavigationViewController alloc] init];
//    //    mapVC.latitudeStr = self.merchantdataDic [@"latitude"];
//    //    mapVC.longitudeStr = self.merchantdataDic [@"longitude"];
//    mapVC.shopDic = self.merchantdataDic;
//    [self.navigationController pushViewController:mapVC animated:YES];
//}


-(void)toTelPhone {
    NSString *phoneString = _goodsdataDic [@"mobile_number"];
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneString];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

//设置Separator顶头
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([self.myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
    [self.myTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - UITableViewDataSource



//设置Separator顶头
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark - UITableViewDelegate


#pragma mark - button Actions

-(void)payAction {
    //付款
//    PayOrderViewController *payVC = [[PayOrderViewController alloc] init];
//    [self.navigationController pushViewController:payVC animated:YES];
    SubmitOrderViewController *submitVC = [[SubmitOrderViewController alloc] init];
    submitVC.merchant_id = _goodsdataDic [@"merchant_id"];
    submitVC.goodsdataDic = _goodsdataDic;
    submitVC.order_no = self.order_no;
    submitVC.fraction = self.fraction;
    submitVC.number = [NSString stringWithFormat:@"%@",_orderdataDic [@"qty"]];
    submitVC.shibie = @"cao";
    [self.navigationController pushViewController:submitVC animated:YES];
}
-(void)hahah{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)goRefund:(UIButton *)sender {
//    int row = (int)sender.tag - 2000;
//    NSDictionary *dic = _coupondataDic [@"data"] [row];
//    NSString *coupon_no = [NSString stringWithFormat:@"%@",dic[@"coupon_no"]];
    OrderRefundViewController *refundVC = [[OrderRefundViewController alloc] init];
//    refundVC.coupon_no = coupon_no;
    refundVC.order_no = self.order_no;
    refundVC.refund_amount = _orderdataDic [@"real_amount"];
    refundVC.goodsDic = _goodsdataDic;
    NSMutableArray *couMutableAry = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in _coupondataDic [@"data"]) {
        int staInt = [dic [@"status"] intValue];
        if (staInt == 1) {  //未使用，只有未使用的券才能退款
            [couMutableAry addObject:dic];
        }
    }
    refundVC.couponArray = couMutableAry;   //传给退款页面的券码数组都是“未使用”状态的券码
    [self.navigationController pushViewController:refundVC animated:YES];
}

-(void)qrCodeVC:(UIButton *)sender {
    int row = (int)sender.tag - 3000;
    NSDictionary *dic = _coupondataDic [@"data"] [row];
    
    QRcodeViewController *qrVC = [[QRcodeViewController alloc] init];
    NSString *phone = [NSString stringWithFormat:@"jfb-voucher:%@",dic[@"consume_code"]];
    qrVC.qrString = phone;
    qrVC.titleStr = @"代金券";
    [self.navigationController pushViewController:qrVC animated:YES];
}

-(void)evaluateAction {
    //评价
    ReplyViewController *replyViewVC = [[ReplyViewController alloc]init];
    replyViewVC.merchant_id = _goodsdataDic [@"merchant_id"];
    replyViewVC.goods_id = _goodsdataDic [@"goods_id"];
    replyViewVC.order_no = self.order_no;
    [self.navigationController pushViewController:replyViewVC animated:YES];
}



#pragma mark - 发送请求
-(void)requestGetOrderDetail { //获取订单详情
    [_hud show:YES];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:GetOrderDetail object:nil];
    NSDictionary *locationDic = [[GlobalSetting shareGlobalSettingInstance] myLocation];
    NSString *userID = [[GlobalSetting shareGlobalSettingInstance] userID];
    if (userID == nil) {
        userID = @"";
    }
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:GetOrderDetail, @"op", nil];
    NSDictionary *pram = [[NSDictionary alloc] initWithObjectsAndKeys:self.their_type,@"type",self.order_no,@"order_no",userID,@"member_id",[locationDic objectForKey:@"latitude"],@"latitude",[locationDic objectForKey:@"longitude"],@"longitude", nil];
    NSLog(@"pram: %@",pram);
   // [[DataRequest sharedDataRequest] postDataWithUrl:RequestURL(GetOrderDetail) delegate:nil params:pram info:infoDic];
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
        _networkConditionHUD.mode = MBProgressHUDModeText;
        _networkConditionHUD.yOffset = APP_HEIGHT/2 - HUDBottomH;
        _networkConditionHUD.margin = HUDMargin;
        [_networkConditionHUD show:YES];
        [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        return;
    }
    NSDictionary *responseObject = [[NSDictionary alloc] initWithDictionary:[notification.userInfo objectForKey:@"RespData"]];
    
    if ([notification.name isEqualToString:GetOrderDetail]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:GetOrderDetail object:nil];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取商品详情" message:[responseObject objectForKey:MSG] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
//        [alert show];
        NSLog(@"GetMerchantList_responseObject: %@",responseObject);
        
        if ([responseObject[@"status"] boolValue]) {
//            _networkConditionHUD.labelText = [responseObject objectForKey:MSG];
//            [_networkConditionHUD show:YES];
//            [_networkConditionHUD hide:YES afterDelay:HUDDelay];
            
            NSDictionary *dic = responseObject [DATA];
            _goodsdataDic = dic [@"goodsdata"];
            price = _goodsdataDic[@"sales_price"];
            usedPrice =_goodsdataDic[@"sales_price"];
            _orderdataDic = dic [@"orderdata"];
            _coupondataDic = dic [@"coupondata"];
            
            _statusStr = _orderdataDic [@"status"];
            _is_appraisal = _orderdataDic [@"is_appraisal"];
            
            [self.myTableView reloadData];
            
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:MSG] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } 
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
#pragma mark - 返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
#pragma mark - 返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
#pragma mark - 返回cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return HEIGHT*.15;
    }else if (indexPath.section == 1){
        NSDictionary *dicnima = _coupondataDic [@"data"] [indexPath.row];
        int status = [dicnima [@"status"] intValue];
        if ([_statusStr intValue]==2) {
           return HEIGHT*.525; //未消费
        }else if (status==3){
            return HEIGHT*.251;//退款
        }else if (status==2){
            return HEIGHT*.197;//已消费
        }
        return HEIGHT*.22; //未付款
        
        
    }else if (indexPath.section==2){
        return HEIGHT*.12;
    }
    return HEIGHT*.3;
}
#pragma mark - 设置tableViewCell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dicnima = _coupondataDic [@"data"] [indexPath.row];
    int status = [dicnima [@"status"] intValue];

    if (indexPath.section ==0) {

        static  NSString *ss=@"OrdOneCell";
        OrderOneCell *cell = [tableView dequeueReusableCellWithIdentifier:ss];
        if (!cell) {
            cell= [[OrderOneCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ss];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        [cell.leftIM sd_setImageWithURL:[NSURL URLWithString:_goodsdataDic [@"cover_Image"]] placeholderImage:IMG(@"bg_merchant_photo_placeholder")];
        cell.nameL.text = _goodsdataDic [@"goods_name"];
        
        [cell.moneyView pilck:price :usedPrice];

        return cell;
        
        
        
        
 //---------------------------------------------------------------
    }  else if (indexPath.section ==1) {
        
        
        if ([_statusStr intValue]==2) {
            static  NSString *ss=@"OrdTwoACell";
            OrderTwoACell *cell = [tableView dequeueReusableCellWithIdentifier:ss];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!cell) {
                cell= [[OrderTwoACell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ss];
            }
            
            for (UIView *view in cell.contentView.subviews) {
                [view removeFromSuperview];
            }

            NSDictionary *dic = _coupondataDic [@"data"] [indexPath.row];
            [cell addAuthCodeL:dic[@"consume_code"]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
           cell.timeL.text =  [NSString stringWithFormat:@"有效期至：%@",_coupondataDic[@"effective_date"]];
            [cell.giveUpBtn addTarget:self action:@selector(goRefund:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }else if (status == 3||status == 4){
            static  NSString *ss=@"OrdTwoACell";
            OrderTwoBCell *cell = [tableView dequeueReusableCellWithIdentifier:ss];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!cell) {
                cell= [[OrderTwoBCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ss];
                [cell accompLishLong:@"1"];
                if(status==4){
                    [cell accompLishLong:@"2"];
                    cell.stateL.text = @"已退款";
                }
            }
            return cell;
        }
        else if (status==2){
            static  NSString *ss=@"OrdTwoCCell";
            OrderTwoCCell *cell = [tableView dequeueReusableCellWithIdentifier:ss];
            
            if (!cell) {
                cell= [[OrderTwoCCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ss];
            }
            if(![_is_appraisal  isEqual:@"0"]){
                cell.stateL.text = @"交易成功";
            cell.tishiL.text = @"交易完成你可以查看其他商品哦";
            }
                [cell.shenQingBtn addTarget:self action:@selector(goRefund:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
            
        }
        static  NSString *ss=@"OrdTwoCell";
        OrderTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:ss];
        if (!cell) {
            cell= [[OrderTwoCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ss];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.payBtn addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
         [cell.giveUpBtn addTarget:self action:@selector(removeOrder) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
  //-------------------------------------------------------------------
    }else if (indexPath.section ==2) {
        
        static  NSString *ss=@"OrdThreeCell";
        OrderThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:ss];
        if (!cell) {
            cell= [[OrderThreeCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ss];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.shopNameL.text = _goodsdataDic [@"merchant_name"];
        cell.bigSiteL.text = _goodsdataDic [@"address"];

        [cell.phoneBtn addTarget:self action:@selector(toTelPhone) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }else if (indexPath.section ==3) {
        
        
        static  NSString *ss=@"OrdForeCell";
        OrderForeCell *cell = [tableView dequeueReusableCellWithIdentifier:ss];
        if (!cell) {
            cell= [[OrderForeCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ss];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lab1.text = [NSString stringWithFormat:@"订单号码：%@",_orderdataDic [@"order_no"]];
        cell.lab2.text =[NSString stringWithFormat:@"订单时间：%@",_orderdataDic [@"time"]];
        cell.lab3.text = @"支付方式：支付宝";
        cell.lab4.text = [NSString stringWithFormat:@"商品数量：%@",_orderdataDic [@"qty"]];
        cell.lab5.text = [NSString stringWithFormat:@"订单总价：%@元",_orderdataDic [@"order_amount"]];
        cell.lab6.text = @"购买用户：nil";
        cell.lab7.text = [NSString stringWithFormat:@"手机号码：%@",_orderdataDic [@"mobile"]];
        cell.lab8.hidden = YES;
         [cell.copysBtn addTarget:self action:@selector(copyText) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    return nil;
}
#pragma mark - 监听tableViewCell点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dicnima = _coupondataDic [@"data"] [indexPath.row];
    int status = [dicnima [@"status"] intValue];

    //点击cell背景恢复正常状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        GoodsDetailViewController *detailVC = [[GoodsDetailViewController alloc] init];
        detailVC.goods_id = _goodsdataDic [@"goods_id"];
     //   detailVC.merchant_id = _goodsdataDic [@"merchant_id"];
        detailVC.prilcText = price;
        detailVC.usedprilcText = usedPrice;
       // detailVC.fraction =self.fraction;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if (status==2){
        if (indexPath.section==1) {
            [self evaluateAction];
        }
    }
}
#pragma mark - 放弃订单
-(void)removeOrder{
    [self DeleteOrderWithOrderNo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)DeleteOrderWithOrderNo:(NSString *)orderNo { //删除订单
    [_hud show:YES];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:DeleteOrder object:nil];
    
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:DeleteOrder, @"op", nil];

  //  [[DataRequest sharedDataRequest] postDataWithUrl:RequestURL(DeleteOrder) delegate:nil params:_myParme info:infoDic];
}
-(void)copyText{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string =[NSString stringWithFormat:@"%@", _orderdataDic [@"order_no"]];
        if (!_networkConditionHUD) {
            _networkConditionHUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:_networkConditionHUD];
        }
        _networkConditionHUD.labelText = @"复制成功";
        _networkConditionHUD.mode = MBProgressHUDModeText;
        _networkConditionHUD.yOffset = APP_HEIGHT/2 - HUDBottomH-200;
        _networkConditionHUD.margin = HUDMargin;
        [_networkConditionHUD show:YES];
        [_networkConditionHUD hide:YES afterDelay:HUDDelay];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==3) {
        return 6;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 6;
    }
    return 5;
}
@end
