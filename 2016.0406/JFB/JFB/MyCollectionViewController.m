//
//  MyCollectionViewController.m
//  JFB
//
//  Created by JY on 15/8/24.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "ShopDetailVoucherCell.h"
#import "HomeShopListCell.h"
#import "ShopDetailViewController.h"
#import "GoodsDetailViewController.h"

#define VoucherCell    @"shopDetailVoucherCell"
#define kTableViewCelllIdentifier      @"HomeShopCell"


@interface MyCollectionViewController ()
{
    MBProgressHUD *_hud;
    MBProgressHUD *_networkConditionHUD;
    NSMutableArray *goodsdata;
    NSMutableArray *merchantdata;
    
    NSString  *type ;
}

@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的收藏";
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }

    goodsdata = [[NSMutableArray alloc] init];
    merchantdata = [NSMutableArray array];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editTableCell)];
    
    self.myTableView.tableFooterView = [UIView new];
    [self.myTableView registerNib:[UINib nibWithNibName:@"ShopDetailVoucherCell" bundle:nil] forCellReuseIdentifier:VoucherCell];
    [self.myTableView registerNib:[UINib nibWithNibName:@"HomeShopListCell" bundle:nil] forCellReuseIdentifier:kTableViewCelllIdentifier];
    type = @"0";

}
-(void)viewWillAppear:(BOOL)animated{
   // [self viewWillAppear:animated];
  
     self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    
    self.extendedLayoutIncludesOpaqueBars=YES; // 解决隐藏导航栏问题
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
    
    [self requestGetCollectList];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_frameBool) {
        self.navigationController.navigationBar.translucent = YES;
    }
}
-(void)editTableCell {
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"编辑"]) {
        self.myTableView.editing = YES;
        [self.navigationItem.rightBarButtonItem setTitle:@"完成"];
     
        return;
    }
    
    self.myTableView.editing = NO;
    [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
    
}

