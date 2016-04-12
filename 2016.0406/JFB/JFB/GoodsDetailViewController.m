//
//  GoodsDetailViewController.m
//  JFB
//
//  Created by JY on 15/9/4.
//  Copyright (c) 2015年 JY. All rights reserved.
//
#import "UMSocial.h"
#import "GoodsDetailViewController.h"
#import "GoodsDetailHeadCell.h"
#import "GoodsDetailShopInfoCell.h"
#import "ShopDetailEvaluateCell.h"
#import "ShopDetailVoucherCell.h"
#import "DetailBottomNextCell.h"
#import "ShopDetailGoodsCel.h"
#import "ShopDetailGoodsCel.h"
#import "SubmitOrderViewController.h"
#import "GoodsDetailWebVC.h"
#import "WebViewController.h"
#import "AllEvaluateViewController.h"
#import "LoginViewController.h"
#import "DJQRateView.h"
#import "goodsDetailDescriptionEvaluateCell.h"
#import "TSF_oneCell.h"
#import "goodsDetailDescriptionCell.h"
#import "goodsDetailDescriptionSatateCell.h"
#import "GoodsDetailShopCell.h"
#import "MoneyView.h"
#import "TFHpple.h"
#import "checkIphoneNum.h"
#import "PhontViewController.h"
#import "HZPhotoBrowser.h"
#define GoodsCell    @"shopDetailGoodsCell"
#define HeadCell      @"goodsDetailHeadCell"
#define ShopInfoCell      @"goodsDetailShopInfoCell"
#define EvaluateCell    @"shopDetailEvaluateCell"
#define VoucherCell    @"shopDetailVoucherCell"
#define BottomNextCell      @"detailBottomNextCell"
#import "AutoStirViewController.h"
#import <MobClick.h>


#define WITH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

static const float RealSrceenHight =  667.0;
#import "ShopDetailViewController.h"
@interface GoodsDetailViewController ()<UITableViewDataSource,UITableViewDelegate,lunBoDelegate1,HZPhotoBrowserDelegate,UMSocialUIDelegate>
{
    MBProgressHUD *_hud;
    MBProgressHUD *_networkConditionHUD;
    NSDictionary *_goodsdataDic;
    NSArray *_otherdataArray;
    NSString *_promise_urlStr;
    NSArray *_recommenddataArray;
    NSDictionary *_reviewdataDic;
    
    NSString *flagStr; //收藏1，取消收藏2
    
    BOOL isWebViewFirstLoad;    //cell的webView第一次加载
    
    CGFloat webViewHeight;  //商品详情cell中webView的高度
    UITableView *myTable;
    MoneyView *moneyView ;
    
}
@property (nullable,nonatomic,strong) NSMutableAttributedString *attributedText1;
@property (nonatomic , strong) NSString *imageURLTexts;

//自定义的导航视图
@property (nonatomic , strong) UIView *myNavgationView;
//自定义的导航视图一开始的
@property (nonatomic , strong) UIView *myNavgationViewNow;
//最下边的视图
@property (nonatomic , strong) UIView *maxBottomView;
//商家按钮的label
@property (nonatomic , strong) UILabel *merchantBtn_subtitleL;
//商家按钮的label
@property (nonatomic , strong) NSArray *photoUrlArray;
//商家信息的字典
@property (nonatomic,strong) NSDictionary *shopMessageDic;
//收藏按钮
@property (nonatomic,strong) UIButton *collectBtn;
@end

