//
//  SubmitOrderViewController.m
//  JFB
//
//  Created by JY on 15/9/4.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import "SubmitOrderViewController.h"
#import "PayOrderViewController.h"
#import "RedPacket.h"
#import "AddressViewController.h"
#import "ReceiveAddressViewController.h"
#import "SumOneCell.h"
#import "remarkView.h"
#define w [UIScreen mainScreen].bounds.size.width
#define h [UIScreen mainScreen].bounds.size.height

//代理传值4
@interface UIViewController ()
@end
@interface SubmitOrderViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,myRedpacket,ADDRESSDELEGATE,adderDataDelegata,FANHUI,UIAlertViewDelegate>
{
    MBProgressHUD *_hud;
    MBProgressHUD *_networkConditionHUD;
    NSMutableArray *diZhiDataArr;//地址
    NSDictionary *defaultAddress;
    
    NSString *freight;//运费
   
    BOOL btnbool;
    UITextField *remarkFld;//备注
    
    remarkView *remarkViews;
    UIView *beiRV;
    
    NSString *deliveryAddressId;//收获地址id
    
    //--------------新接口需要－－－－－－－－－－－－－－
    
    
    NSString *myGoodsName;//商品名称
    
    NSString *myDanJia;//商品单价
    
    NSString *myXiaoJi;//小记价格
    
    NSString *myZongJia;// 总价
    
    NSString *myYangLao;//养老金
    
    NSString *myBeiZhu;//备注
    
    //----------------------------------------------
   
}
@property (nonatomic,strong) UITableView *tabview ;
@property (nonatomic,strong) UILabel *shuliangL;
@property (nonatomic,strong) UILabel *dingdanjia;
@property (nonatomic,strong) UILabel *yanglaojing;



//@property (nonatomic,assign) float youhuijia;//优惠价（减去红包后）

@property (nonatomic,assign) float hongbao;//红包
@property (nonatomic,assign) float jifenlv;//积分率
@end

@implementation SubmitOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
        self.title = @"提交订单";
    //显示数量
    UIImage *image = [UIImage imageNamed:@"kuang"];
    
    self.numberTF = [[UITextField alloc]initWithFrame:CGRectMake(image.size.width*.29, 0, image.size.width*.46, image.size.height)];
    _numberTF.font = [UIFont systemFontOfSize:16];
     _numberTF.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    _dingdanjia = [[UILabel alloc]initWithFrame:CGRectMake(w*.66, h*.01+3, w*.3, h*.05)];

      _yanglaojing = [[UILabel alloc]initWithFrame:CGRectMake(w*.66, h*.01+3, w*.3, h*.05)];
    _numberTF.delegate = self;
    _numberTF.textAlignment = NSTextAlignmentCenter;
    
    //手机号
    self.phoneL = [[UILabel alloc]init];
    
    //小记
    self.allPriceL =[[UILabel alloc]initWithFrame:CGRectMake(w*.66, h*.01+3, w*.3, h*.05)];
    _allPriceL.textAlignment = NSTextAlignmentRight;
    _allPriceL.textColor=[UIColor colorWithRed:44/255. green:44/255. blue:44/255. alpha:1];
    
    
    self.singlePriceL = [[UILabel alloc]init];
    [self initViewData];
    
    self.tabview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tabview.dataSource = self;
    self.tabview.delegate = self;
    //  _tabview.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.tabview];
    
    
    
    _hongbao=0.00;
    if ([_shangPan intValue]==31) {
        
   
    if([self.goodsdataDic [@"qty"] intValue] >=5){
        freight = @"0";

    }else{
        freight = @"0";
    }}else {
         freight = @"0";
    }
 

    
    if (self.order_no == nil) {
        self.order_no = @"";
    }
   
    //NSLog(@"----%@",self.their_type);
    remarkFld = [[UITextField alloc]initWithFrame:CGRectMake(55, 0, w*.7, 47)];
   // remarkFld.delegate = self;
    //remarkFld.backgroundColor = [UIColor redColor];
    remarkFld.placeholder = @"选填,可填写您的其他要求给卖家";
    if (w<375) {
        remarkFld.font = [UIFont systemFontOfSize:12];
    }
    remarkViews.userInteractionEnabled = NO;
  
   
    
    beiRV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, w, h)];
    beiRV.backgroundColor = [UIColor grayColor];
    beiRV.alpha = .6;
    [self.view addSubview:beiRV];
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(remearkLoking:)];
    [beiRV addGestureRecognizer:tap];

    remarkViews = [[remarkView alloc]initWithFrame:CGRectMake(30,14, w-60, h*.45)];
    
    remarkViews.backgroundColor = [UIColor orangeColor];
    [remarkViews.leftBtn addTarget:self action:@selector(remarkHidden:) forControlEvents:UIControlEventTouchUpInside];
    [remarkViews.rightBtn addTarget:self action:@selector(remarkText:) forControlEvents:UIControlEventTouchUpInside];
    remarkViews.hidden = YES;
    beiRV.hidden = YES;
    remarkViews.filed.text = remarkFld.text;
    [self.view addSubview:remarkViews];
    
  
   // NSLog(@"---%@",_goodsdataDic);
}


