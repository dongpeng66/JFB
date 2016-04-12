//
//  OrederEntityViewController.m
//  JFB
//
//  Created by 积分宝 on 16/1/8.
//  Copyright © 2016年 李俊阳. All rights reserved.
//

#import "OrederEntityViewController.h"
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
#import "OrderEntityTwoCell.h"
#import "WuLiuViewController.h"
#define WITH  [[UIScreen mainScreen] bounds].size.width
#define HEIGHT  [[UIScreen mainScreen] bounds].size.height
@interface OrederEntityViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    MBProgressHUD *_hud;
    MBProgressHUD *_networkConditionHUD;
   
    UILabel *effective_dateL;   //代金券有效期
    UIButton *dobtn;    //代金券操作按钮
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn;
    
    NSDictionary *orderEntDic;//订单详情字典
    NSArray *orderDetailsArr;//订单信息数组
    NSDictionary *oneOrdEntDic;//订单商品信息
     int status;
    
    
    
}
@end

@implementation OrederEntityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单详情";
     
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    
    
    
    self.extendedLayoutIncludesOpaqueBars=YES;  //解决隐藏导航栏问题
    
  self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, WITH, HEIGHT-HEIGHT*.096-64) style:UITableViewStyleGrouped];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
    
    [self addBaseView];
    self.view.backgroundColor = [UIColor whiteColor];
}
-(void)addBaseView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-HEIGHT*.096, WITH, HEIGHT*.096)];
    view.tag = 12345;
   // view.backgroundColor = [UIColor orangeColor];
    
    [self.view addSubview:view];
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, view.frame.size.width/3, HEIGHT*.096);
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitle:@"联系客服" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(lianXiKeFu:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setTitleColor:[UIColor colorWithRed:93/255. green:175/255. blue:103/255. alpha:1] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [view addSubview:btn];
    
    btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(view.frame.size.width/3,  0, view.frame.size.width/3, HEIGHT*.096);
    btn1.backgroundColor = [UIColor colorWithRed:154/255. green:154/255. blue:154/255. alpha:1];
    
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [view addSubview:btn1];
    
    btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(view.frame.size.width/3*2, 0, view.frame.size.width/3, HEIGHT*.096);
    btn2.backgroundColor = [UIColor colorWithRed:249/255. green:42/255. blue:56/255. alpha:1];
    
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [view addSubview:btn2];

    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WITH, 1)];
    lab.backgroundColor = [UIColor colorWithRed:235/255. green:235/255. blue:241/255. alpha:1];
    [view addSubview:lab];
    
   
   
    
    if ([_statle isEqualToString:@"created"]) {
        status = 1;//未付款
    }else if ([_statle isEqualToString:@"payed"]) {
        status = 2;//待发货
    }else if ([_statle isEqualToString:@"deliveryed"]) {
        status = 3;//待收货
    }else if ([_statle isEqualToString:@"finished"]) {
        status = 4;//收获成功
    }else if ([_statle isEqualToString:@"closed"]) {
        status = 5;//已关闭
    }

     NSLog(@"---%d-------",status);
    if (status == 3) {//待收货
        [btn2 setTitle:@"确认收货" forState:UIControlStateNormal];
        [btn1 setTitle:@"查看物流" forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(looKWuLiu:) forControlEvents:UIControlEventTouchUpInside];
         [btn2 addTarget:self action:@selector(confirmationOfGoodsReceipt:) forControlEvents:UIControlEventTouchUpInside];
    }else if (status == 2) {//待发货
        
        [btn2 setTitle:@"联系卖家" forState:UIControlStateNormal];
        [btn1 setTitle:@"返回订单" forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(contactSeller:) forControlEvents:UIControlEventTouchUpInside];
       [btn1 addTarget:self action:@selector(fanhui) forControlEvents:UIControlEventTouchUpInside];
        
    }else if (status == 1) {//未付款
        [btn2 setTitle:@"去付款" forState:UIControlStateNormal];
        [btn1 setTitle:@"放弃订单" forState:UIControlStateNormal];
         [btn2 addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
         [btn1 addTarget:self action:@selector(removeOrder) forControlEvents:UIControlEventTouchUpInside];

    }else if (status == 4) {//收货成功
        
        
        [btn1 setTitle:@"去评价" forState:UIControlStateNormal];
        if ([_comment intValue]==1) {
            [btn1 setTitle:@"已评价" forState:UIControlStateNormal];
        }
        [btn2 setTitle:@"删除订单" forState:UIControlStateNormal];
        
        
        [btn2 addTarget:self action:@selector(removeOrder) forControlEvents:UIControlEventTouchUpInside];
        [btn1 addTarget:self action:@selector(toReplyViewController:) forControlEvents:UIControlEventTouchUpInside];
    }

    
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
    
    [self requestGetOrderDetail];   //放在这里方便订单状态改变时，刷新界面

    
    
    
    [_myTableView reloadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if (_frameBool == 1) {
//        UIView *view = [self.view viewWithTag:12345];
//        view.frame = CGRectMake(0, HEIGHT-HEIGHT*.096, WITH, HEIGHT*.096);
//        _myTableView.frame = CGRectMake(0,0, WITH, HEIGHT-HEIGHT*.096);
//        
//    }else if(_frameBool == 0){
//        _myTableView.frame = CGRectMake(0,0, WITH, HEIGHT-HEIGHT*.096-64);
//        UIView *view = [self.view viewWithTag:12345];
//        view.frame = CGRectMake(0, HEIGHT-HEIGHT*.096-64, WITH, HEIGHT*.096);
//    }

}


#pragma mark - 商家电话
-(void)toTelPhone {
    NSLog(@"%@",orderEntDic);
    
    NSString *phone = [NSString stringWithFormat:@"%@",orderEntDic[@"merchantTelePhone"]];
    if(phone.length<1){
    if (!_networkConditionHUD) {
        _networkConditionHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_networkConditionHUD];
    }
    _networkConditionHUD.labelText = @"该商家暂无电话";
    _networkConditionHUD.mode = MBProgressHUDModeText;
    _networkConditionHUD.yOffset = APP_HEIGHT/2 - HUDBottomH-200;
    _networkConditionHUD.margin = HUDMargin;
    [_networkConditionHUD show:YES];
    [_networkConditionHUD hide:YES afterDelay:HUDDelay];
    }else{

    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }
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



#pragma mark - button Actions

-(void)payAction {
    //付款
  
    PayOrderViewController *payVC = [[PayOrderViewController alloc] init];
     payVC.orderInfoDic = orderEntDic;
   payVC.goods_name = oneOrdEntDic[@"goodsName"];
    payVC.goods_detail = oneOrdEntDic [@"goodsTitle"];  //商品描述body
     payVC.amount =[NSString stringWithFormat:@"%@",orderEntDic [@"orderAmount"]];;
    payVC.their_type =oneOrdEntDic [@"their_type"];
    payVC.merchant_id = orderEntDic[@"merchantId"];
     payVC.qtyStr = oneOrdEntDic[@"buyNumber"];
    [self.navigationController pushViewController:payVC animated:YES];

}

-(void)goRefund:(UIButton *)sender {
   
//    OrderRefundViewController *refundVC = [[OrderRefundViewController alloc] init];
//    refundVC.order_no = self.order_no;
//    refundVC.refund_amount = _orderdataDic [@"real_amount"];
//    refundVC.goodsDic = _goodsdataDic;
//    NSMutableArray *couMutableAry = [[NSMutableArray alloc] init];
//    for (NSDictionary *dic in _coupondataDic [@"data"]) {
//        int staInt = [dic [@"status"] intValue];
//        if (staInt == 1) {  //未使用，只有未使用的券才能退款
//            [couMutableAry addObject:dic];
//        }
//    }
//    refundVC.couponArray = couMutableAry;   //传给退款页面的券码数组都是“未使用”状态的券码
//    [self.navigationController pushViewController:refundVC animated:YES];
}

-(void)qrCodeVC:(UIButton *)sender {
  //  int row = (int)sender.tag - 3000;
//    NSDictionary *dic = _coupondataDic [@"data"] [row];
//    
//    QRcodeViewController *qrVC = [[QRcodeViewController alloc] init];
//    NSString *phone = [NSString stringWithFormat:@"jfb-voucher:%@",dic[@"consume_code"]];
//    qrVC.qrString = phone;
//    qrVC.titleStr = @"代金券";
//    [self.navigationController pushViewController:qrVC animated:YES];
}

#pragma mark - 评价
//-(void)evaluateAction {
//    //评价
//    ReplyViewController *replyViewVC = [[ReplyViewController alloc]init];
//    replyViewVC.merchant_id = _goodsdataDic [@"merchant_id"];
//    replyViewVC.goods_id = _goodsdataDic [@"goods_id"];
//    replyViewVC.order_no = self.order_no;
//    [self.navigationController pushViewController:replyViewVC animated:YES];
//}



#pragma mark - 发送获取订单详情请求
-(void)requestGetOrderDetail { //获取订单详情
    [_hud show:YES];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:GetOrderDetail object:nil];
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:GetOrderDetail, @"op", nil];
    
    
     NSString *token = [NSString stringWithFormat:@"%@",[[GlobalSetting shareGlobalSettingInstance] pension]];
    NSString *url = [NSString stringWithFormat:@"pri/order/detail.json?token=%@&orderId=%@",token,_order_no];
    NSLog(@"%@------%@",token,_order_no);
    NSLog(@"---%@",NewRequestURL2(url));
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
    
        NSLog(@"GetMerchantList_responseObject: %@",responseObject);
        
        if ([responseObject[@"code"] intValue] == 0) {
         
            orderEntDic = responseObject [DATA];
            orderDetailsArr = orderEntDic[@"orderDetails"];
            oneOrdEntDic = orderDetailsArr[0];//临时
            _comment = [NSString stringWithFormat:@"%@",orderEntDic[@"comment"]];
            
            [self.myTableView reloadData];
            
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:MSG] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }

        
        
        if ([notification.name isEqualToString:@"ShouHuo"]) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ShouHuo" object:nil];
            if ([responseObject[@"code"] intValue] == 0) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:MSG] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                [alert show];
              [self.navigationController popViewControllerAnimated:YES];
                
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:MSG] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                [alert show];
                 [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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

        return HEIGHT*.31; //实物
        
    }else if (indexPath.section==2){
        return HEIGHT*.103;
    }
    return HEIGHT*.33;
}
#pragma mark - 设置tableViewCell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section ==0) {
        
        static  NSString *ss=@"OrdOneCell";
        OrderOneCell *cell = [tableView dequeueReusableCellWithIdentifier:ss];
        if (!cell) {
            cell= [[OrderOneCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ss];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        [cell.leftIM sd_setImageWithURL:[NSURL URLWithString:oneOrdEntDic [@"goodsImages"]] placeholderImage:IMG(@"bg_merchant_photo_placeholder")];
        cell.nameL.text = oneOrdEntDic [@"goodsName"];
        
        
        NSString *price = oneOrdEntDic[@"salesPrice"];
        NSString *usedPrice = oneOrdEntDic[@"marketPrice"];
        [cell.moneyView pilck:price :usedPrice];
        
        
        return cell;
    }  else if (indexPath.section ==1) {
        
#pragma mark - 实物
        static  NSString *ss=@"OrdEntityTwoCell";
        OrderEntityTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:ss];
        if (!cell) {
            cell= [[OrderEntityTwoCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ss];
        }
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        cell.consigneeL.text = orderEntDic[@"toRealname"];//收货人
        
        
        NSString *tomobile = [NSString stringWithFormat:@"%@",orderEntDic[@"toMobile"]];
        if ([tomobile  isEqual: @"(null)"]||tomobile ==nil||[tomobile  isEqual:@"<null>"]) {
            tomobile = @"";
        }
        
        
        cell.phoneNumberL.text = tomobile;//电话号码
        NSString *toName = orderEntDic[@"toAreaName"];
        NSString *toAddress = orderEntDic[@"toAddress"];
        
        if ([toAddress  isEqual: @"(null)"]||toAddress ==nil||[toName  isEqual:@"<null>"]) {
            toAddress = @"";
        }
        if ([toName  isEqual: @"(null)"]||toName ==nil||[toName  isEqual:@"<null>"]) {
            toName = @"";
        }
        
        cell.addressL.text = [NSString stringWithFormat:@"收货地址：%@%@",toName,toAddress] ;//地址
        
        if (status == 3) {
            cell.stateL.text = @"待收货";
            cell.leftStateL.text = @"卖家已发货";
            [cell.payBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            [cell.payBtn addTarget:self action:@selector(looKWuLiu:) forControlEvents:UIControlEventTouchUpInside];
            cell.payBtn.hidden = YES;
            cell.tishiL.hidden = NO;
        }else if (status == 2) {
            cell.stateL.text = @"待发货";
            cell.leftStateL.text = @"卖家暂未发货";
            [cell.payBtn setTitle:@"联系卖家" forState:UIControlStateNormal];
             [cell.payBtn addTarget:self action:@selector(contactSeller:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if (status ==1) {
            cell.stateL.text = @"未付款";
            cell.leftStateL.text = @"您还未付款";
            [cell.payBtn setTitle:@"去付款" forState:UIControlStateNormal];
            [cell.payBtn addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
        }else if (status == 4) {
            cell.stateL.text = @"交易成功";
            cell.leftStateL.text = @"订单已完成";
            cell.payBtn.hidden=NO;
            [cell.payBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            [cell.payBtn addTarget:self action:@selector(looKWuLiu:) forControlEvents:UIControlEventTouchUpInside];
            
        }

        NSLog(@"%d",status);
        return cell;
        
    }else if (indexPath.section ==2) {
        
        static  NSString *ss=@"OrdThreeCell";
        OrderThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:ss];
        if (!cell) {
            cell= [[OrderThreeCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ss];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.shopNameL.text = orderEntDic [@"merchantName"];
        cell.bigSiteL.text = orderEntDic [@"merchantAddress"];
        
        [cell.phoneBtn addTarget:self action:@selector(toTelPhone) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }else if (indexPath.section ==3) {
        
        
        static  NSString *ss=@"OrdForeCell";
        OrderForeCell *cell = [tableView dequeueReusableCellWithIdentifier:ss];
        if (!cell) {
            cell= [[OrderForeCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ss];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *orderNum = orderEntDic [@"orderNum"];
        orderNum = [self returnRemoveNull:orderNum];
        cell.lab1.text = [NSString stringWithFormat:@"订单号码：%@",orderNum];
        
        NSString *gmtCreate = orderEntDic [@"gmtCreate"];
        gmtCreate = [self returnRemoveNull:gmtCreate];
        cell.lab2.text =[NSString stringWithFormat:@"订单时间：%@", gmtCreate];
        cell.lab3.text = @"支付方式：支付宝";
        
        
        NSString *buyNumber = [NSString stringWithFormat:@"%@",oneOrdEntDic [@"buyNumber"]];
        buyNumber = [self returnRemoveNull:buyNumber];
        cell.lab4.text = [NSString stringWithFormat:@"商品数量：%@",buyNumber];
        
        
        NSString *amount = [NSString stringWithFormat:@"%@元",orderEntDic [@"orderAmount"]];
        amount = [self returnRemoveNull:amount];
        cell.lab5.text = [NSString stringWithFormat:@"订单总价：%@",amount];
        
         NSString *LoginName= [NSString stringWithFormat:@"%@",[[GlobalSetting shareGlobalSettingInstance] mName]];
        
        cell.lab6.text = [NSString stringWithFormat:@"购买用户：%@",LoginName];
        
        NSString *phone = [NSString stringWithFormat:@"%@",orderEntDic[@"toTelephone"]];
        phone = [self returnRemoveNull: phone];
        cell.lab7.text = [NSString stringWithFormat:@"手机号码：%@",phone];
        
        
        
        NSString *name = orderEntDic[@"toAreaName"];
        NSString *addre = orderEntDic[@"toAddress"];
        addre = [self returnRemoveNull:addre];
        name = [self returnRemoveNull:name];
        cell.lab8.text =[NSString stringWithFormat:@"收获地址：%@%@",name,addre] ;
        
        [cell.copysBtn addTarget:self action:@selector(copyText) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    return nil;
}
#pragma mark - 监听tableViewCell点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击cell背景恢复正常状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        GoodsDetailViewController *detailVC = [[GoodsDetailViewController alloc] init];
        detailVC.goods_id = oneOrdEntDic [@"goodsId"];
 //       detailVC.merchant_id = _goodsdataDic [@"merchant_id"];
        detailVC.prilcText = oneOrdEntDic[@"salesPrice"];
        detailVC.usedprilcText = oneOrdEntDic[@"marketPrice"];
        detailVC.isHome = @"1";
        detailVC.frameBool = 1;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
#pragma mark - 放弃订单
-(void)removeOrder{
    
    NSString *text;
    if (status ==4) {
        text = @"您确定删除此订单吗?";
    }else {
        text =@"您确定放弃订单吗？";
    }

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:text delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];\
    alert.tag=777;
    [alert show];
}
#pragma mark - 删除订单请求
-(void)DeleteOrderWithOrderNo:(NSString *)orderNo { //删除订单
    [_hud show:YES];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:DeleteOrder object:nil];
    
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:DeleteOrder, @"op", nil];
  
    NSString *token = [NSString stringWithFormat:@"%@",[[GlobalSetting shareGlobalSettingInstance] pension]];
    
    NSString *url = [NSString stringWithFormat:@"pri/order/delete.htm?token=%@&orderId=%@",token,orderNo];
    ;
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL2(url) delegate:nil params:nil info:infoDic];
}
#pragma mark - 复制
-(void)copyText{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
 
    pasteboard.string =[NSString stringWithFormat:@"%@", orderEntDic [@"orderNum"]];
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
#pragma mark - 查看物流
-(void)looKWuLiu:(UIButton *)btn{
    WuLiuViewController *view = [[WuLiuViewController alloc]init];
    view.express_pycode = orderEntDic[@"expressPyName"];
    view.express_no = orderEntDic[@"expressOrderNum"];
    [self.navigationController pushViewController:view animated:YES];
    NSLog(@"看物流");
}
#pragma mark - 联系客服
-(void)lianXiKeFu:(UIButton *)btn{
    
    NSString *phoneString= @"400-6999-226";
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneString];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
#pragma mark - 联系卖家
-(void)contactSeller:(UIButton *)btn{
        NSString *phoneString = [NSString stringWithFormat:@"%@",orderEntDic[@"merchantTelePhone"]];
    if (phoneString.length<7) {
        phoneString = @"400-6999-226";
    }
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneString];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
    NSLog(@"联系卖家");
}
#pragma mark - 确认收货

-(void)confirmationOfGoodsReceipt:(UIButton *)btn{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确认收货吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag=666;
    [alert show];
    

    NSLog(@"确认收货");
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag==666) {
    if (buttonIndex == 1) {
        [self requestGetConfirmReceiptOid:orderEntDic[@"id"]];
         [self.navigationController popViewControllerAnimated:YES];
    }
    }else if (alertView.tag==777){
         if (buttonIndex == 1) {
        NSString *orderId = orderEntDic[@"id"];
        [self DeleteOrderWithOrderNo:orderId];
             [self.navigationController popViewControllerAnimated:YES];
         }
    }
}
#pragma mark - 确认收货请求
-(void)requestGetConfirmReceiptOid:(NSString *)orderId{
    [_hud show:YES];
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:@"ShouHuo" object:nil];
    
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"ShouHuo", @"op", nil];
    NSString *token = [NSString stringWithFormat:@"%@",[[GlobalSetting shareGlobalSettingInstance] pension]];
    NSString *url = [NSString stringWithFormat:@"pri/order/confirm_receipt.htm?token=%@&orderId=%@",token,orderId];
    
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL2(url) delegate:nil params:nil info:infoDic];
    
}
-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 评价
-(void)toReplyViewController:(UIButton *)btn{
  
    NSLog(@"-%@-",orderEntDic);

    
   
    int comment = [orderEntDic[@"comment"] intValue];
    if(comment==0){
    ReplyViewController *replyViewVC = [[ReplyViewController alloc]init];

    replyViewVC.goods_id = oneOrdEntDic[@"goodsId"];
    replyViewVC.order_no =  orderEntDic[@"orderNum"];
    [self.navigationController pushViewController:replyViewVC animated:YES];
    }else{
        _networkConditionHUD.labelText = @"已经评价过啦！";
        _networkConditionHUD.mode = MBProgressHUDModeText;
        _networkConditionHUD.yOffset = APP_HEIGHT/2 - HUDBottomH-200;
        _networkConditionHUD.margin = HUDMargin;
        [_networkConditionHUD show:YES];
        [_networkConditionHUD hide:YES afterDelay:HUDDelay];

    }
}


#pragma mark - 去除null
-(NSString *)returnRemoveNull:(NSString *)string{
    
    if (string==nil ||[string isEqual:@"(null)"]||[string isEqual:@"<null>"]||string.length<=0) {
        string = @"";
    }
    
    return string;
}
@end