@implementation GoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.extendedLayoutIncludesOpaqueBars=YES;
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    self.view.backgroundColor=[UIColor redColor];
    // Do any additional setup after loading the view from its nib.
    //    self.title = @"商品详情";
    
        webViewHeight = 83.0f;
    isWebViewFirstLoad = YES;
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, -1, WITH, HEIGHT-48) style:UITableViewStyleGrouped];
    myTable.dataSource = self;
    myTable.delegate = self;
    myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTable];
    //添加自定义大的导航视图
    [self.view addSubview:self.myNavgationViewNow];
    [self.view addSubview:self.myNavgationView];
    [self.view addSubview:self.collectBtn];

    //底部视图=========================================
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,  HEIGHT-45, WITH, 49)];
    //    bottomView.backgroundColor = [UIColor redColor];
    [self.view addSubview:bottomView];
    bottomView.layer.borderColor=RGBCOLOR(221, 221, 221).CGColor;
    bottomView.layer.borderWidth=1;
    //商家按钮
    UIButton *merchantBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    //    merchantBtn.backgroundColor=[UIColor grayColor];
    merchantBtn.x=20;
    merchantBtn.y=8;
    merchantBtn.height=bottomView.height-16;
    merchantBtn.width=merchantBtn.height-12;
    [merchantBtn setImage:[UIImage imageNamed:@"merchantBtn_normal"] forState:UIControlStateNormal];
    [merchantBtn setImage:[UIImage imageNamed:@"merchantBtn_seleted"] forState:UIControlStateHighlighted];
    [bottomView addSubview:merchantBtn];
    merchantBtn.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 12, 0);
    //    merchantBtn.titleLabel.text=@"商家";
    //    [merchantBtn setTitle:@"商家" forState:UIControlStateNormal];
    UILabel *merchantBtn_subtitleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, merchantBtn.width, 10)];
    merchantBtn_subtitleL.textAlignment = NSTextAlignmentCenter;
    merchantBtn_subtitleL.font = [UIFont systemFontOfSize:10];
    merchantBtn_subtitleL.textColor=[UIColor grayColor];
    merchantBtn_subtitleL.text = @"商家";
    merchantBtn_subtitleL.textAlignment=NSTextAlignmentCenter;
    [merchantBtn addSubview:merchantBtn_subtitleL];
    [merchantBtn addTarget:self action:@selector(merchantBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [merchantBtn addTarget:self action:@selector(merchantBtnDidTouchDown:) forControlEvents:UIControlEventTouchDown];
    self.merchantBtn_subtitleL=merchantBtn_subtitleL;
    //购物车按钮
    //    UIButton *shoppingCartBtn=[[UIButton alloc]init];
    //    shoppingCartBtn.x=CGRectGetMaxX(merchantBtn.frame);
    //    shoppingCartBtn.width=merchantBtn.width;
    //    shoppingCartBtn.height=merchantBtn.height;
    //    shoppingCartBtn.y=merchantBtn.y;
    //    [bottomView addSubview:shoppingCartBtn];
    ////    shoppingCartBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    //    shoppingCartBtn.backgroundColor=[UIColor grayColor];
    //    //加入购物车按钮
    //    UIButton *addToShoppingCartBtn=[[UIButton alloc]init];
    //    addToShoppingCartBtn.backgroundColor=[UIColor whiteColor];
    //    addToShoppingCartBtn.layer.borderWidth=1;
    //    addToShoppingCartBtn.layer.borderColor=[UIColor redColor].CGColor;
    //    [bottomView addSubview:addToShoppingCartBtn];
    //    [addToShoppingCartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    //    [addToShoppingCartBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //    addToShoppingCartBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    //    addToShoppingCartBtn.layer.masksToBounds=YES;
    //    addToShoppingCartBtn.layer.cornerRadius=5;
    //加入立即购买按钮
    UIButton *buyNowBtn=[[UIButton alloc]init];
    buyNowBtn.backgroundColor=[UIColor redColor];
    [buyNowBtn setTitle:@"立刻购买" forState:UIControlStateNormal];
    [buyNowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomView addSubview:buyNowBtn];
    buyNowBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    buyNowBtn.layer.masksToBounds=YES;
    buyNowBtn.layer.cornerRadius=5;
    [buyNowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomView).with.offset(-7);
        make.right.equalTo(bottomView).with.offset(-12.5);
        make.size.mas_equalTo(CGSizeMake(100, 35));
        
    }];
    [buyNowBtn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
    //    [addToShoppingCartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(bottomView).with.offset(5);
    //        make.right.equalTo(buyNowBtn.mas_left).with.offset(-5);
    //        make.size.mas_equalTo(CGSizeMake(100, 35));
    //    }];
    
    
}
#pragma mark-懒加载
-(NSArray *)photoUrlArray{
    if (_photoUrlArray==nil) {
        _photoUrlArray=[[NSArray alloc]init];
    }
    return _photoUrlArray;
}
-(NSDictionary *)shopMessageDic{
    if (_shopMessageDic==nil) {
        _shopMessageDic=[[NSDictionary alloc]init];
    }
    return _shopMessageDic;
}
-(UIButton *)collectBtn{
    if (_collectBtn==nil) {
        _collectBtn=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-96), 25, 38, 38)];
        //        collectBtn.backgroundColor=[UIColor grayColor];
        //        [_myNavgationView addSubview:collectBtn];
        [_collectBtn setImage:[UIImage imageNamed:@"WSC_1"] forState:UIControlStateNormal];
        [_collectBtn setImage:[UIImage imageNamed:@"SC_1"] forState:UIControlStateSelected];
        [_collectBtn addTarget:self action:@selector(toFavorite:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectBtn;
}
#pragma mark-商家按钮的点击事件
-(void)merchantBtnDidClick:(UIButton *)sender{
    [self toShopDetailViewController];
}
#pragma mark-商家按钮的开始触摸事件
-(void)merchantBtnDidTouchDown:(UIButton *)sender{
    self.merchantBtn_subtitleL.textColor=[UIColor redColor];
}
-(void)popGoodsView{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // [self requestGetGoodsDetail];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.myNavgationViewNow.hidden=NO;
    self.myNavgationView.hidden=NO;
    self.collectBtn.hidden=NO;
    self.merchantBtn_subtitleL.textColor=[UIColor grayColor];
    if (_frameBool) {
         self.navigationController.navigationBar.translucent = NO;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // self.navigationController.navigationBar.translucent = NO;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.translucent = NO;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.myNavgationViewNow.hidden=YES;
    self.myNavgationView.hidden=YES;
    self.collectBtn.hidden=YES;
    
    if (_frameBool) {
        self.navigationController.navigationBar.translucent = YES;
    }

}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (! _hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self requestGetGoodsDetail];
        [self.view addSubview:_hud];
        
    }
    
    if (!_networkConditionHUD) {
        _networkConditionHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_networkConditionHUD];
    }
    _networkConditionHUD.mode = MBProgressHUDModeText;
    _networkConditionHUD.yOffset = APP_HEIGHT/2 - HUDBottomH;
    _networkConditionHUD.margin = HUDMargin;
    
  
    [myTable reloadData];
   
}
#pragma mark-懒加载导航视图
-(UIView *)myNavgationView{
    if (_myNavgationView==nil) {
        _myNavgationView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _myNavgationView.backgroundColor=[UIColor redColor];
        _myNavgationView.alpha=0;
        //添加返回的圆按钮
        UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 25, 38, 38)];
        //        backBtn.backgroundColor=[UIColor grayColor];
        [_myNavgationView addSubview:backBtn];
        [backBtn addTarget:self action:@selector(popGoodsView) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setImage:[UIImage imageNamed:@"FH_2"] forState:UIControlStateNormal];
        //添加收藏按钮
        //        UIButton *collectBtn=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-96), 25, 38, 38)];
        //        //        collectBtn.backgroundColor=[UIColor grayColor];
        //        [_myNavgationView addSubview:collectBtn];
        //        [collectBtn setImage:[UIImage imageNamed:@"aixin_normal"] forState:UIControlStateNormal];
        //        [collectBtn setImage:[UIImage imageNamed:@"aixin_selected"] forState:UIControlStateSelected];
        //        [collectBtn addTarget:self action:@selector(toFavorite:) forControlEvents:UIControlEventTouchUpInside];
        //        [_myNavgationView addSubview:self.collectBtn];
        //添加详情按钮
        UIButton *detailBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.collectBtn.frame)+10, 25, 38, 38)];
        //        detailBtn.backgroundColor=[UIColor grayColor];
        [_myNavgationView addSubview:detailBtn];
        [detailBtn setImage:[UIImage imageNamed:@"FX_2"] forState:UIControlStateNormal];
        [detailBtn addTarget:self action:@selector(myShar:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _myNavgationView;
}
#pragma mark-懒加载导航视图
-(UIView *)myNavgationViewNow{
    if (_myNavgationViewNow==nil) {
        _myNavgationViewNow=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _myNavgationViewNow.backgroundColor=[UIColor clearColor];
        _myNavgationViewNow.alpha=1;
        //添加返回的圆按钮
        UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 25, 38, 38)];
        //        backBtn.backgroundColor=[UIColor grayColor];
        [_myNavgationViewNow addSubview:backBtn];
        [backBtn setImage:[UIImage imageNamed:@"FH_1"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(popGoodsView) forControlEvents:UIControlEventTouchUpInside];
        //添加收藏按钮
        //        UIButton *collectBtn=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-96), 25, 38, 38)];
        //        //        collectBtn.backgroundColor=[UIColor grayColor];
        //        [_myNavgationViewNow addSubview:collectBtn];
        //        [collectBtn setImage:[UIImage imageNamed:@"aixin_normal"] forState:UIControlStateNormal];
        //        [collectBtn setImage:[UIImage imageNamed:@"aixin_selected"] forState:UIControlStateSelected];
        //        [collectBtn addTarget:self action:@selector(toFavorite:) forControlEvents:UIControlEventTouchUpInside];
        //        [_myNavgationViewNow addSubview:self.collectBtn];
        //添加详情按钮
        UIButton *detailBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.collectBtn.frame)+10, 25, 38, 38)];
        //        detailBtn.backgroundColor=[UIColor grayColor];
        [_myNavgationViewNow addSubview:detailBtn];
        [detailBtn setImage:[UIImage imageNamed:@"FX_1"] forState:UIControlStateNormal];
        [detailBtn addTarget:self action:@selector(myShar:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myNavgationViewNow;
}


#pragma mark-监听滑动事件实现导航栏的显隐
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float f=scrollView.contentOffset.y;
    NSLog(@"====%f",f);
    if (f>64) {
        self.myNavgationView.alpha +=.1;
        self.myNavgationViewNow.alpha=0;
        [_collectBtn setImage:[UIImage imageNamed:@"WSC_2"] forState:UIControlStateNormal];
        [_collectBtn setImage:[UIImage imageNamed:@"SC_2"] forState:UIControlStateSelected];
    }
    if (f<64) {
        self.myNavgationView.alpha=0;
        self.myNavgationViewNow.alpha+=0.1;
        [_collectBtn setImage:[UIImage imageNamed:@"WSC_1"] forState:UIControlStateNormal];
        [_collectBtn setImage:[UIImage imageNamed:@"SC_1"] forState:UIControlStateSelected];
    }
    
    //    NSLog(@"===============ddhgdhg%f",CGRectGetMaxY(myTable.frame));
    if (f>[checkIphoneNum shareCheckIphoneNum].moveTionLength) {
        [self moveToSeePhotosDetails];
    }
}
-(void)toTelPhone {
    
    NSString *phoneString =[self.shopMessageDic objectForKey:@"telephone"];
    if([phoneString isEqual:@"<null>"]){
        phoneString = [self.shopMessageDic objectForKey:@"mobile"];
    }
    NSLog(@"%@",phoneString);
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneString];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}

