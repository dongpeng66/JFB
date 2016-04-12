//
//  ShopDetailViewController.m
//  JFB
//
//  Created by JY on 15/8/29.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "ShopDetailHeadCell.h"
#import "ShopDetailAddressCell.h"
#import "ShopDetailVoucherCell.h"
#import "ShopDetailGoodsCel.h"
#import "ShopDetailEvaluateCell.h"
#import "HomeShopListCell.h"
#import "DetailBottomNextCell.h"
#import "DJQRateView.h"
#import "GoodsDetailViewController.h"
#import "AllEvaluateViewController.h"
#import "MerchantAlbumListViewController.h"
#import "ShopMapNavigationViewController.h"
#import "ShopListVC.h"
#import "LoginViewController.h"
#import "TSFShopDetailHeadView.h"
#import "HeadTSFViewCell.h"
#define HeadCell    @"shopDetailHeadCell"   
#define AddressCell    @"shopDetailAddressCell"
#define VoucherCell    @"shopDetailVoucherCell"
#define GoodsCell    @"shopDetailGoodsCell"
#define EvaluateCell    @"shopDetailEvaluateCell"
#define BottomNextCell      @"detailBottomNextCell"
#define kTableViewCelllIdentifier      @"HomeShopCell"
#import "AppDelegate.h"
#import "WKProgressHUD.h"

#define myw [UIScreen mainScreen ].bounds.size.width
#define myh 210
@interface ShopDetailViewController () <UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{

    
    NSArray *_goodsdataArray;    //商品信息数组
    NSArray *_recommendmerchantdataArray;    //附近商户数组
    NSDictionary *_reviewdataDic;    //评论数据字典
    
    NSString *flagStr; //收藏1，取消收藏2
    
    UIView *navView;
   long  int index;
    BOOL panDuan;

    
    TSFShopDetailHeadView *_view;
    
    UIButton *zhankai;
    
    
    NSString *picturecount;
    
    int  total;
   
    WKProgressHUD *_hud;
    MYAlertView *myalertView ;
    
    
    
}
@property (nonatomic,strong) WKProgressHUD *hud;
@end 

@implementation ShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.view.backgroundColor = [UIColor redColor];
    self.title = @"";

   
   
 
    //获取商户详情
    
     [self requestGetMerchantDetail];
    
    [self addMyTableView];
    [self.myTableView registerNib:[UINib nibWithNibName:@"ShopDetailHeadCell" bundle:nil] forCellReuseIdentifier:HeadCell];
    [self.myTableView registerNib:[UINib nibWithNibName:@"ShopDetailAddressCell" bundle:nil] forCellReuseIdentifier:AddressCell];
    [self.myTableView registerNib:[UINib nibWithNibName:@"ShopDetailVoucherCell" bundle:nil] forCellReuseIdentifier:VoucherCell];
    [self.myTableView registerNib:[UINib nibWithNibName:@"ShopDetailGoodsCel" bundle:nil] forCellReuseIdentifier:GoodsCell];
    [self.myTableView registerNib:[UINib nibWithNibName:@"ShopDetailEvaluateCell" bundle:nil] forCellReuseIdentifier:EvaluateCell];
    [self.myTableView registerNib:[UINib nibWithNibName:@"DetailBottomNextCell" bundle:nil] forCellReuseIdentifier:BottomNextCell];
    [self.myTableView registerNib:[UINib nibWithNibName:@"HomeShopListCell" bundle:nil] forCellReuseIdentifier:kTableViewCelllIdentifier];
    
    [self SetLayerWithBtn:self.typeBtn1];
    [self SetLayerWithBtn:self.typeBtn2];
    [self SetLayerWithBtn:self.typeBtn3];
    [self SetLayerWithBtn:self.typeBtn4];
    
   
    
    //获取推荐商户
    [self getMerchantListWtih:_cityName withCityAreaName:_cityName1];
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
      [self myHeadView];
  
     _leftBtn.frame = CGRectMake(myw*.02, 15, myw*.15, myh*.2);
    //_leftBtn.backgroundColor = [UIColor blueColor];
    [_leftBtn setImage:[UIImage imageNamed:@"FH_1"] forState:UIControlStateNormal];
    _leftBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.leftBtn addTarget:self action:@selector(pophViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.myHview addSubview:_leftBtn];
//
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.contentMode = UIViewContentModeScaleAspectFit;
    _rightBtn.frame = CGRectMake(myw*.82, 15, myw*.15, myh*.2);
    //_leftBtn.backgroundColor = [UIColor blueColor];
   
    [self.rightBtn setImage:[UIImage imageNamed:@"SC_1"] forState:UIControlStateSelected];
    [self.rightBtn setImage:[UIImage imageNamed:@"WSC_1"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(toFavoritxxe:) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.myHview addSubview:_rightBtn];
  
    
    self.jianBian.alpha = 0;
    panDuan = YES;
    picturecount = @"0";
  
    
}
-(void)myHeadView{
    _jianBian = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    _jianBian.backgroundColor = [UIColor redColor];
    _jianBian.alpha = 0.0;
    [self.view addSubview:_jianBian];
    _myHview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [self.view addSubview: _myHview];
}
-(void)addMyTableView{
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -2, SCREEN_WIDTH, SCREEN_HEIGHT+2) style:UITableViewStyleGrouped];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
  

    float f=scrollView.contentOffset.y;
    NSLog(@"%f",f);
    if (f>100) {
      self.jianBian.alpha +=.02;
        if(f>111){
            [_leftBtn setImage:[UIImage imageNamed:@"FH_2"] forState:UIControlStateNormal];
            [self.rightBtn setImage:[UIImage imageNamed:@"SC_2"] forState:UIControlStateSelected];
            [self.rightBtn setImage:[UIImage imageNamed:@"WSC_2"] forState:UIControlStateNormal];
        }
        
    }
    if (f<100) {
        self.jianBian.alpha =0;
        [_leftBtn setImage:[UIImage imageNamed:@"FH_1"] forState:UIControlStateNormal];
        [self.rightBtn setImage:[UIImage imageNamed:@"SC_1"] forState:UIControlStateSelected];
        [self.rightBtn setImage:[UIImage imageNamed:@"WSC_1"] forState:UIControlStateNormal];
    }
}

