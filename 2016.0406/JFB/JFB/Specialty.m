//
//  Specialty.m
//  特产首页
//
//  Created by 积分宝 on 15/12/22.
//  Copyright © 2015年 积分宝. All rights reserved.
//

#import "Specialty.h"

#import <MobClick.h>
#import "SpecialtyHeadView.h"
#import "SpecialtyClassSelectView.h"
#import "SpecialtyTwoCell.h"
#import "ShopSearchViewController.h"
#import "CitySelectBgView.h"
#import "AppDelegate.h"
#import "GoodsDetailViewController.h"
#import "CitySelectViewController.h"
#import "MJRefresh.h"
#import <BaiduMapAPI/BMapKit.h>//引入所有的头文件
#define WITH  [[UIScreen mainScreen] bounds].size.width
#define HEIGHT  [[UIScreen mainScreen] bounds].size.height
#define Access_interval_Width        2 //箭头和文字的间隔
#define LeftBtn_MaxWidth            140  //导航左侧按钮最大宽度
#define redC [UIColor colorWithRed:244/255. green:17/255. blue:0/255. alpha:1]
//#define yrrC [UIColor colorWithRed:241/255. green:162/255. blue:42/255. alpha:1]
@interface Specialty ()<UITableViewDataSource,UITableViewDelegate,SpecDelegate,SpecialtyClassDelegate,UITextFieldDelegate>//,AlreadySelectCityDelegate>
{
//     AppDelegate *app;
//     CityDistrictsCoreObject *cityObject;
    MBProgressHUD *_hud;
    MBProgressHUD *_networkConditionHUD;
    NSMutableArray *goodsArr;
    UITableView *myTable;
    SpecialtyClassSelectView *specialtyClassView;
    SpecialtyHeadView *speciaView;
    NSArray *dataArr ;
    UIView *beiJView;

    NSString *_virtualBuy;
    NSString *_memberPension;
    NSString *_goodsName;
    int _rows;
    int _start;
    
    UIButton *searchBtn;
    UIView *searchView;
    UITextField *searchFiled;
    UIBarButtonItem *rightItem;
    
}
@property (nonatomic, strong) UIButton *leftButn;
//@property (strong, nonatomic)  UIView *citySelectBgView;
@property (strong,nonatomic) CitySelectBgView *citySelectBgView;
@property (strong, nonatomic)  UIView *citySelectView;
@end

@implementation Specialty

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
    
    
    self.title = @"特产专区";
    self.view.backgroundColor = [UIColor whiteColor];
    
    goodsArr = [NSMutableArray array];
    _memberPension = @"0";
    _virtualBuy = @"0";
    _start = 0;
    _rows = 15;
    _goodsName = @"";
    dataArr = [NSArray arrayWithObjects:@"全部",@"销售量",@"养老金",nil];
    
   
    [self requestSpcialtyVirtualBuy:_virtualBuy memberPension:_memberPension goodsName:_goodsName start:_start];
    
    [self addSpecialtyHeadView];
    
    [self addSearchTool];
    [self addTableView];
    [self addSearchButton];
    [self addSpecialtyClassSelectView];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center  addObserver:self selector:@selector(keyboardDidShow)  name:UIKeyboardDidShowNotification  object:nil];
    [center addObserver:self selector:@selector(keyboardDidHide)  name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardDidShow
{
    searchView.hidden = NO;
}

- (void)keyboardDidHide
{
    searchView.hidden = YES;
}

#pragma mark - 添加搜索按钮
-(void)addSearchButton{
    
    searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 50, 30);
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtn:) forControlEvents:UIControlEventTouchUpInside];
    rightItem = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    
    
    searchView  = [[UIView alloc]initWithFrame:self.view.bounds];
    searchView.backgroundColor = [UIColor grayColor];
    searchView.alpha = .5;
    searchView.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endIng)];
    [searchView addGestureRecognizer:tap];
    [self.view addSubview:searchView];
}
#pragma mark - 结束编辑
-(void)endIng{
    [self.view endEditing:YES];
    [searchFiled resignFirstResponder];
}
#pragma mark - 搜索按钮事件
-(void)searchBtn:(UIButton *)btn{
    [searchFiled resignFirstResponder];
    [goodsArr removeAllObjects];
  
    [self requestSpcialtyVirtualBuy:_virtualBuy memberPension:_memberPension goodsName:_goodsName start:0];
      searchFiled.text = @"";
      _goodsName = @"";
}
#pragma mark - 添加特产分类横条选择View
-(void)addSpecialtyHeadView{
    speciaView = [[SpecialtyHeadView alloc]initWithFrame:CGRectMake(0, 0, WITH, 45)];
    speciaView.specDelegate = self;
    speciaView.dataArr = dataArr;
    [self.view addSubview:speciaView];
}