#pragma mark-收藏按钮点击事件
-(void)toFavorite:(UIButton *)btn {
    BOOL isLogined = [[GlobalSetting shareGlobalSettingInstance] isLogined];
    
    if (! isLogined) {
        NSLog(@"未登录");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录，现在登录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 4040;
        [alert show];
        return;
    }
    if (btn.selected) {
        flagStr = @"2"; //取消
    }
    else {
        flagStr = @"1";
    }
    //    btn.selected=!btn.selected;
    [self requestCollectSubmit];
}

#pragma mark - UITableViewDataSource


#pragma mark - button Actions
-(void)buyAction {
    BOOL isLogined = [[GlobalSetting shareGlobalSettingInstance] isLogined];
    if (! isLogined) {
        //        _networkConditionHUD.labelText = @"请先登录！";
        //        [_networkConditionHUD show:YES];
        //        [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录，现在登录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 5050;
        [alert show];
        return;
    }
    SubmitOrderViewController *submitVC = [[SubmitOrderViewController alloc] init];
    
    submitVC.merchant_id = _goodsdataDic[@"merchantId"];;
    submitVC.goodsdataDic = _goodsdataDic;
    submitVC.cao =_className;
    submitVC.shangPan = _goodsdataDic[@"id"];
    submitVC.their_type =[NSString stringWithFormat:@"%@,",_goodsdataDic[@"their_type"]];
    // submitVC.memberPension = _goodsdataDic[@"memberPension"];
    [self.navigationController pushViewController:submitVC animated:YES];
    
    NSString * goodsBuy = [NSString stringWithFormat:@"goodsBuy_%@",_goodsdataDic[@"id"]];
    [MobClick event:goodsBuy];
    [MobClick event:@"goodsBuy"];
    
}