#pragma mark - 返回
-(void)pophViewController{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   // self.navigationController.navigationBar.translucent = NO;
     [self.navigationController setNavigationBarHidden:NO animated:NO];
     self.navigationController.navigationBar.translucent = NO;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }

}
-(void)viewDidDisappear:(BOOL)animated{
    if (_frameBool) {
        self.navigationController.navigationBar.translucent = YES;
    }
}
-(WKProgressHUD *)hud{
    if (!_hud) {
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        _hud = [WKProgressHUD showInView:app.window withText:nil animated:YES];
    }
    return _hud;
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   
    if (!myalertView) {
        myalertView = [[MYAlertView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:myalertView];
    }
    
   
     [self.myTableView reloadData];

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

-(void)SetLayerWithBtn:(UIButton *)btn {
    btn.layer.cornerRadius = 5;
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btn.layer.borderWidth = 1;
}

-(void)toMapView {
    ShopMapNavigationViewController *mapVC = [[ShopMapNavigationViewController alloc] init];
//    mapVC.latitudeStr = self.merchantdataDic [@"latitude"];
//    mapVC.longitudeStr = self.merchantdataDic [@"longitude"];
    mapVC.shopDic = self.merchantdataDic;
    [self.navigationController pushViewController:mapVC animated:YES];
}

-(void)toFavoritxxe:(UIButton *)btn {
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
    if(btn.selected==YES){
        btn.selected=NO;
    }else {
        btn.selected=YES;
    }

    
    [self requestCollectSubmit];
}

-(void)toTelPhone {
    NSString *phoneString = self.merchantdataDic [@"tel"];
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneString];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

#pragma mark - 跳转到商家相册
-(void)merchantAlbumList {
    
  
    
    if ([self.merchantdataDic [@"picturecount"] intValue] > 0) {
        MerchantAlbumListViewController *albumVC = [[MerchantAlbumListViewController alloc] init];
        
        NSLog(@"---%@",_merchantdataDic);
        albumVC.merchant_id = self.merchantdataDic [@"merchant_id"];
        
        
        
        [self.navigationController pushViewController:albumVC animated:YES];
    }
    else {
        
      //  [self ballReminder:@"商家暂无图片"];
         [myalertView show:@"商家暂无图片"];
    }
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (! [_goodsdataArray isKindOfClass:[NSNull class]]) {  //显示评价列
        return 6;
    }
    else {                                  //不显示评价列及代金券列
        return 4;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     if (! [_goodsdataArray isKindOfClass:[NSNull class]]) {  //显示评价列
        switch (section) {
            case 0:
                return 1;
                break;
                
            case 1:
                return 1;
                break;
                
            case 2:
                return index;
                break;
                
            case 3:
                return 1;
                break;
                
            case 4:  //评价
                return 2;
                break;
                
            case 5:
                if ([_recommendmerchantdataArray count] > 0) {
                    return [_recommendmerchantdataArray count];
                }
                return 1;
                break;
                
            default:
                break;
        }
        return 0;
     }
     else {                 //不显示评价列
         switch (section) {
             case 0:
                 return 1;
                 break;
                 
             case 1:
                 return 1;
                 break;
                 
//             case 2:     //没有代金券
//                 return 1;
//                 break;
                 
             case 2:
                 return 1;
                 break;
                 
             case 3:
                 if ([_recommendmerchantdataArray count] > 0) {
                     return [_recommendmerchantdataArray count];
                 }
                 return 1;
                 break;
                 
             default:
                 break;
         }
         return 0;
     }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (! [_goodsdataArray isKindOfClass:[NSNull class]]) {  //显示评价列
        switch (indexPath.section) {
            case 0:
                return 210;
                break;
                
            case 1:
                return 55;
                break;
                
            case 2:  //代金券
                return 100;
                break;
                
            case 3: {
                UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
                NSLog(@"%f",cell.bounds.size.height);
                return cell.bounds.size.height;
            }
                break;
                
            case 4: {  //评价
                if (indexPath.row == 0) {
                    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
                    NSLog(@"%f",cell.bounds.size.height);
                    return cell.bounds.size.height;
                }
                else if (indexPath.row == 1)  {
                    return 44;
                }
            }
                break;
                
            case 5:
                return 100;
                break;
                
            default:
                break;
        }
        return 0;
    }
    else {                  //不显示评价列
        switch (indexPath.section) {
            case 0:
                return 210;
                break;
                
            case 1:
                return 55;
                break;
                
//            case 2:  //代金券
//                return 100;
//                break;
                
            case 2: {
                UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
                NSLog(@"%f",cell.bounds.size.height);
                return cell.bounds.size.height;
            }
                break;
                
            case 3:
                return 100;
                break;
                
            default:
                break;
        }
        return 0;
    }
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//   
//    if (section==2) {
//    
//    if([_goodsdataArray count]>3){
//        return 52;
//    }else{
//        return 8;
//    }
//}
//    return 8;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==2) {
        if (_goodsdataArray.count>2) {
            return 54;
        }
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   if (! [_goodsdataArray isKindOfClass:[NSNull class]]) {  //显示评价列
        switch (section) {
            case 0:
                return 1;
                break;
                
            case 1:
                return 1;
                break;
                
            case 2:
                return 44;
                break;
                
            case 3:
                return 44;
                break;
                
            case 4:
                return 44;
                break;
                
            case 5:
                return 44;
                break;
                
            default:
                break;
        }
        return 0;
    }
    else {                  //不显示评价列
        switch (section) {
            case 0:
                return 1;
                break;
                
            case 1:
                return 1;
                break;
                
//            case 2:
//                return 44;
//                break;
                
            case 2:
                return 44;
                break;
                
            case 3:
                return 80;
                break;
                
            default:
                break;
        }
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (! [_goodsdataArray isKindOfClass:[NSNull class]]) {  //显示评价列
        switch (indexPath.section) {
            case 0: {
                
                static  NSString *ss=@"HeadTSFViewCell";
                
                HeadTSFViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ss];
                
                if(!cell){
                    
                    cell=[[HeadTSFViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ss];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                
        //折扣
        NSString *str1 = [NSString stringWithFormat:@"%@",self.merchantdataDic [@"discountRaito"]];
                
                
                NSLog(@"------%@--a---",str1);
        if([str1 isEqual:@"<null>"]||[str1 isEqual:@""]||[str1  isEqual: @"(null)"]){
            
                    cell.zhekouL.text=@"";
            }else{
           cell.zhekouL.text = [NSString stringWithFormat:@"%@折", self.merchantdataDic [@"discountRaito"]];
            }

                cell.nameL.text = self.merchantdataDic[@"merchant_name"];
                float fraction = [self.merchantdataDic[@"fraction"] floatValue]*100;

                cell.jifenL.text =[NSString stringWithFormat:@"积分率:%.2f%%",fraction];
                 [cell.bigIM sd_setImageWithURL:[NSURL URLWithString:self.merchantdataDic [@"background"]] placeholderImage:IMG(@"bg_merchant_photo_placeholder")];
            
                cell.imgsBtn.tag =77881;
                
                [cell.imgsBtn addTarget:self action:@selector(merchantAlbumList) forControlEvents:UIControlEventTouchUpInside];
               [cell.imgsBtn setTitle:[NSString stringWithFormat:@"%@张", picturecount] forState:UIControlStateNormal];
        
                NSLog(@"-------%@",_merchantdataDic[@"picturecount"]);


                return cell;
                
            }
                break;
                
            case 1: {
                ShopDetailAddressCell *cell = (ShopDetailAddressCell *)[tableView dequeueReusableCellWithIdentifier:AddressCell];
                cell.addressL.text = self.merchantdataDic [@"address"];
                [cell.mapAddressBtn addTarget:self action:@selector(toMapView) forControlEvents:UIControlEventTouchUpInside];
                NSString *phoneString = self.merchantdataDic [@"tel"];
                if (! [phoneString isKindOfClass:[NSNull class]]) {
                    cell.phoneViewWidthCons.constant = 62;
                    [cell.phoneBtn addTarget:self action:@selector(toTelPhone) forControlEvents:UIControlEventTouchUpInside];
                }
                else {
                    cell.phoneViewWidthCons.constant = 0;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
                break;
                
            case 2: {
                ShopDetailVoucherCell *cell = (ShopDetailVoucherCell *)[tableView dequeueReusableCellWithIdentifier:VoucherCell];
                
                NSDictionary *dic = _goodsdataArray [indexPath.row];
                
                cell.emptyL.hidden = YES;
                cell.voucherView.hidden = NO;
                [cell.voucherIM sd_setImageWithURL:[NSURL URLWithString:dic [@"goodsImages"]] placeholderImage:IMG(@"bg_merchant_photo_placeholder")];
                
                cell.nameL.text = dic [@"goodsName"];
                cell.priceL.text = [NSString stringWithFormat:@"¥%@元",dic[@"buyPrice"]];
                cell.costPriceStrikeL.text = [NSString stringWithFormat:@"%@元",dic[@"marketPrice"]];
                cell.saleL.text = [NSString stringWithFormat:@"已售:%@",dic[@"virtualBuy"]];

                return cell;
            }
                break;
                
            case 3: {
                ShopDetailGoodsCel *cell = (ShopDetailGoodsCel *)[tableView dequeueReusableCellWithIdentifier:GoodsCell];
                NSString *merchant_info = self.merchantdataDic [@"merchant_info"];
                if ([merchant_info isEqualToString:@""]) {
                    cell.emptyL.hidden = NO;
                    cell.contentL.hidden = YES;
                }
                else {
                    cell.emptyL.hidden = YES;
                    cell.contentL.hidden = NO;
                    cell.contentL.text = merchant_info;
                }
                [cell.contentL sizeToFit];
                CGRect rect = cell.bounds;
                rect.size.height = 8 + cell.contentL.bounds.size.height + 8 + 21;
                cell.bounds = rect;
                
                return cell;
            }
                break;
                
            case 4: {
                if (indexPath.row == 0) {
                    if ([_reviewdataDic [@"total"] intValue] > 0) {
                        ShopDetailEvaluateCell *cell = (ShopDetailEvaluateCell *)[tableView dequeueReusableCellWithIdentifier:EvaluateCell];
                        
                        NSArray *arr = _reviewdataDic [@"datas"];
                        NSDictionary *dic = arr[arr.count-1];
                       NSString *nickName = dic [@"memberName"];
                        cell.memberNameL.text = [[GlobalSetting shareGlobalSettingInstance] transformToStarStringWithString:nickName];
                        cell.timeL.text = [NSString stringWithFormat:@"%@", dic[@"reviewTime"]];
                        cell.rateView.rate = [dic [@"score"] floatValue];
                        cell.scoreL.text = [NSString stringWithFormat:@"%@分",dic [@"score"]];
                        cell.contentL.text = dic [@"content"];
                        [cell.contentL sizeToFit];
                        CGRect rect = cell.bounds;
                        rect.size.height = 8 + cell.memberNameL.bounds.size.height + 5 + cell.rateView.bounds.size.height + 5 + cell.contentL.bounds.size.height + 8 + 21;
                        cell.bounds = rect;
                        return cell;
                    }
                    else {
                        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.textLabel.textAlignment = NSTextAlignmentCenter;
                        cell.textLabel.font = [UIFont systemFontOfSize:17];
                        cell.textLabel.text = @"暂无数据";
                        return cell;
                    }
                }
                else if (indexPath.row == 1) {
                    DetailBottomNextCell *cell = (DetailBottomNextCell *)[tableView dequeueReusableCellWithIdentifier:BottomNextCell];
                    if (! _reviewdataDic [@"total"]) {
                        cell.nextNoticeL.text = @"查看全部评论";
                    }
                    else {
                        cell.nextNoticeL.text = [NSString stringWithFormat:@"查看全部评论(%@)",_reviewdataDic [@"total"]];
                    }
                    
                    return cell;
                }
            }
                break;
                
            case 5: {
                if ([_recommendmerchantdataArray count] > 0) {
                    NSDictionary *dic = _recommendmerchantdataArray [indexPath.row];
                    HomeShopListCell *cell = (HomeShopListCell *)[tableView dequeueReusableCellWithIdentifier:kTableViewCelllIdentifier];
                    
                    [cell.shopIM sd_setImageWithURL:[NSURL URLWithString:dic[@"background"]] placeholderImage:IMG(@"bg_merchant_photo_placeholder")];
                    cell.shopNameL.text = dic[@"merchant_name"];
                    cell.shopAddressL.text = dic[@"address"];
                    cell.rateView.rate = [dic[@"score"] floatValue];
                    cell.scoreL.text = [NSString stringWithFormat:@"%@分",dic[@"score"]];
                    float fraction = [dic[@"fraction"] floatValue]*100;

                    cell.integralRateL.text = [NSString stringWithFormat:@"%.2f%%",fraction];
                    
                    //折扣
                    NSString *str1 = [NSString stringWithFormat:@"%@", dic[@"discount_ratio"]];
                    if([str1 isEqual:@"<null>"]||[str1 isEqual:@""]||[str1  isEqual: @"(null)"]){
                        cell.discountL.text=@"";
                    }else{
                        cell.discountL.text = [NSString stringWithFormat:@"%@折", dic[@"discount_ratio"]];
                    }

                    float dis = [dic[@"distance"] floatValue];
                    float convertDis = 0;
                    if (dis >= 1000) {
                        convertDis = dis / 1000;
                        cell.distanceL.text = [NSString stringWithFormat:@"%.1fkm",convertDis];
                    }
                    else {
                        cell.distanceL.text = [NSString stringWithFormat:@"%.1fm",dis];
                    }
                    
                    return cell;
                }
                else {
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    cell.textLabel.font = [UIFont systemFontOfSize:17];
                    cell.textLabel.text = @"暂无数据";
                    return cell;
                }
                
            }
                break;
                
            default:
                break;
        }
        
        
        return nil;
    }
    else {              //不显示评价列
        switch (indexPath.section) {
            case 0: {
                
                static  NSString *ss=@"HeadTSFViewCell";
                
                HeadTSFViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ss];
                
                if(!cell){
                    
                    cell=[[HeadTSFViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ss];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                
                //折扣
                NSString *str1 = [NSString stringWithFormat:@"%@",self.merchantdataDic [@"discountRaito"]];
                if([str1 isEqual:@"<null>"]||str1.length<=0||[str1  isEqual: @"(null)"]){
                    cell.zhekouL.text=nil;
                }else{
                    cell.zhekouL.text = [NSString stringWithFormat:@"%@折", self.merchantdataDic [@"discountRaito"]];
                }
                
                cell.nameL.text = self.merchantdataDic[@"merchant_name"];
                float fraction = [self.merchantdataDic[@"fraction"] floatValue]*100;

                cell.jifenL.text =[NSString stringWithFormat:@"积分率:%.2f%%",fraction];
                [cell.bigIM sd_setImageWithURL:[NSURL URLWithString:self.merchantdataDic [@"background"]] placeholderImage:IMG(@"bg_merchant_photo_placeholder")];
                
                cell.imgsBtn.tag =77881;
                
                [cell.imgsBtn addTarget:self action:@selector(merchantAlbumList) forControlEvents:UIControlEventTouchUpInside];
                [cell.imgsBtn setTitle:[NSString stringWithFormat:@"%@张", picturecount] forState:UIControlStateNormal];
                
                
                
                
                return cell;

            }
                break;
                
            case 1: {
                ShopDetailAddressCell *cell = (ShopDetailAddressCell *)[tableView dequeueReusableCellWithIdentifier:AddressCell];
                cell.addressL.text = self.merchantdataDic [@"address"];
                [cell.mapAddressBtn addTarget:self action:@selector(toMapView) forControlEvents:UIControlEventTouchUpInside];
                NSString *phoneString = self.merchantdataDic [@"tel"];
                if (! [phoneString isKindOfClass:[NSNull class]]) {
                    cell.phoneViewWidthCons.constant = 62;
                    [cell.phoneBtn addTarget:self action:@selector(toTelPhone) forControlEvents:UIControlEventTouchUpInside];
                }
                else {
                    cell.phoneViewWidthCons.constant = 0;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
                break;
            
                
            case 2: {
                ShopDetailGoodsCel *cell = (ShopDetailGoodsCel *)[tableView dequeueReusableCellWithIdentifier:GoodsCell];
                NSString *merchant_info = self.merchantdataDic [@"merchant_info"];
                if ([merchant_info isEqualToString:@""]) {
                    cell.emptyL.hidden = NO;
                    cell.contentL.hidden = YES;
                }
                else {
                    cell.emptyL.hidden = YES;
                    cell.contentL.hidden = NO;
                    cell.contentL.text = self.merchantdataDic [@"merchant_info"];
                }
                [cell.contentL sizeToFit];
                CGRect rect = cell.bounds;
                rect.size.height = 8 + cell.contentL.bounds.size.height + 8 + 21;
                cell.bounds = rect;
                
                return cell;
            }
                break;
                
            case 3: {
                if ([_recommendmerchantdataArray count] > 0) {
                    NSDictionary *dic = _recommendmerchantdataArray [indexPath.row];
                    HomeShopListCell *cell = (HomeShopListCell *)[tableView dequeueReusableCellWithIdentifier:kTableViewCelllIdentifier];
                    
                    [cell.shopIM sd_setImageWithURL:[NSURL URLWithString:dic[@"merchant_logo"]] placeholderImage:IMG(@"bg_merchant_photo_placeholder")];
                    cell.shopNameL.text = dic[@"merchant_name"];
                    cell.shopAddressL.text = dic[@"address"];
                    cell.rateView.rate = [dic[@"score"] floatValue];
                    cell.scoreL.text = [NSString stringWithFormat:@"%@分",dic[@"score"]];
                    float fraction = [dic[@"fraction"] floatValue]*100;

                    cell.integralRateL.text = [NSString stringWithFormat:@"%.2f%%",fraction];
                    //折扣
                    NSString *str1 = [NSString stringWithFormat:@"%@", dic[@"discount_ratio"]];
                    if([str1 isEqual:@"<null>"]||str1.length<=0||[str1  isEqual: @"(null)"]){
                        cell.discountL.text=nil;
                    }else{
                        cell.discountL.text = [NSString stringWithFormat:@"%@折", dic[@"discount_ratio"]];
                    }
                    

                    float dis = [dic[@"distance"] floatValue];
                    float convertDis = 0;
                    if (dis >= 1000) {
                        convertDis = dis / 1000;
                        cell.distanceL.text = [NSString stringWithFormat:@"%.1fkm",convertDis];
                    }
                    else {
                        cell.distanceL.text = [NSString stringWithFormat:@"%.1fm",dis];
                    }
                    
                    return cell;
                }
                else {
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    cell.textLabel.font = [UIFont systemFontOfSize:17];
                    cell.textLabel.text = @"暂无数据";
                    return cell;
                }

            }
                break;
                
            default:
                break;
        }
        
        
        return nil;
    }
}
-(void)buttonShou{
    
    if (panDuan==YES) {
        index = _goodsdataArray.count ;
        [self.myTableView reloadData];
    
        panDuan=NO;
    }else if (panDuan==NO){
        index = 2 ;
        [self.myTableView reloadData];
       panDuan=YES;
   }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==2) {
        
        if([_goodsdataArray count]>2){
          
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 52)];
           // view.backgroundColor = [UIColor redColor];
            
            
           zhankai = [UIButton buttonWithType:UIButtonTypeCustom];
            zhankai.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
            zhankai.backgroundColor = [UIColor whiteColor];
            [zhankai setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [zhankai setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];

            if(panDuan ==YES){
                [zhankai setTitle:@"展开全部商品" forState:UIControlStateNormal];
            }else if (panDuan==NO){
                [zhankai setTitle:@"收回全部商品" forState:UIControlStateNormal];

            }
            
            [zhankai addTarget:self action:@selector(buttonShou) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:zhankai];
            return view;
        }else {
            return nil;
        }
}
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (! [_goodsdataArray isKindOfClass:[NSNull class]]) {  //显示评价列
        switch (section) {
            case 0:
                return nil;
                break;
                
            case 1:
                return nil;
                break;
                
            case 2: {
                UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
                headView.backgroundColor = [UIColor whiteColor];
                UILabel *noticeL = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH - 16, 44)];
                noticeL.textColor = [UIColor grayColor];
                noticeL.text = [NSString stringWithFormat:@"商家商品(%lu)",(unsigned long)[_goodsdataArray count]];
                [headView addSubview:noticeL];
                UILabel *lineL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
                lineL.backgroundColor = Cell_sepLineColor;
                [headView addSubview:lineL];
                return headView;
            }
                break;
                
            case 3: {
                UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
                headView.backgroundColor = [UIColor whiteColor];
                UILabel *noticeL = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH - 16, 44)];
                noticeL.textColor = [UIColor grayColor];
                noticeL.text = @"商家详情";
                [headView addSubview:noticeL];
                UILabel *lineL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
                lineL.backgroundColor = Cell_sepLineColor;
                [headView addSubview:lineL];
                return headView;
            }
                break;
                
            case 4: {
                UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
                headView.backgroundColor = [UIColor whiteColor];
                
                UILabel *noticeL = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 80, 44)];
                noticeL.textColor = [UIColor grayColor];
                noticeL.text = @"用户评价";
                [headView addSubview:noticeL];
                NSArray *arr =_reviewdataDic [@"datas"];
                NSDictionary *dic;
                if (arr.count>0) {
                      dic = arr[arr.count-1];
                }
               
                
                DJQRateView *rateView = [[DJQRateView alloc] initWithFrame:CGRectMake(headView.frame.size.width*.61, 12, 100, 20)];
                
                
                float rate = [dic [@"score"] floatValue];
                
                if (rate<0) {
                    rate=0;
                }
                rateView.rate = [dic [@"score"] floatValue];
               // rateView.backgroundColor = [UIColor redColor];
                [headView addSubview:rateView];
                
                UILabel *scoreL = [[UILabel alloc] initWithFrame:CGRectMake(headView.frame.size.width*.85, 0, 60, 44)];
                //scoreL.backgroundColor = [UIColor redColor];
                scoreL.textColor = RGBCOLOR(255, 116, 0);
                scoreL.textAlignment = NSTextAlignmentCenter;
                NSLog(@"%f",rate);
                if (rate<=0) {
                     scoreL.text = [NSString stringWithFormat:@"0"];
                }else{
                     scoreL.text = [NSString stringWithFormat:@"%@",dic[@"score"]];
                }
                [headView addSubview:scoreL];
                
                UILabel *lineL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
                lineL.backgroundColor = Cell_sepLineColor;
                [headView addSubview:lineL];
                
                return headView;
            }
                break;
                
            case 5: {
                _nearbyHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
                UILabel *lineL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
                lineL.backgroundColor = Cell_sepLineColor;
                
                UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, 42)];
                lab.backgroundColor = [UIColor whiteColor];
                lab.text = @"  商家推荐";
                lab.textColor = [UIColor grayColor];
                [_nearbyHeadView addSubview:lab];
                [self.nearbyHeadView addSubview:lineL]; 
                
                return self.nearbyHeadView;
            }
                break;
                
            default:
                break;
        }
        return nil;
    }
    else {          //不显示评价列
        switch (section) {
            case 0:
                return nil;
                break;
                
            case 1:
                return nil;
                break;
            
            case 2: {
                UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
                headView.backgroundColor = [UIColor whiteColor];
                UILabel *noticeL = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH - 16, 44)];
                noticeL.textColor = [UIColor grayColor];
                noticeL.text = @"商家详情";
                [headView addSubview:noticeL];
                
                UILabel *lineL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
                lineL.backgroundColor = Cell_sepLineColor;
                [headView addSubview:lineL];
                
                return headView;
            }
                break;
                
            case 3: {
                UILabel *lineL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
                lineL.backgroundColor = Cell_sepLineColor;
                [self.nearbyHeadView addSubview:lineL];
                
                return self.nearbyHeadView;
            }
            case 4: {
                UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
                headView.backgroundColor = [UIColor whiteColor];
                
                UILabel *noticeL = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 80, 44)];
                noticeL.textColor = [UIColor grayColor];
                noticeL.text = @"用户评价";
                [headView addSubview:noticeL];
                NSArray *arr =_reviewdataDic [@"datas"];
                NSDictionary *dic;
                if (arr.count>0) {
                    dic = arr[arr.count-1];
                }
                
                
                DJQRateView *rateView = [[DJQRateView alloc] initWithFrame:CGRectMake(headView.frame.size.width*.61, 12, 100, 20)];
                
                
                float rate = [dic [@"score"] floatValue];
                
                if (rate<0) {
                    rate=0;
                }
                rateView.rate = [dic [@"score"] floatValue];
                // rateView.backgroundColor = [UIColor redColor];
                [headView addSubview:rateView];
                
                UILabel *scoreL = [[UILabel alloc] initWithFrame:CGRectMake(headView.frame.size.width*.85, 0, 60, 44)];
                //scoreL.backgroundColor = [UIColor redColor];
                scoreL.textColor = RGBCOLOR(255, 116, 0);
                scoreL.textAlignment = NSTextAlignmentCenter;
                scoreL.text = [NSString stringWithFormat:@"0"];
                [headView addSubview:scoreL];
                
                UILabel *lineL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
                lineL.backgroundColor = Cell_sepLineColor;
                [headView addSubview:lineL];
                
                return headView;

            
            }
                break;
                
            default:
                break;
        }
        return nil;
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


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (! [_goodsdataArray isKindOfClass:[NSNull class]]) {  //显示评价列
        if (indexPath.section == 2) {   //商品
            NSDictionary *dic = _goodsdataArray [indexPath.row];
            
            GoodsDetailViewController *detailVC = [[GoodsDetailViewController alloc] init];
            detailVC.goods_id = dic [@"id"];
           // detailVC.fraction = [NSString stringWithFormat:@"%@",self.merchantdataDic [@"fraction"]];
           // detailVC.merchant_id = self.merchantdataDic [@"merchant_id"];
            
            detailVC.prilcText =dic[@"salesPrice"];
            detailVC.usedprilcText = dic[@"marketPrice"];
            detailVC.saleText = dic[@"sales"];
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        else if (indexPath.section == 4) {  //评价
            if (indexPath.row == 1) {
                //全部评价列表页
                AllEvaluateViewController *allVC = [[AllEvaluateViewController alloc] init];
                allVC.merchant_id = self.merchantdataDic [@"merchant_id"];
                allVC.goods_id = @"";  //商户详情点击进入，商品ID传@""
                [self.navigationController pushViewController:allVC animated:YES];
            }
        }
        else if (indexPath.section == 5) {
            if ([_recommendmerchantdataArray count] > 0) {
                NSDictionary *dic = _recommendmerchantdataArray [indexPath.row];
                ShopDetailViewController *detailVC = [[ShopDetailViewController alloc] init];
                detailVC.merchantdataDic = dic;
                detailVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:detailVC animated:YES];
            }
        }
    }
    else {                      //不显示评价列
        if (indexPath.section == 3) {
            if ([_recommendmerchantdataArray count] > 0) {
                NSDictionary *dic = _recommendmerchantdataArray [indexPath.row];
                ShopDetailViewController *detailVC = [[ShopDetailViewController alloc] init];
                detailVC.merchantdataDic = dic;
                detailVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:detailVC animated:YES];
            }
        }
    }

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (IBAction)typesBtnAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    int codeInt = (int)btn.tag - 1000;
    if (codeInt == 2000) {  //全部
        ShopListVC *listVC = [[ShopListVC alloc] init];
        listVC.menu_subtitle = @"全部分类";
        listVC.menu_code = @"";
        listVC.typeID = @"";
        [listVC.typeBtn setTitle:@"全部分类" forState:UIControlStateNormal];
        [self.navigationController pushViewController:listVC animated:YES];
        
    }
    else {
        ShopListVC *listVC = [[ShopListVC alloc] init];
        listVC.menu_subtitle = btn.currentTitle;
        listVC.menu_code = [NSString stringWithFormat:@"%d",codeInt];
        listVC.typeID = [NSString stringWithFormat:@"%d",codeInt];
        [listVC.typeBtn setTitle:btn.currentTitle forState:UIControlStateNormal];
        [self.navigationController pushViewController:listVC animated:YES];
    }

}