#pragma mark - 加载视图数据
-(void)initViewData {
    
    NSLog(@"%@",_goodsdataDic);
    
   
    //默认从商品详情进入
    
    myGoodsName = [NSString stringWithFormat:@"%@",self.goodsdataDic[@"goodsName"]];//商品名称
    
    myDanJia = [NSString stringWithFormat:@"%@",self.goodsdataDic[@"buyPrice"]] ;//商品单价
    
    myXiaoJi = [NSString stringWithFormat:@"%@",self.goodsdataDic[@"buyPrice"]];//小记价格
    
    myZongJia = [NSString stringWithFormat:@"%@",self.goodsdataDic[@"buyPrice"]];// 总价
    
    myYangLao = [NSString stringWithFormat:@"%@",self.goodsdataDic[@"buyPension"]];//养老金
    _numberTF.text = @"1";
   // myBeiZhu = self.goodsdataDic[@"goodsName"];//备注
    
   
    
    //从订单列表进入
       //--------------暂时------------------------------
    NSArray *arr = self.goodsdataDic[@"orderDetails"];
    NSDictionary *dic = arr[0];
    //---------------－－－－－－－－－－－－－－----------
    if ([dic [@"buyNumber"] intValue] > 0) {    //从订单页进入，含有qty字段
        
        myGoodsName = [NSString stringWithFormat:@"%@",dic[@"goodsName"]];//商品名称
        
        myDanJia = [NSString stringWithFormat:@"%@",dic[@"buyPrice"]] ;//商品单价
        
        myXiaoJi = [NSString stringWithFormat:@"%@",self.goodsdataDic[@"orderAmount"]];//小记价格
        
        myZongJia = [NSString stringWithFormat:@"%@",self.goodsdataDic[@"orderAmount"]];// 总价
        
        myYangLao = [NSString stringWithFormat:@"%.2f",([self.goodsdataDic[@"buyPension"]floatValue] * [dic[@"buyNumber"]intValue])];//养老金
        _numberTF.text = [NSString stringWithFormat:@"%@",dic[@"buyNumber"]];

        
    }
    
    [self.tabview reloadData];
}
#pragma mark - 结束编辑
-(void)endEdi:(id)tap{
    
    if(_numberTF.text.length>3){
        
        
        float price = [myDanJia floatValue];
        _numberTF.text=@"999";
        int numInt = [_numberTF.text intValue];
        self.allPriceL.text = [NSString stringWithFormat:@"%.2f",price * numInt];
        _dingdanjia .text = [NSString stringWithFormat:@"%.2f",price * numInt];

       
        float  yangLao =[myYangLao floatValue];
        _yanglaojing.text = [NSString stringWithFormat:@"%.2f",yangLao * numInt];

        
        
        if (!_networkConditionHUD) {
            _networkConditionHUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:_networkConditionHUD];
        }
        _networkConditionHUD.labelText = @"最大请输入999";
        _networkConditionHUD.mode = MBProgressHUDModeText;
        _networkConditionHUD.yOffset = APP_HEIGHT/2 - HUDBottomH;
        _networkConditionHUD.margin = HUDMargin;
        [_networkConditionHUD show:YES];
        [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        
    }else if ([_numberTF.text intValue]>1){
        self.decBtn.enabled = YES;
        [_decBtn setImage:[UIImage imageNamed:@"jianhao1"] forState:UIControlStateNormal];
        
    }
    
    [self.view endEditing:YES];
    
    
   
}