#pragma mark - 添加特产分类选择View
-(void)addSpecialtyClassSelectView{
    beiJView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, WITH, HEIGHT)];
    beiJView.backgroundColor = [UIColor grayColor];
    beiJView.alpha = .5;
    beiJView.hidden = YES;
    [self.view addSubview:beiJView];
    specialtyClassView = [[SpecialtyClassSelectView alloc]initWithFrame:CGRectMake(0, 45, WITH, HEIGHT*.255)];
    specialtyClassView.dataArray =dataArr;
    specialtyClassView.hidden = YES;
    specialtyClassView.specialtyClassDelegate = self;
    [self.view addSubview:specialtyClassView];
}

#pragma mark - 添加tableview
-(void)addTableView{
    myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 45, WITH, HEIGHT-45-64) style:UITableViewStyleGrouped];
    myTable.dataSource = self;
    myTable.delegate = self;
    myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [myTable addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [myTable addFooterWithTarget:self action:@selector(footerLoadData)];
    [self.view addSubview:myTable];
}

#pragma mark - 添加搜索框
-(void)addSearchTool{
    //背景图
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 7, 200, 30)];
    imageView.userInteractionEnabled=YES;
    imageView.image = [UIImage imageNamed:@"TSFShouBeiJing"];
    
    //文本框
    searchFiled = [[UITextField alloc] initWithFrame:CGRectMake( 0, 0, 200, 30)];
     searchFiled.placeholder = @"网罗天下";
     searchFiled.delegate = self;
     [ searchFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    //文本框左侧图标
    UIImageView *image1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"caca.png"]];
    image1.frame=CGRectMake(10, 0, 27, 27);
     searchFiled.leftView=image1;
     searchFiled.leftViewMode=UITextFieldViewModeAlways;
     searchFiled.userInteractionEnabled = YES;
    [imageView addSubview: searchFiled];
    
    self.navigationItem.titleView = imageView;
    
    
    
}
#pragma mark - 下拉刷新,上拉加载
-(void)headerRefreshing {
    NSLog(@"下拉刷新个人信息");
   // _start = 0;
    //[self requestSpcialty];
    [self requestSpcialtyVirtualBuy:_virtualBuy memberPension:_memberPension goodsName:_goodsName start:_start];
}