#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 4040) {
        if (buttonIndex == 1) {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            loginVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }
}

#pragma mark - 发送请求
-(void)requestGetMerchantDetail { //获取商户详情
    
    
    [self.hud show:YES];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:GetMerchantDetailInfo object:nil];
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:GetMerchantDetailInfo, @"op", nil];
    
     NSString *token = [NSString stringWithFormat:@"%@",[[GlobalSetting shareGlobalSettingInstance] pension]];
    if (token==nil) {
        token =@"";
    }
    
    
    NSString *merchant_id = self.merchantdataDic [@"merchant_id"];//从商家列表进入
    
    if ([_panduan  isEqual: @"1"]) {//从首页至商品详情在进入
        merchant_id = _merChantID;
        
        
    }
    
    NSString *url = [NSString stringWithFormat:@"shop/get.json?shopId=%@&token=%@",merchant_id,token];
    
    NSLog(@"-------------%@---%@",merchant_id,token);
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL(url) delegate:nil params:nil info:infoDic];
    
}
#pragma mark - 获取商户列表
-(void)requestGetRecommendShopListWithLocationDic:(NSDictionary *)dic { //获取推荐商户列表
 //[_hud show:YES];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestShopListData:) name:GetMerchantList object:nil];
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:GetMerchantList, @"op", nil];
    
    NSString *url = [NSString stringWithFormat:@"shop/around.htm?lon=%@&lat=%@&limit=10&page=1&sortrule=distance",[dic objectForKey:@"longitude"],[dic objectForKey:@"latitude"]];
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL(url) delegate:nil params:nil info:infoDic];
}
-(void)didFinishedRequestShopListData:(NSNotification *)notification{
  //[_hud dismiss:YES];
    if ([[notification.userInfo valueForKey:@"RespResult"] isEqualToString:ERROR]) {
//        _networkConditionHUD.labelText = [notification.userInfo valueForKey:@"ContentResult"];
//        [_networkConditionHUD show:YES];
//        [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        return;
    }
    NSDictionary *responseObject = [[NSDictionary alloc] initWithDictionary:[notification.userInfo objectForKey:@"RespData"]];
    NSLog(@"GetMerchantDetailInfo_: %@",responseObject);
                if ([notification.name isEqualToString:GetMerchantList]) {
                [[NSNotificationCenter defaultCenter] removeObserver:self name:GetMerchantList object:nil];
                NSLog(@"GetMerchantList_responseObject: %@",responseObject);
               _recommendmerchantdataArray = @[]; //置空数组
                
                if ([responseObject[@"code"] intValue] == 0) {
                    _recommendmerchantdataArray = responseObject[DATA];
                }
                else {
//                    _networkConditionHUD.labelText = [responseObject objectForKey:MSG];
//                    [_networkConditionHUD show:YES];
//                    [_networkConditionHUD hide:YES afterDelay:HUDDelay];
                }
                [self.myTableView reloadData];
      
        }
}
#pragma mark - 收藏取消收藏
-(void)requestCollectSubmit { //收藏或取消收藏
     if ([flagStr isEqualToString:@"1"]) {
         [myalertView yesAndNo:@"收藏中。。。"];
     }else if ([flagStr isEqualToString:@"2"]) {
         [myalertView yesAndNo:@"取消收藏中。。。"];
     }
//    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:SubmitCollect object:nil];
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:SubmitCollect, @"op", nil];
  
     NSString *token = [NSString stringWithFormat:@"%@",[[GlobalSetting shareGlobalSettingInstance] pension]];
    NSString *url;
    
    if ([flagStr isEqualToString:@"1"]) {
        url = [NSString stringWithFormat: @"pri/membercollect/collect.json?collectType=1&collectId=%@&token=%@",self.merchantdataDic [@"merchant_id"],token];
      
        
    }else if ([flagStr isEqualToString:@"2"]){
        url = [NSString stringWithFormat:@"pri/membercollect/uncollect.json?collectType=1&collectId=%@&token=%@",self.merchantdataDic [@"merchant_id"],token];
    }
    
    NSLog(@"---------%@",self.merchantdataDic [@"merchant_id"]);
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL2(url) delegate:nil params:nil info:infoDic];
}