#pragma mark - 数量减
- (IBAction)decAction:(id)sender {
    int currNum = [self.numberTF.text intValue];
    int numInt = currNum - 1;
    if(numInt<1){
        numInt=1;
        
    }
//    if ([_shangPan intValue]==31) {
//        if (numInt<5) {
//            freight = @"8";
//            [_tabview reloadData];
//        }
//    }
   
    self.numberTF.text = [NSString stringWithFormat:@"%d",numInt];
    
    if ([self.numberTF.text isEqualToString:@"1"]) {
        self.decBtn.enabled = NO;
    }
    
    float price = [myDanJia floatValue];
    self.allPriceL.text = [NSString stringWithFormat:@"%.2f",price * numInt];
    float nima = ([_allPriceL.text floatValue])-_hongbao;
  
    float  yangLao =[myYangLao floatValue];
    _yanglaojing.text = [NSString stringWithFormat:@"%.2f",yangLao * numInt];
    
    
        _dingdanjia .text = [NSString  stringWithFormat:@"%.2f",nima];

    if(numInt<5){
         _dingdanjia .text = [NSString  stringWithFormat:@"%.2f",(nima+[freight intValue])];
    }
}

#pragma mark - 数量加
- (IBAction)incAction:(id)sender {
    int currNum = [self.numberTF.text intValue];
    if (currNum >= 1) {
        self.decBtn.enabled = YES;
        [self.decBtn setImage:[UIImage imageNamed:@"jianhao1"] forState:UIControlStateNormal];
    }
    int numInt = currNum + 1;
//    if ([_shangPan intValue]==31) {
//    if (numInt>=5) {
//        freight = @"0";
//        [_tabview reloadData];
//    }
//}
    self.numberTF.text = [NSString stringWithFormat:@"%d",numInt];
    
    float price = [myDanJia floatValue];
    self.allPriceL.text = [NSString stringWithFormat:@"%.2f",price * numInt];
    float nima = ([_allPriceL.text floatValue])-_hongbao;
    
    if (numInt<5) {
        _dingdanjia .text = [NSString  stringWithFormat:@"%.2f",(nima+[freight intValue])];
    }else {
        _dingdanjia .text = [NSString  stringWithFormat:@"%.2f",nima];
    }
    
    float  yangLao =[myYangLao floatValue];
    _yanglaojing.text = [NSString stringWithFormat:@"%.2f",yangLao * numInt];
   
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self endEdi:nil];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //--------------暂时------------------------------
    NSArray *arr = self.goodsdataDic[@"orderDetails"];
    NSDictionary *dic = arr[0];
    //---------------－－－－－－－－－－－－－－----------
    if ([str integerValue] < 1) {   //当输入的值小于1时，强制修改为为1
        self.numberTF.text = @"";
        self.decBtn.enabled = NO;
        self.allPriceL.text = [NSString stringWithFormat:@"%@",self.goodsdataDic[@"buyPrice"]];
        _dingdanjia .text = [NSString stringWithFormat:@"%@",self.goodsdataDic[@"buyPrice"]];
        _yanglaojing.text =   myYangLao = [NSString stringWithFormat:@"%.2f",([self.goodsdataDic[@"buyPension"]floatValue] * [dic[@"buyNumber"]intValue])];//养老金;
        return NO;
    }
    else if ([str integerValue] > 1) {
        self.decBtn.enabled = YES;
        float price = [myDanJia floatValue];
        self.allPriceL.text = [NSString stringWithFormat:@"%.2f",price * [str intValue]];
    }
    float nima = ([myZongJia floatValue])-_hongbao;
    _dingdanjia .text = [NSString  stringWithFormat:@"%.2f",nima];
    _yanglaojing.text = [NSString stringWithFormat:@"%.2f元",([self.fraction floatValue]/100*nima)/2];
    return YES;
}
- (IBAction)submitAction:(id)sender {
    if([_shangPan intValue]==31){
  
        if([self.numberTF.text intValue]<5){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"五包以下不包邮，全国统一邮费8元" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        alert.tag = 1010;
//        [alert show];
        }else {
            [self  requestSubmitOrder];
        }
    }else {
        [self  requestSubmitOrder];
    }
   
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (! _hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_hud];
       

            [self requestGetDeliveryAddressList];
      
    }
    
    if (!_networkConditionHUD) {
        _networkConditionHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_networkConditionHUD];
    }
    _networkConditionHUD.mode = MBProgressHUDModeText;
    _networkConditionHUD.yOffset = APP_HEIGHT/2 - HUDBottomH;
    _networkConditionHUD.margin = HUDMargin;
  
    if([_caocao isEqual:@"MyEntityOrderViewCountroller"]){
       
        btnbool=YES;
        _nameText =_goodsdataDic[@"toRealname"];
        
        _numberText=_goodsdataDic[@"toMobile"];
        
        _diZhiText =[NSString stringWithFormat:@"%@%@",_goodsdataDic[@"toAreaName"],_goodsdataDic[@"toAddress"]];
        
    }else if ([_caocao isEqual:@"OrederEntityViewController"]){
        btnbool=YES;
        _nameText =_goodsdataDic[@"toRealname"];
        
        _numberText=_goodsdataDic[@"toMobile"];
        
        _diZhiText =[NSString stringWithFormat:@"%@%@",_goodsdataDic[@"toAreaName"],_goodsdataDic[@"toAddress"]];
    }
    NSLog(@"------------%@",_shangPan);
    [self.tabview reloadData];
}