-(void)promiseAction {
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.webUrlStr = _promise_urlStr;
    webVC.titleStr = @"积分宝承诺";
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 4040 || alertView.tag == 5050) {
        if (buttonIndex == 1) {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            loginVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (isWebViewFirstLoad && _goodsdataDic [@"zhaiyao"]) {
        isWebViewFirstLoad = NO;
        //        CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
        webViewHeight = webView.scrollView.contentSize.height;
        NSLog(@"webViewHeight: %f",webViewHeight);
        //        CGRect frame = webView.frame;
        //        webView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, webViewHeight);
        
        [myTable reloadData];
    }
}

#pragma mark - 发送请求
-(void)requestGetGoodsDetail { //获取商品详情
    [_hud show:YES];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:GetGoodsDetail object:nil];
    
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:GetGoodsDetail, @"op", nil];
    NSString *token = [NSString stringWithFormat:@"%@",[[GlobalSetting shareGlobalSettingInstance] pension]];
    if (token==nil) {
        token=@"";
    }
    NSString *url = [NSString stringWithFormat:@"goods/get.json?goodsId=%@&token=%@",_goods_id,token];
    JFBLog(@"%@",url);
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL(url) delegate:nil params:nil info:infoDic];
    
}

-(void)requestCollectSubmit { //收藏或取消收藏
    [_hud show:YES];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:SubmitCollect object:nil];
    
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:SubmitCollect, @"op", nil];
    
    NSString *token = [NSString stringWithFormat:@"%@",[[GlobalSetting shareGlobalSettingInstance] pension]];
    NSString *url;
    
    if ([flagStr isEqualToString:@"1"]) {
        url = [NSString stringWithFormat: @"pri/membercollect/collect.json?collectType=0&collectId=%@&token=%@",self.goods_id,token];
        
        
    }else if ([flagStr isEqualToString:@"2"]){
        url = [NSString stringWithFormat:@"pri/membercollect/uncollect.json?collectType=0&collectId=%@&token=%@",self.goods_id,token];
    }
    
    NSLog(@"---------%@----%@",self.goods_id,url);
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL2(url) delegate:nil params:nil info:infoDic];
    
    
    
}