#pragma mark - 网络请求结果数据
-(void) didFinishedRequestData:(NSNotification *)notification{
  
    [self.hud dismiss:YES];
    [myalertView hide];
    if ([[notification.userInfo valueForKey:@"RespResult"] isEqualToString:ERROR]) {
      
        [myalertView show:[notification.userInfo valueForKey:@"ContentResult"]];
       

        return;
    }
    NSDictionary *responseObject = [[NSDictionary alloc] initWithDictionary:[notification.userInfo objectForKey:@"RespData"]];
    NSLog(@"GetMerchantDetailInfo_: %@",responseObject);
    
    if ([notification.name isEqualToString:SubmitCollect]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:SubmitCollect object:nil];
        if ([responseObject[@"code"] intValue] == 0) {
            
            NSArray *items = self.navigationItem.rightBarButtonItems;
            UIBarButtonItem *favItem = [items firstObject];
            UIButton *favBtn = (UIButton *)favItem.customView;
            favBtn.selected = ! favBtn.selected; //修改按钮状态
            
         
            [myalertView show:[responseObject objectForKey:MSG]];

        }
        else {
       
            [myalertView show:[responseObject objectForKey:MSG]];

        }
    }

    
    if ([notification.name isEqualToString:GetMerchantDetailInfo]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:GetMerchantDetailInfo object:nil];
        if ([responseObject[@"code"] intValue] == 0) {
            NSDictionary *dic = responseObject [DATA];
            _merchantdataDic = dic[@"info"];  //商户信息数据字典
          
            picturecount = _merchantdataDic[@"picturecount"];
            _goodsdataArray = dic [@"goods"];    //商品信息数组
            _reviewdataDic = dic [@"reviews"];    //评论数据字典
            _view.nameL.text = dic[@"goods_name"];
            index = _goodsdataArray.count;
            
                if (_goodsdataArray.count>2) {
                index = 2;
            }
            
            NSLog(@"--%@",dic);
            total = [_reviewdataDic[@"total"] intValue];
            NSLog(@"-------------cao-------%d---------",total);
            BOOL iscollect = [dic [@"info"] [@"iscollect"] boolValue];
            if (iscollect) {
                _rightBtn.selected = YES;
            }
     
            [_myTableView reloadData];
        }
        else {
         [myalertView show:[responseObject objectForKey:MSG]];
        }
        
    }
}
//#pragma mark - 弹窗提示
//-(void)ballReminder:(NSString *)string{
//    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil message:string delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
//    [NSTimer scheduledTimerWithTimeInterval:1.5f
//                                     target:self
//                                   selector:@selector(timerFireMethod:)
//                                   userInfo:promptAlert
//                                    repeats:YES];
//    [promptAlert show];
//}
//#pragma mark - 弹窗自动消失
//- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
//{
//    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
//    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
//    promptAlert =NULL;
//}