#pragma mark - 商品按钮
- (IBAction)goodsAction:(id)sender {
    if (! _goodsBtn.selected) { //当前按钮没有选中时
        _goodsBtn.selected = YES;
        [_goodsView setBackgroundColor:RGBCOLOR(216, 80, 92)];
        
        _shopBtn.selected = NO;
        [_shopView setBackgroundColor:[UIColor clearColor]];
    }
    type = @"0";
    [self.myTableView reloadData];
}
#pragma mark - 商家按钮
- (IBAction)shopAction:(id)sender {
    if (! _shopBtn.selected) { //当前按钮没有选中时
        _shopBtn.selected = YES;
        [_shopView setBackgroundColor:RGBCOLOR(216, 80, 92)];
        
        _goodsBtn.selected = NO;
        [_goodsView setBackgroundColor:[UIColor clearColor]];
    }
    type = @"1";
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.goodsBtn.selected) {
        return [goodsdata count];
    }
    return [merchantdata count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.goodsBtn.selected) {
//        return 90;
//    }
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.goodsBtn.selected) {
        ShopDetailVoucherCell *cell = (ShopDetailVoucherCell *)[tableView dequeueReusableCellWithIdentifier:VoucherCell];
        
        NSDictionary *dic = goodsdata [indexPath.row];
        
        cell.emptyL.hidden = YES;
        cell.voucherView.hidden = NO;
        [cell.voucherIM sd_setImageWithURL:[NSURL URLWithString:dic [@"goodsImages"]] placeholderImage:IMG(@"bg_merchant_photo_placeholder")];
        cell.nameL.text = dic [@"goodsName"];
        cell.priceL.text = [NSString stringWithFormat:@"%@元",dic[@"buyPrice"]];
        cell.costPriceStrikeL.text = [NSString stringWithFormat:@"%@元",dic[@"marketPrice"]];
        
       // cell.collectionSaleL.hidden = NO;
       // cell.collectionSaleL.text = [NSString stringWithFormat:@"已售:%@",dic[@"sales"]];
          cell.saleL.text = [NSString stringWithFormat:@"已售:%@",dic[@"virtualBuy"]];
       // cell.saleL.hidden = YES;
        
        return cell;
    }
    
    NSDictionary *dic = merchantdata [indexPath.row];
    HomeShopListCell *cell = (HomeShopListCell *)[tableView dequeueReusableCellWithIdentifier:kTableViewCelllIdentifier];
    
    [cell.shopIM sd_setImageWithURL:[NSURL URLWithString:dic[@"background"]] placeholderImage:IMG(@"bg_merchant_photo_placeholder")];
    cell.shopNameL.text = dic[@"merchant_name"];
    cell.shopAddressL.text = dic[@"address"];
    cell.rateView.rate = [dic[@"score"] floatValue];
    cell.scoreL.text = [NSString stringWithFormat:@"%@分",dic[@"score"]];
    
    float fraction = [dic[@"fraction"] floatValue]*100;
    cell.integralRateL.text = [NSString stringWithFormat:@"%.2f%%",fraction];
    
    //折扣
    NSString *str1 = [NSString stringWithFormat:@"%@",dic[@"discount_ratio"]];
    if([str1 isEqual:@"<null>"]){
        cell.discountL.text=nil;
    }else if ([str1 isEqual:@"(null)"]){
         cell.discountL.text=nil;
    }else{
        cell.discountL.text = [NSString stringWithFormat:@"%@折", dic [@"discount_ratio"]];
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (self.goodsBtn.selected) {
            NSDictionary *dic = goodsdata [indexPath.row];
            [self DeleteCollectionWithCollectionID:dic[@"id"]];
            [goodsdata removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
        else {
            NSDictionary *dic = merchantdata [indexPath.row];
            [self DeleteCollectionWithCollectionID:dic[@"merchant_id"]];
            [merchantdata removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
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
    if (self.goodsBtn.selected) {
        NSDictionary *dic = goodsdata [indexPath.row];
        
        NSLog(@"%@",dic);
        GoodsDetailViewController *goodsDeatilVC = [[GoodsDetailViewController alloc] init];
        goodsDeatilVC.goods_id = dic [@"id"];
       // goodsDeatilVC.merchant_id = dic [@"merchant_id"];
        goodsDeatilVC.saleText = dic[@"virtualBuy"];
        goodsDeatilVC.prilcText = dic[@"salesPrice"];
        goodsDeatilVC.usedprilcText = dic[@"marketPrice"];
       // goodsDeatilVC.fraction = dic[@"fraction"];
        [self.navigationController pushViewController:goodsDeatilVC animated:YES];
    }
    else {
        NSDictionary *dic = merchantdata [indexPath.row];
        ShopDetailViewController *shopDeatilVC = [[ShopDetailViewController alloc] init];
        shopDeatilVC.merchantdataDic = dic;
        shopDeatilVC.frameBool = 1;
        [self.navigationController pushViewController:shopDeatilVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark - 发送请求
-(void)requestGetCollectList { //获取收藏列表
    
    
    [_hud show:YES];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:GetCollectList object:nil];
    
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:GetCollectList, @"op", nil];
    NSString *token = [NSString stringWithFormat:@"%@",[[GlobalSetting shareGlobalSettingInstance] pension]];
    NSString *url = [NSString stringWithFormat:@"pri/membercollect/mycollect.json?token=%@",token];
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL2(url) delegate:nil params:nil info:infoDic];
}


-(void)DeleteCollectionWithCollectionID:(NSString *)collectionId { //删除收藏
    [_hud show:YES];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:DeleteCollect object:nil];
    
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:DeleteCollect, @"op", nil];

    NSString *token = [NSString stringWithFormat:@"%@",[[GlobalSetting shareGlobalSettingInstance] pension]];
    NSString *url = [NSString stringWithFormat:@"pri/membercollect/uncollect.json?token=%@&collectType=%@&collectId=%@",token,type,collectionId];
    
    
    NSLog(@"---%@",NewRequestURL2(url));
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
    if ([notification.name isEqualToString:GetCollectList]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:GetCollectList object:nil];
        NSLog(@"GetMerchantList_responseObject: %@",responseObject);
        
        [goodsdata removeAllObjects];
        [merchantdata removeAllObjects];
        if ([responseObject[@"code"] intValue] == 0) {
            NSDictionary *dic = responseObject[DATA];
            if ([dic[@"goodsdata"] isKindOfClass:[NSNull class]]) {
            }
            else {
                [goodsdata addObjectsFromArray:dic[@"goodsdata"]];
            }
          
         
                [merchantdata addObjectsFromArray:dic[@"merchantdata"]];
        
           
        }
        else {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:MSG] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
//            [alert show];
            _networkConditionHUD.labelText = responseObject [MSG];
            [_networkConditionHUD show:YES];
            [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        }
        
        [self.myTableView reloadData];
    }
    
    
    if ([notification.name isEqualToString:DeleteCollect]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:DeleteCollect object:nil];
        
        NSLog(@"GetMerchantList_responseObject: %@",responseObject);
        if ([responseObject[@"codr"] intValue] == 0) {
            _networkConditionHUD.labelText = responseObject [MSG];
            [_networkConditionHUD show:YES];
            [_networkConditionHUD hide:YES afterDelay:HUDDelay];
            
        }
        else {
            _networkConditionHUD.labelText = responseObject [MSG];
            [_networkConditionHUD show:YES];
            [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        }
        _networkConditionHUD.labelText = responseObject [MSG];
        [_networkConditionHUD show:YES];
        [_networkConditionHUD hide:YES afterDelay:HUDDelay];
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

@end