#pragma mark - 地址请求
-(void)requestGetDeliveryAddressList { //获取收货地址列表
   
    //注册通知
    if([_caocao isEqual:@"MyEntityOrderViewCountroller"]){
   
        btnbool=YES;
        _nameText =_goodsdataDic[@"toRealname"];
        
        _numberText=_goodsdataDic[@"toMobile"];
        
        _diZhiText =[NSString stringWithFormat:@"%@%@",_goodsdataDic[@"toAreaName"],_goodsdataDic[@"toAddress"]];
        return;
        
    }else if ([_caocao isEqual:@"OrederEntityViewController"]){
        _nameText =_goodsdataDic[@"toRealname"];
        
        _numberText=_goodsdataDic[@"toMobile"];
        
        _diZhiText =[NSString stringWithFormat:@"%@%@",_goodsdataDic[@"toAreaName"],_goodsdataDic[@"toAddress"]];
    }else{
        
        
         [_hud show:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:GetDeliveryAddressList object:nil];
    
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:GetDeliveryAddressList, @"op", nil];
        
         NSString *token = [NSString stringWithFormat:@"%@",[[GlobalSetting shareGlobalSettingInstance] pension]];
        NSString *url = [NSString stringWithFormat:@"pri/deliveryaddress/list.json?token=%@&page=1&rows=30",token];
        
        [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL2(url) delegate:nil params:nil info:infoDic];
        
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
   
    
    if (buttonIndex == 1) {
         if (alertView.tag==1000) {
         [self goToReceiveAddressViewController];
    }else if (alertView.tag==1010) {
            [self  requestSubmitOrder];
        }
}
    
 
    

}
#pragma mark - 发送提交订单请求
-(void)requestSubmitOrder { //提交订单
    
        if(_nameText!=nil||_numberText!=nil||diZhiDataArr!=nil){
             [_hud show:YES];
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:SubmitOrder object:nil];
        NSString *token = [NSString stringWithFormat:@"%@",[[GlobalSetting shareGlobalSettingInstance] pension]];
            
        NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:SubmitOrder, @"op", nil];
       //orderId=%@&
        NSString *url =[NSString stringWithFormat: @"pri/order/create.json?goodsId=%@&number=%@&buyerRemark=%@&deliveryAddressId=%@&token=%@&totalPrice=%@",_goodsdataDic[@"id"],_numberTF.text,remarkFld.text,deliveryAddressId,token,_dingdanjia.text];
        
            
            
            NSLog(@"----%@",NewRequestURL2(url));

           
        [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL2(url) delegate:nil params:nil info:infoDic];
    
           
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"收货信息不能为空，请添加收获地址" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 1000;
            [alert show];
        }
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
    
    if ([notification.name isEqualToString:SubmitOrder]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:SubmitOrder object:nil];
        NSLog(@"GetMerchantList_responseObject: %@",responseObject);
        
        NSString *allPrice =self.allPriceL.text;
        if ([responseObject[@"code"] intValue] == 0) {
            
//            if([_shangPan intValue]==31){
//                if ([self.numberTF.text intValue]<5) {
//                    allPrice = [NSString stringWithFormat:@"%.2f",([self.allPriceL.text floatValue]+[freight floatValue])];
//                }else{
//                    allPrice =self.allPriceL.text;
//                }
//            }
            PayOrderViewController *payVC = [[PayOrderViewController alloc] init];
            payVC.orderInfoDic = responseObject [DATA];
            payVC.goods_name = self.goodsNameL.text;
            payVC.goods_detail = self.goodsdataDic [@"goods_title"];  //商品描述body
            payVC.amount = allPrice;
            payVC.their_type = self.goodsdataDic [@"their_type"];
            payVC.merchant_id = self.merchant_id;
            payVC.qtyStr = self.numberTF.text;
            [self.navigationController pushViewController:payVC animated:YES];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:MSG] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
    NSDictionary *responseObject1 = [[NSDictionary alloc] initWithDictionary:[notification.userInfo objectForKey:@"RespData"]];
    if ([notification.name isEqualToString:GetDeliveryAddressList]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:GetDeliveryAddressList object:nil];
        
        NSLog(@"GetMerchantList_responseObject: %@",responseObject1);
        if ([responseObject[@"code"] intValue] == 0) {
           // _networkConditionHUD.labelText = [responseObject1 objectForKey:MSG];
            [_networkConditionHUD show:YES];
            [_networkConditionHUD hide:YES afterDelay:HUDDelay];
            
            diZhiDataArr = responseObject1[@"data"][@"rows"];
            if (diZhiDataArr.count>0) {
               btnbool = YES;
                for (int i=0; i<diZhiDataArr.count; i++) {
                    if (diZhiDataArr>0) {
                        defaultAddress = diZhiDataArr[0];
                        _nameText = defaultAddress[@"consigneeName"];
                        _numberText = [NSString stringWithFormat:@"%@",defaultAddress[@"mobile"]];
                        _diZhiText =[NSString stringWithFormat:@"%@%@",defaultAddress[@"fullName"],defaultAddress[@"address"]];
                        self.accept_name = _nameText;
                        self.address = _diZhiText;
                        self.myMobile = _numberText;
                       deliveryAddressId =defaultAddress[@"id"];
                    }
                    
                }
            }else if(diZhiDataArr.count<=0) {
               btnbool =NO;
            }
      
            
            for(int i=0;i<diZhiDataArr.count;i++){
                NSDictionary *dic = diZhiDataArr[i];
                if ([dic[@"markaddress"] intValue]==1) {
                    defaultAddress = diZhiDataArr[i];
                    _nameText = defaultAddress[@"consigneeName"];
                    _numberText = [NSString stringWithFormat:@"%@",defaultAddress[@"mobile"]];
                    _diZhiText =[NSString stringWithFormat:@"%@%@",defaultAddress[@"fullName"],defaultAddress[@"address"]];
                    self.accept_name = _nameText;
                    self.address = _diZhiText;
                    self.myMobile = _numberText;
                     deliveryAddressId =defaultAddress[@"id"];
                }
            }

            [self.tabview reloadData];
    }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject1 objectForKey:MSG] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
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
    if(section==0){
        return 1;
    }else if (section==2) {
        return 4;
    }else if (section==3){
        return 1;
    }
    return 3;
}
#pragma mark - 返回cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
    
        return 117;
    }
    return 47;
    
    
}
#pragma mark - 设置表头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
        return 20;
    }
    return 3;
}
#pragma mark - 设置表尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section==3){
        return self.view.frame.size.height*.4+64;
    }
    return 3;
}
#pragma mark - 设置tableViewCell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section ==0) {
        static NSString *s = @"SubmitText";
        
        SumOneCell *cell = [tableView dequeueReusableCellWithIdentifier:s];
        if(!cell){
            
            cell=[[SumOneCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:s];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
           // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.nameL.text = _nameText;
        cell.numberL.text = _numberText;
        cell.dizhi.text = _diZhiText;
        [cell.addDiBtn addTarget:self action:@selector(goToReceiveAddressViewController) forControlEvents:UIControlEventTouchUpInside];
        cell.addDiBtn.hidden = btnbool;
        return cell;
    } else{
    
    
    
    static  NSString *ss=@"SUMTWOCELL";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ss];
    
    if(!cell){
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ss];
         
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //显示右边箭头
        if ((indexPath.section==0&&indexPath.row==1)||(indexPath.section==2&&indexPath.row==1)) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
           
        }
    }
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0,46, w, 1)];
        lab.backgroundColor = [UIColor colorWithRed:235/255. green:235/255. blue:241/255. alpha:1];
        [cell addSubview:lab];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    cell.textLabel.textColor=[UIColor colorWithRed:44/255. green:44/255. blue:44/255. alpha:1];
    
    cell.detailTextLabel.textColor =[UIColor colorWithRed:44/255. green:44/255. blue:44/255. alpha:1];
    

        if(indexPath.section==1&&indexPath.row==0){
        
        // 商品名称
        self.goodsNameL = [[UILabel alloc]init];
            _goodsNameL.text=myGoodsName;
        cell.textLabel.text=_goodsNameL.text;
        //商品单价
      
        cell.detailTextLabel.text=myDanJia;
    }else if(indexPath.section==1&&indexPath.row==1){
        
        cell.detailTextLabel.text=nil;
        cell.textLabel.text =@"数量";
        //背景框
       
        UIImage *image = [UIImage imageNamed:@"kuang"];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(w*.6, h*.01+3, image.size.width, image.size.height)];
        imageView.userInteractionEnabled = YES;
        imageView.image=image;
        [cell addSubview:imageView];
        
      //数量框
        
        [imageView addSubview:self.numberTF];
        
        //减号按钮
       self.decBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       _decBtn.frame = CGRectMake(2, 0, image.size.width*.25, image.size.height);
        
        [_decBtn setImage:[UIImage imageNamed:@"jianhao"] forState:UIControlStateNormal];
         //_decBtn.backgroundColor = [UIColor redColor];
        [_decBtn  addTarget:self action:@selector(decAction:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:_decBtn];
        
        //加号按钮
        
        self.incBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      _incBtn.frame = CGRectMake(imageView.frame.size.width*.72,0, image.size.width*.25, image.size.width*.25);
        
        [_incBtn setImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
        //_incBtn.backgroundColor = [UIColor redColor];
        [_incBtn addTarget:self action:@selector(incAction:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:_incBtn];
        
        
        
        
    }else if (indexPath.section==1&&indexPath.row==2){
        
        _allPriceL.text = myXiaoJi;
        [cell addSubview:_allPriceL];
        
        cell.textLabel.text=@"小计";
        
        
        
    }else if (indexPath.section==2&&indexPath.row==0){
        cell.textLabel.text=@"运费";
        cell.detailTextLabel.text = freight;
        cell.tag = 20202;
    }else if (indexPath.section==2&&indexPath.row==1){
        
        cell.textLabel.text=@"红包";
        
      //  cell.detailTextLabel.text=[NSString stringWithFormat:@"-%.2f元",_hongbao];
          cell.detailTextLabel.text = @"暂无";
    }else if (indexPath.section==2&&indexPath.row==2){
        
        cell.textLabel.text=@"订单总价";
        
        
//        
//        float nima = ([_allPriceL.text floatValue])-_hongbao;
//        if ([self.goodsdataDic [@"qty"] intValue]<5) {
//            _dingdanjia .text = [NSString  stringWithFormat:@"%.2f元",(nima+[freight intValue])];
//        }else {
//            _dingdanjia .text = [NSString  stringWithFormat:@"%.2f元",nima];
//        }
        
        _dingdanjia .text = myZongJia;
        _dingdanjia.textColor =[UIColor colorWithRed:250/255. green:37/255. blue:53/255. alpha:1];
        _dingdanjia.textAlignment = NSTextAlignmentRight;
        _dingdanjia.font = [UIFont systemFontOfSize:13];
        [cell addSubview:_dingdanjia];
        
    }else if (indexPath.section==2&&indexPath.row==3){
        
        cell.textLabel.text=@"将获养老金";
        
      
        
        _yanglaojing.textColor =[UIColor colorWithRed:250/255. green:37/255. blue:53/255. alpha:1];
        _yanglaojing.textAlignment = NSTextAlignmentRight;
        _yanglaojing.font = [UIFont systemFontOfSize:15];
       
        _yanglaojing.text =myYangLao;
        [cell addSubview:_yanglaojing];
    }else if (indexPath.section == 3&&indexPath.row==0){
        cell.textLabel.text = @"备注：";
        [cell.contentView addSubview:remarkFld];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, w, 47)];
        [btn addTarget:self action:@selector(lookremark) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn];
    }
    
    
    
        return cell;
    }
    return nil;
}
#pragma mark - 监听tableViewCell点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击cell背景恢复正常状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
       
        AddressViewController *addressView = [[AddressViewController alloc]init];
       //  addressView.addressData = diZhiDataArr;
        addressView.mydelegate = self;
        addressView.fanhuiDelegate = self;
        [self.navigationController pushViewController:addressView animated:YES];
        
    }else if(indexPath.section==2&&indexPath.row==1){
//        RedPacket *redPacket = [[RedPacket alloc]init];
//        redPacket.xieyi=self;
//        [self.navigationController pushViewController:redPacket animated:YES];
        [self privilege];
    }else if (indexPath.section==3&&indexPath.row==0){
        [self lookremark];
    }
    
}
#pragma mark - 显示备注框
-(void)lookremark{
    remarkViews.hidden = NO;
    beiRV.hidden = NO;
}
-(void)privilege{
    
        if (!_networkConditionHUD) {
            _networkConditionHUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:_networkConditionHUD];
        }
        _networkConditionHUD.labelText = @"暂无红包";
        _networkConditionHUD.mode = MBProgressHUDModeText;
        _networkConditionHUD.yOffset = APP_HEIGHT/2 - HUDBottomH-200;
        _networkConditionHUD.margin = HUDMargin;
        [_networkConditionHUD show:YES];
        [_networkConditionHUD hide:YES afterDelay:HUDDelay];
}
-(void)returnRedpacket:(float)redPacket{
    _hongbao=redPacket;
    NSLog(@"%.2f",_hongbao);
}