#pragma mark-根据选择的城市名称请求商家的列表
-(void)getMerchantListWtih:(NSString *)cityNames withCityAreaName:(NSString *)cityAreaName{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];  //设置传参方式为JSON
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:[NSArray arrayWithObjects:@"text/plain", @"text/html",nil]];
    
    manager.requestSerializer.timeoutInterval = 120;
    [manager POST:[[NSString stringWithFormat:@"http://api.map.baidu.com/geocoder?address=%@&output=json&key=%@&city=%@",cityAreaName,BaiduMap_Key,cityNames] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        /**
         {
         "status":"OK",
         "result":{
         "location":{
         "lng":120.088993,
         "lat":30.207036
         },
         "precise":0,
         "confidence":16,
         "level":"\u533a\u53bf"
         }
         }
         */
        NSDictionary *resultDic=(NSDictionary *)responseObject;
        NSDictionary *dic1=[resultDic objectForKey:@"result"];
        NSDictionary *dic2=[dic1 objectForKey:@"location"];
        NSLog(@"=================================%@",[dic2 objectForKey:@"lat"]);
        NSDictionary *locationDic = [NSDictionary dictionaryWithObjectsAndKeys:[dic2 objectForKey:@"lat"],@"latitude",[dic2 objectForKey:@"lng"],@"longitude", nil];
        [self requestGetRecommendShopListWithLocationDic:locationDic];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - 去除null
-(NSString *)returnRemoveNull:(NSString *)string{
    
    if (string==nil ||[string isEqual:@"(null)"]||[string isEqual:@"<null>"]||string.length<=0) {
        string = @"";
    }
    
    return string;
}
@end