-(void)footerLoadData {
    NSLog(@"上拉加载数据");
    _start +=_rows;
   
    [self requestSpcialtyVirtualBuy:_virtualBuy memberPension:_memberPension goodsName:_goodsName start:_start];
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
    self.hidesBottomBarWhenPushed=YES;

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden=NO;
    self.hidesBottomBarWhenPushed=NO;

}
#pragma mark - 特产数据网络请求
-(void)requestSpcialtyVirtualBuy:(NSString *)virtualBuy memberPension:(NSString *)memberPension goodsName:(NSString *)goodsName  start:(int)start {
     [_hud show:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestShopListData:) name:@"Spcialty" object:nil];
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"Spcialty", @"op", nil];
    
   NSString *url = [NSString stringWithFormat:@"goods/listbyrecommend.htm?virtualBuy=%@&memberPension=%@&start=%@&rows=%@&goodsName=%@",virtualBuy,memberPension,[NSNumber numberWithInt:start],[NSNumber numberWithInt:_rows],goodsName];
    NSLog(@"%@",NewRequestURL(url));
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL(url) delegate:nil params:nil info:infoDic];
}
#pragma mark - 网络请求数据结果
-(void)didFinishedRequestShopListData:(NSNotification *)notification{
    [_hud hide:YES];
    [myTable headerEndRefreshing];
    [myTable footerEndRefreshing];
    if ([[notification.userInfo valueForKey:@"RespResult"] isEqualToString:ERROR]) {
        _networkConditionHUD.labelText = [notification.userInfo valueForKey:@"ContentResult"];
        [_networkConditionHUD show:YES];
        [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        return;
    }
    NSDictionary *responseObject = [[NSDictionary alloc] initWithDictionary:[notification.userInfo objectForKey:@"RespData"]];
    NSLog(@"GetMerchantDetailInfo_: %@",responseObject);
    if ([notification.name isEqualToString:@"Spcialty"]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Spcialty" object:nil];
        NSLog(@"GetMerchantList_responseObject: %@",responseObject);
        
        if ([responseObject[@"code"] intValue] == 0) {
            
            
            if (_start == 0) { //如果是第一页
                [goodsArr removeAllObjects];
            }
            if ([responseObject[DATA] isKindOfClass:[NSArray class]]) {
                [goodsArr addObjectsFromArray:responseObject[DATA]];
            }
            [myTable reloadData];
        }
        else {
            _networkConditionHUD.labelText = [responseObject objectForKey:MSG];
            [_networkConditionHUD show:YES];
            [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        }
        if (goodsArr.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无数据结果！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}



#pragma mark - 返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark - 返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return goodsArr.count;
}
#pragma mark - 返回cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

        return HEIGHT*.208;
        

}
#pragma mark - 设置tableViewCell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
   
        NSString *ss=@"twoCell";
    
    
       NSDictionary *dic = goodsArr[indexPath.row];
    
    
    if (goodsArr.count>0) {
        
    
        SpecialtyTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:ss];
        if (!cell) {
            cell= [[SpecialtyTwoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ss];
        }
    
        NSString *memberPension =  dic[@"buyPension"];
        [cell setHeight:HEIGHT*.208];
        [cell setrightText:memberPension :HEIGHT*.208];
        [cell.leftIM sd_setImageWithURL:[NSURL URLWithString:dic [@"goodsImages"]] placeholderImage:IMG(@"bg_merchant_photo_placeholder")];
        cell.goodsNameL.text = dic[@"goodsName"];
        cell.countL.text = dic[@"goodsTitle"];
        cell.priceL.text = [NSString stringWithFormat:@"¥%@", dic[@"buyPrice"]];
        cell.salesL.text = [NSString stringWithFormat:@"已售:%@",dic[@"virtualBuy"]];
        return cell;
    }else if(goodsArr.count==0){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ss];
        cell.textLabel.text = @"暂无搜索结果";
        return cell;
    }
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 1;
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


#pragma mark - 监听tableViewCell点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击cell背景恢复正常状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = goodsArr[indexPath.row];
    GoodsDetailViewController *view = [[GoodsDetailViewController alloc]init];
    view.goods_id = [dic objectForKey:@"id"];
    view.isHome = @"1";
    view.hidesBottomBarWhenPushed = YES;
    view.cao = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    [self.navigationController pushViewController:view animated:YES];
    
    NSString *specialtyText = [NSString stringWithFormat:@"specialtyGoodsTouch_%@",view.goods_id];
     [MobClick event:specialtyText];
     [MobClick event:@"specialtyGoodsTouch"];
   
}
#pragma mark -SpecDelegate
-(void)specdelegateIndext:(int)value{
    NSLog(@"%d",value);
     [goodsArr removeAllObjects];
    if (value==0) {
        _memberPension = @"0";
        _virtualBuy = @"0";
    }else if (value==1) {
        _memberPension = @"0";
        _virtualBuy = @"1";
    }else if (value==2) {
        _memberPension = @"1";
        _virtualBuy = @"0";
    }
    
    [self requestSpcialtyVirtualBuy:_virtualBuy memberPension:_memberPension goodsName:@"" start:0];
}
-(void)specdelegatebutton:(BOOL)button{
    
    specialtyClassView.hidden = button;
    speciaView.hintL.hidden = button;
    beiJView.hidden = button;
    
}


-(void)textFieldDidChange :(UITextField *)theTextField{
   
    
    if (theTextField.text.length>0) {
         self.navigationItem.rightBarButtonItem = rightItem;
    }else if (theTextField.text.length<=0){
         self.navigationItem.rightBarButtonItem = nil;
    }
    _goodsName = theTextField.text;
 
}
-(void)SpecialtyClassDelegate:(int)itmeIndext :(BOOL)selfHidden{
    //  NSLog(@"%d---%d",itmeIndext,selfHidden);
    
     [goodsArr removeAllObjects];
    speciaView.btn4.selected = selfHidden;
    beiJView.hidden = !selfHidden;
    [speciaView alteroScorllViewOffset:itmeIndext];
    
    if (itmeIndext==0) {
        _memberPension = @"0";
        _virtualBuy = @"0";
    }else if (itmeIndext==1) {
        _memberPension = @"0";
        _virtualBuy = @"1";
    }else if (itmeIndext==2) {
        _memberPension = @"1";
        _virtualBuy = @"0";
    }
    
   [self requestSpcialtyVirtualBuy:_virtualBuy memberPension:_memberPension goodsName:@"" start:0];

}

@end