-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 3)
    {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, w, self.view.frame.size.height*3)];
        [view setUserInteractionEnabled:YES];
        //提交订单按钮
       // view.backgroundColor = [UIColor redColor];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor colorWithRed:250/255. green:37/255. blue:53/255. alpha:1];
        btn.layer.cornerRadius=3;
        btn.frame = CGRectMake(w*.15, 60, w*.7, 45);
        
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [btn setTitle:@"提交订单" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(w*.15, 30, w*.7, 25)];
        lable.text = @"暂不支持退货";
        lable.textColor = [UIColor grayColor];
        lable.alpha = .6;
        lable.font = [UIFont systemFontOfSize:13];
        lable.textAlignment = NSTextAlignmentCenter;
        [view addSubview:lable];
        return view;
    }
    else
    {
        
        return nil;
    }
    
    return nil;
}



-(void)goToReceiveAddressViewController{
    ReceiveAddressViewController *view = [[ReceiveAddressViewController alloc]init];
    view.address = self;
    view.nimabi = @"666";
    [self.navigationController pushViewController:view animated:YES];
}
-(void)returnAddress:(NSMutableArray *)addressArr{
    diZhiDataArr = addressArr;
    if (diZhiDataArr.count>0) {
    btnbool = YES;
        for (int i=0; i<diZhiDataArr.count; i++) {
            if (diZhiDataArr>0) {
                defaultAddress = diZhiDataArr[0];
               _nameText = defaultAddress[@"consigneeName"];
                _numberText = [NSString stringWithFormat:@"%@",defaultAddress[@"mobile"]];
                _diZhiText =[NSString stringWithFormat:@"%@%@",defaultAddress[@"fullName"],defaultAddress[@"address"]];

                self.accept_name = _nameText;
                self.address = _diZhiText;
                self.myMobile = _numberText;
                deliveryAddressId = defaultAddress[@"id"];
                _cao = @"OrederEntityViewController";
            }
            NSDictionary *dic = diZhiDataArr[i];
            if ([dic[@"markAddress"] intValue]==1) {
                defaultAddress = diZhiDataArr[i];
                   NSLog(@"wode=======%@",defaultAddress);
                _nameText = defaultAddress[@"consigneeName"];
                _numberText = [NSString stringWithFormat:@"%@",defaultAddress[@"mobile"]];
               _diZhiText =[NSString stringWithFormat:@"%@%@",defaultAddress[@"fullName"],defaultAddress[@"address"]];
                self.accept_name = _nameText;
                self.address = _diZhiText;
                self.myMobile = _numberText;
                deliveryAddressId = dic[@"id"];
                _caocao = @"OrederEntityViewController";
            }
            
        }
    }else if(diZhiDataArr.count<=0) {
       btnbool =NO;
    }
    
}
-(void)returnSumitAddress:(NSDictionary *)dic{
    if(dic==nil){
        btnbool = NO;
    }else {
    _nameText = dic[@"consigneeName"];
    
    _numberText = [NSString stringWithFormat:@"%@",dic[@"mobile"]];
    
    _diZhiText =[NSString stringWithFormat:@"%@%@",dic[@"fullName"],dic[@"address"]];
       // _caocao=nil;
        self.accept_name = _nameText;
        self.address = _diZhiText;
        self.myMobile = _numberText;
        deliveryAddressId = dic[@"id"];
    }
   
}
-(void)fanhuiAddress:(NSMutableArray *)arr{
    
    if (arr==nil) {
        btnbool = NO;

    }
    if(arr.count==0){
         btnbool = NO;
    }
    else {
        NSDictionary *dic = [NSDictionary dictionary];
        for (int i = 0; i<arr.count;i++) {
            dic = arr[i];
            
        }
    }
    
}
#pragma mark - 备注
-(void)remearkLoking:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
   
}
-(void)remarkHidden:(UIButton *)btn{
    [self.view endEditing:YES];

     remarkViews.hidden = YES;
    beiRV.hidden = YES;
}
-(void)remarkText:(UIButton*)btn{
    [self.view endEditing:YES];

    remarkFld.text = remarkViews.filed.text;
    remarkViews.hidden = YES;
    beiRV.hidden = YES;

}

@end