#pragma mark - 网络请求结果数据
-(void) didFinishedRequestData:(NSNotification *)notification{
    [_hud hide:YES];
    if ([[notification.userInfo valueForKey:@"RespResult"] isEqualToString:ERROR]) {
        _networkConditionHUD.labelText = [notification.userInfo valueForKey:@"ContentResult"];
        [_networkConditionHUD show:YES];
        [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        return;
    }
    NSDictionary *responseObject = [[NSDictionary alloc] initWithDictionary:[notification.userInfo objectForKey:@"RespData"]];
    
    if ([notification.name isEqualToString:GetGoodsDetail]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:GetGoodsDetail object:nil];
        if ([responseObject[@"code"] intValue] == 0) {
            NSLog(@"GetMerchantList_responseObject: %@",responseObject);
            
            NSDictionary *dic = responseObject [DATA];
            _goodsdataDic = dic [@"goodsdata"];
            self.shopMessageDic= dic[@"shop"];
            _otherdataArray = dic [@"otherdata"];
            _promise_urlStr = dic [@"promise_url"];
            _recommenddataArray = dic [@"recommenddata"];
            _reviewdataDic = dic [@"reviews"];
            NSLog(@"=======DPDPDPDPDPDDDPDPDP%@",dic);
            _saleText = _goodsdataDic[@"salesPrice"];
            _prilcText = _goodsdataDic[@"salesPrice"];
            NSLog(@"%@",_goodsdataDic[@"marketPrice"]);
            [moneyView pilck :_prilcText :_usedprilcText];
            self.imageURLTexts = _goodsdataDic[@"zhaiyao"];
            
            NSString *GoodsTouchText = [NSString stringWithFormat:@"GoodsTouch_%@",_goodsdataDic[@"id"]];
            [MobClick event:GoodsTouchText];
            [MobClick event:@"GoodsTouch"];

            BOOL iscollect = [dic [@"goodsdata"] [@"isCollect"] boolValue];
            if (iscollect) {
               
                self.collectBtn.selected=YES;
            }
            [myTable reloadData];
        }
        else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:MSG] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    if ([notification.name isEqualToString:SubmitCollect]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:SubmitCollect object:nil];
        if ([responseObject[@"code"] intValue] == 0) {
            _networkConditionHUD.labelText = [responseObject objectForKey:MSG];
            [_networkConditionHUD show:YES];
            [_networkConditionHUD hide:YES afterDelay:HUDDelay];
            
            //            UIBarButtonItem *favItem = self.navigationItem.rightBarButtonItem;
            //            UIButton *favBtn = (UIButton *)favItem.customView;
            self.collectBtn.selected = ! self.collectBtn.selected; //修改按钮状态
        }
        else {
            _networkConditionHUD.labelText = [responseObject objectForKey:MSG];
            [_networkConditionHUD show:YES];
            [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
#pragma mark - 返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0){
        return 4;
    }else if (section==1){
        return 1;
    }else if (section==2){
        return 1;
    }
    return 1;
}
#pragma mark - 返回cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row==0) {
                return SCREEN_WIDTH;
            }else if (indexPath.row==1){
                return SCREEN_HEIGHT*(76/RealSrceenHight);
            }else if (indexPath.row==3){
                return 30;
            }
            return 88;
        }
            break;
        case 1:{
            if (indexPath.row==0) {
                return 80;
            }
            //            else if (indexPath.row==2){
            //                return 120;
            //            }
            return 60;
            
        }break;
        case 2:{
            if (indexPath.row==0) {
                return 120;
            }
            return 60;
            
        }break;
    }
    return 44;
}
#pragma mark - 设置tableViewCell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(indexPath.section==0){
        if (indexPath.row==0) {
            NSString *s=@"oneCell";
            
            TSF_oneCell *mycell = [tableView dequeueReusableCellWithIdentifier:s];
            if (!mycell) {
                mycell= [[TSF_oneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:s];
                
                
                
            }
            //            mycell.photoArray=[_goodsdataDic objectForKey:@"goodsAlbums"];
            NSArray *photoArray1=[_goodsdataDic objectForKey:@"goodsAlbums"];
            NSLog(@"%@",photoArray1);
            AutoStirViewController *temp = [[AutoStirViewController alloc]init];
            temp.delegateLunbo=self;
            NSMutableArray *photoArray = [NSMutableArray array];// 图片加载url数组
            for (NSDictionary *dic in photoArray1) {
                [photoArray addObject:[dic objectForKey:@"originalPath"]];
            }
            NSString *goodsImages=[_goodsdataDic objectForKey:@"goodsImages"];
            if (goodsImages!=nil) {
                [photoArray insertObject:goodsImages atIndex:0];
            }
            temp.photoName = photoArray;
            self.photoUrlArray=photoArray;
            temp.number = [DPCurrentPhotoIndex shareCurrentPhotoIndex].photoIndex; // 从第0张开始播放
            
            temp.needTimer = NO; // 不自动滚动
            
            //            temp.autophotoSize = YES;// 图片根据自身大小自适应
            
            temp.frame = CGRectMake(0, 0, self.view.width, self.view.width);// 图片默认大小
            
            temp.viewFrame = CGRectMake(0, 0, self.view.width, self.view.width);// 整个轮播视图的大小,含描述文字所占空间
            
            [mycell addSubview:temp.view];
            
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.width-60, SCREEN_WIDTH, 60)];
            imageView.image = [UIImage imageNamed:@"goodsBase_IM"];
            [mycell addSubview:imageView];
            
            [self addChildViewController:temp];
            
            
            return mycell;
        }else if (indexPath.row==1){
            NSString *ss=@"DescriptionCel";
            goodsDetailDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:ss];
            if (!cell) {
                cell= [[goodsDetailDescriptionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ss];
                
                UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, 1)];
                lab.backgroundColor = RGBCOLOR(239, 239, 239);
                [cell addSubview:lab];
                
            }
            cell.goodsNameLabel.text=[_goodsdataDic objectForKey:@"goodsName"];
            cell.goodsDescriptionLabel.text=[self removeStrings:[_goodsdataDic objectForKey:@"goodsTitle"]];
            UIImage *image=[UIImage imageNamed:@"to_info_mini_gray"];
            image=[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            cell.myImageView.image=image;
            cell.myImageView.contentMode = UIViewContentModeScaleAspectFit;
            //            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
            return cell;
        }else if (indexPath.row==2){
            NSString *ss=@"DescriptionSatateCell";
            goodsDetailDescriptionSatateCell *cell = [tableView dequeueReusableCellWithIdentifier:ss];
            if (!cell) {
                cell= [[goodsDetailDescriptionSatateCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ss];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if (_goodsdataDic!=nil) {
                cell.currentPriceLabel.text=[NSString stringWithFormat:@"¥ %@",_goodsdataDic[@"buyPrice"]];;
                CGSize currentSize=[cell.currentPriceLabel.text stringGetSizeWithFont:30];
                cell.currentPriceLabel.width=currentSize.width;
                cell.realPriceLabel.x=CGRectGetMaxX(cell.currentPriceLabel.frame);
                NSString *oldPrice=[NSString stringWithFormat:@"¥ %@",_goodsdataDic[@"marketPrice"]];
                NSUInteger length = [oldPrice length];
                
                NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
                
                [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
                [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, length)];
                [attri addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, length)];
                [cell.realPriceLabel setAttributedText:attri];
                NSString *memberPension=[NSString stringWithFormat:@"%@",_goodsdataDic[@"buyPension"]];
                if (memberPension==nil || [memberPension isEqualToString:@""] || [memberPension isEqualToString:@"<null>"]) {
                    memberPension=@"0";
                }
                cell.oldAgePensionLabel.text=[NSString stringWithFormat:@"赠送养老金%@",memberPension];
                CGSize oldAgePensionLabelSize=[cell.oldAgePensionLabel.text stringGetSizeWithFont:12];
                NSLog(@"%f",oldAgePensionLabelSize.width);
                cell.oldAgePensionLabel.width=oldAgePensionLabelSize.width;
                cell.expressLabel.text=@"快递：0.00";
                cell.soldNumLabel.text=[NSString stringWithFormat:@"已售：%@",_goodsdataDic[@"virtualBuy"]];
            }
            return cell;
        }else if (indexPath.row==3){
            NSString *ss=@"DescriptionSatateCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ss];
            if (!cell) {
                cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ss];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WITH, 35)];
            //分割线
            UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 1)];
            lineView.backgroundColor=RGBCOLOR(183, 183, 183);
            [view addSubview:lineView];
            //正品保证
            UIView *circleView=[[UIView alloc]initWithFrame:CGRectMake(10, 10, 15, 15)];
            [view addSubview:circleView];
            UIImageView *ima=[[UIImageView alloc]initWithFrame:circleView.bounds];
            ima.image=[UIImage imageNamed:@"circleBtn"];
            [circleView addSubview:ima];
            UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(circleView.frame)+5, 10, SCREEN_WIDTH/6, 15)];
            [view addSubview:label1];
            label1.text=@"正品保证";
            label1.width=[label1.text stringGetSizeWithFont:12].width;
            //            label1.textColor=[UIColor blackColor];
            label1.font=[UIFont systemFontOfSize:12];
            label1.adjustsFontSizeToFitWidth=YES;
            //支持退换货
            UIView *circleView1=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame)+5, 10, 15, 15)];
            [view addSubview:circleView1];
            UIImageView *ima1=[[UIImageView alloc]initWithFrame:circleView.bounds];
            ima1.image=[UIImage imageNamed:@"circleBtn"];
            [circleView1 addSubview:ima1];
            UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(circleView1.frame)+5, 10, SCREEN_WIDTH/6, 15)];
            label2.text=@"支持退换货";
            label2.width=[label2.text stringGetSizeWithFont:12].width;
            //            label2.textColor=[UIColor blackColor];
            label2.font=[UIFont systemFontOfSize:12];
            [view addSubview:label2];
            label2.adjustsFontSizeToFitWidth=YES;
            //赠送费险
            UIView *circleView3=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label2.frame)+5, 10, 15, 15)];
            [view addSubview:circleView3];
            UIImageView *ima3=[[UIImageView alloc]initWithFrame:circleView.bounds];
            ima3.image=[UIImage imageNamed:@"circleBtn"];
            [circleView3 addSubview:ima3];
            UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(circleView3.frame)+5, 10, SCREEN_WIDTH/6, 15)];
            label3.text=@"赠送费险";
            label3.width=[label3.text stringGetSizeWithFont:12].width;
            //            label3.textColor=[UIColor blackColor];
            label3.font=[UIFont systemFontOfSize:12];
            [view addSubview:label3];
            label3.adjustsFontSizeToFitWidth=YES;
            [cell.contentView addSubview:view];
            
            
            label1.textColor = [UIColor grayColor];
            label2.textColor = [UIColor grayColor];
            label3.textColor = [UIColor grayColor];
            return cell;
        }
        
        
        
    }else if(indexPath.section==1){
        //        if (indexPath.row==0) {
        //            NSString *ss=@"DescriptionCel";
        //            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ss];
        //            //            UIImageView *myImageView=[[UIImageView alloc]init];
        //            //            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH-2, 90-20)];
        //            if (!cell) {
        //                cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ss];
        //                cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //                //                view.layer.borderWidth=1;
        //                //                view.layer.borderColor=[UIColor grayColor].CGColor;
        //                //                UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-100, view.height)];
        //                //                la.font=[UIFont fontWithName:@"Gothic-Bold" size:36];
        //                //                la.text=@"选择商品规格";
        //                //                [view addSubview:la];
        //                //                [cell.contentView addSubview:view];
        //                //                myImageView.image=[UIImage imageNamed:@"to_info_mini_gray"];
        //                //                myImageView.contentMode = UIViewContentModeScaleAspectFit;
        //                //               [view addSubview:myImageView];
        //            }
        //            //            myImageView.x=SCREEN_WIDTH-10-15;
        //            //            myImageView.y=(view.height-15)/2;
        //            //            myImageView.width=15;
        //            //            myImageView.height=15;
        //
        //            return cell;
        //        }
        if (indexPath.row==0) {
            NSString *ss=@"DescriptionCel";
            goodsDetailDescriptionEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:ss];
            if (!cell) {
                cell= [[goodsDetailDescriptionEvaluateCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ss];
            }
            cell.ealuateLabel.text=@"商品评价";
            cell.ealuateLabel.width=[cell.ealuateLabel.text stringGetSizeWithFont:20].width;
            NSArray *reviewsArray=[_reviewdataDic objectForKey:@"rows"];
            NSLog(@"%@",reviewsArray);
            if (reviewsArray!=nil) {
                cell.ealuateNumLabel.text=[NSString stringWithFormat:@"(%ld人评论)",(unsigned long)reviewsArray.count];
            }else{
                cell.ealuateNumLabel.text=@"(0人评论)";;
            }
            
            cell.ealuateNumLabel.x=CGRectGetMaxX(cell.ealuateNumLabel.frame);
            NSString *score=[_goodsdataDic objectForKey:@"score"];
            if (score!=nil) {
                cell.rateView.rate=[score floatValue];
                cell.scoreLabel.text=[NSString stringWithFormat:@"%@分",score];
            }else{
                cell.rateView.rate=0;
                cell.scoreLabel.text=@"0分";
            };
            cell.myImageView.image=[UIImage imageNamed:@"to_info_mini_gray"];
            return cell;
        }
    }else if (indexPath.section==2){
        if (indexPath.row==0) {
            NSString *ss=@"GoodsDetailShopCell1";
            GoodsDetailShopCell *cell = [tableView dequeueReusableCellWithIdentifier:ss];
            if (!cell) {
                cell= [[GoodsDetailShopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ss];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell.iconImageView sd_setImageWithURL:[self.shopMessageDic objectForKey:@"logoImg"] placeholderImage:[UIImage imageNamed:@"bg_merchant_photo_placeholder"]];
            CGFloat btnMarginX=(SCREEN_WIDTH-25-100*2)/2;
            UIButton *telToShopBtn=[[UIButton alloc]init];
            telToShopBtn.x=btnMarginX;
            telToShopBtn.y=120-15-30;
            telToShopBtn.width=100;
            telToShopBtn.height=30;
            //    self.telToShopBtn=[[UIButton alloc]initWithFrame:CGRectMake(btnMarginX, CGRectGetMaxY(self.shopAddressLabel.frame)+20, 100, 30)];
            [cell addSubview:telToShopBtn];
            telToShopBtn.userInteractionEnabled=YES;
            telToShopBtn.layer.borderWidth=1;
            telToShopBtn.layer.borderColor=[UIColor redColor].CGColor;
            telToShopBtn.backgroundColor=[UIColor whiteColor];
            [telToShopBtn setTitle:@"联系卖家" forState:UIControlStateNormal];
            [telToShopBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            telToShopBtn.layer.masksToBounds=YES;
            telToShopBtn.layer.cornerRadius=5;
            [telToShopBtn addTarget:self action:@selector(toTelPhone) forControlEvents:UIControlEventTouchUpInside];
            UIButton *goInShopBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(telToShopBtn.frame)+25,telToShopBtn.y, telToShopBtn.width, telToShopBtn.height)];
            goInShopBtn.layer.borderWidth=1;
            goInShopBtn.layer.borderColor=[UIColor redColor].CGColor;
            goInShopBtn.backgroundColor=[UIColor whiteColor];
            [goInShopBtn setTitle:@"进入商家" forState:UIControlStateNormal];
            [goInShopBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            goInShopBtn.layer.masksToBounds=YES;
            goInShopBtn.layer.cornerRadius=5;
            [goInShopBtn addTarget:self action:@selector(toShopDetailViewController) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:goInShopBtn];
            cell.shopNameLabel.text=[self.shopMessageDic objectForKey:@"name"];
            cell.shopAddressLabel.text=[self.shopMessageDic objectForKey:@"address"];
            //            cell.myImageView.image=[UIImage imageNamed:@"to_info_mini_gray"];
            NSLog(@"%@",cell.shopNameLabel.text);
            return cell;
        }
    }
    return nil;
    
}
#pragma mark - 监听tableViewCell点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击cell背景恢复正常状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section ==1){
        
        //查看全部评论
        if (indexPath.row==0) {
            
            if ([[_reviewdataDic objectForKey:@"rows"]count]!=0) {
                [self goToAllEvaluateView];
            }else{
                [self tishi];
            }
            
        }
    }else if (indexPath.section == 0&&indexPath.row==1){
        //        [self moveToSeePhotosDetails];
        
        WebViewController *web = [[WebViewController alloc] init];
        NSString *url = [NSString stringWithFormat:@"goods/load.htm?id=%@",_goodsdataDic[@"id"]];
        web.webUrlStr = NewRequestURL(url);
        web.titleStr = _goodsdataDic [@"title"];
        web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];
        
        
    }
    
    
}
#pragma mark-根据大小化出来一个圆
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==2) {
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        view.backgroundColor=RGBCOLOR(206, 206, 206);
        //view.image = [UIImage imageNamed:@"goodsBase_IM"];
        UILabel *la=[[UILabel alloc]init];
        la.height=view.height-10;
        la.y=5;
        la.text=@"继续拖动查看图文详情";
        la.width=[la.text stringGetSizeWithFont:10].width;
        la.x=(SCREEN_WIDTH-la.width)/2;
        [view addSubview:la];
        la.font=[UIFont systemFontOfSize:10];
        self.maxBottomView=view;
        //左边横线
        UIView *line1=[[UIView alloc]init];
        line1.height=1;
        line1.width=(SCREEN_WIDTH-la.width)/2;
        line1.x=0;
        line1.y=view.height/2-1;
        [view addSubview:line1];
        line1.backgroundColor=[UIColor grayColor];
        //右边横线
        UIView *line2=[[UIView alloc]init];
        line2.height=1;
        line2.width=line1.width;
        line2.x=CGRectGetMaxX(la.frame);
        line2.y=view.height/2-1;
        [view addSubview:line2];
        line2.backgroundColor=[UIColor grayColor];
        return view;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==2) {
        return 30;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==1) {
        return 9;
    }else if (section==2){
        return 9;
    }
    return 1;
}
-(void)goToAllEvaluateView{
    AllEvaluateViewController *allVC = [[AllEvaluateViewController alloc] init];
    allVC.merchant_id = _goodsdataDic[@"merchantId"];;
    allVC.goods_id = _goodsdataDic[@"id"];
    [self.navigationController pushViewController:allVC animated:YES];
}
//去空格
-(NSString *)removeStrings:(NSString *)Str{
    
    Str=  [Str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    Str= [Str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    Str=  [Str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    return Str;
}
//取网址
- (NSArray *)componentsSeparatedFromString:(NSString *)tempStringS :(NSString *)fromString toString:(NSString *)toString
{
    if (!fromString || !toString || fromString.length == 0 || toString.length == 0) {
        return nil;
    }
    NSMutableArray *subStringsArray = [[NSMutableArray alloc] init];
    NSString *tempString = tempStringS;
    NSRange range = [tempString rangeOfString:fromString];
    while (range.location != NSNotFound) {
        tempString = [tempString substringFromIndex:(range.location + range.length)];
        range = [tempString rangeOfString:toString];
        if (range.location != NSNotFound) {
            
            [subStringsArray addObject:[tempString substringToIndex:range.location]];
            
            
            range = [tempString rangeOfString:fromString];
        }
        else
        {
            break;
        }
    }
    return subStringsArray;
}
-(void)tishi{
    //
    //    MyOrderViewController *orderVC = [[MyOrderViewController alloc] init];
    //    orderVC.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:orderVC animated:YES];
    if (!_networkConditionHUD) {
        _networkConditionHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_networkConditionHUD];
    }
    _networkConditionHUD.labelText = @"暂无评论";
    _networkConditionHUD.mode = MBProgressHUDModeText;
    _networkConditionHUD.yOffset = APP_HEIGHT/2 - HUDBottomH-200;
    _networkConditionHUD.margin = HUDMargin;
    [_networkConditionHUD show:YES];
    [_networkConditionHUD hide:YES afterDelay:HUDDelay];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)toShopDetailViewController{
    ShopDetailViewController *view = [[ShopDetailViewController alloc]init];
    
    view.panduan = @"1";
    view.merChantID = _goodsdataDic[@"merchantId"];
    [self.navigationController pushViewController:view animated:YES];
}
#pragma mark-拖动查看图文详情
-(void)moveToSeePhotosDetails{
    GoodsDetailWebVC *detailWebVC = [[GoodsDetailWebVC alloc] init];
    
    
    NSString *url = [NSString stringWithFormat:@"goods/load.htm?id=%@",self.goods_id];
    detailWebVC.webUrlStr = NewRequestURL(url);
    detailWebVC.goodsDic = _goodsdataDic;
    if ([self.className isEqual:@"nima"]) {
        detailWebVC.merchant_id =_parm[@"merchant_id"];
    }else {
        detailWebVC.merchant_id =_goodsdataDic[@"merchantId"];
    }
    detailWebVC.shangPan = _goodsdataDic[@"id"];
    
    detailWebVC.their_type = _goodsdataDic[@"their_type"];
    NSLog( @"---abcd--%@",_goodsdataDic[@"merchantId"]);
     [self.navigationController pushViewController:detailWebVC animated:YES];
   // [self presentViewController:detailWebVC animated:YES completion:nil];
    //    myTable.height+=SCREEN_HEIGHT;
    //    detailWebVC.view.frame=CGRectMake(0, CGRectGetMaxY(myTable.frame), SCREEN_WIDTH, SCREEN_HEIGHT);
    //    [myTable addSubview:detailWebVC.view];
}
//#pragma mark-GoodsDetailShopCellDelegate代理方法
//-(void)GoodsDetailShopCellTelToShopBtnDidClick:(GoodsDetailShopCell *)cell{
//    [self toTelPhone];
//}
//-(void)GoodsDetailShopCellGoInShopBtnDidClick:(GoodsDetailShopCell *)cell{
//    [self toShopDetailViewController];
//}
#pragma mark-轮播视图的代理方法
-(void)pusSomeViewConllerWithTag:(NSInteger)tag{
    //    PhontViewController *vc=[[PhontViewController alloc]init];
    //    vc.photoArr=self.photoUrlArray;
    //    vc.photoIndex=tag;
    //    [self.navigationController pushViewController:vc animated:YES ];;
    //启动图片浏览器
    HZPhotoBrowser *browserVC = [[HZPhotoBrowser alloc] init];
    browserVC.sourceImagesContainerView = self.view; // 原图的父控件
    browserVC.imageCount = self.photoUrlArray.count; // 图片总数
    browserVC.currentImageIndex =(int)tag;
    browserVC.delegate = self;
    [browserVC show];
}
#pragma mark - photobrowser代理方法
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView=[[UIImageView alloc]init];
    [imageView sd_setImageWithURL:[self.photoUrlArray objectAtIndex:index] placeholderImage:[UIImage imageNamed:@"bg_merchant_photo_placeholder"]];
    return imageView.image;
}

- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    
    return [self.photoUrlArray objectAtIndex:index];
}

- (NSString *)photoBrowser:(HZPhotoBrowser *)browser titleStringForIndex:(NSInteger)index {
    //    NSDictionary *dic = _typeImgsArray [index];
    //    NSString *titleStr = dic [@"album_title"];
    return nil;
}
-(void)myShar:(UIButton *)btn{
    
    
        //未安装时隐藏
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline]];
        
        //SDK4.2默认分享面板已经处理过是否隐藏
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:UM_Appkey
                                          shareText:@"积分宝平台http://a.app.qq.com/o/simple.jsp?pkgname=com.jfb315"
                                         shareImage:[UIImage imageNamed:@"app_icon.png"]
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone, nil]
                                           delegate:self];
        
        [UMSocialData defaultData].extConfig.wechatSessionData.title = @"积分宝平台";
        [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.jfb315";
        //    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"积分宝平台";
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.jfb315";
        
        [UMSocialData defaultData].extConfig.qqData.title = @"积分宝平台";
        [UMSocialData defaultData].extConfig.qqData.url = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.jfb315";
        [UMSocialData defaultData].extConfig.qzoneData.title = @"积分宝平台";
        [UMSocialData defaultData].extConfig.qzoneData.url = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.jfb315";
    
   
}
@end
