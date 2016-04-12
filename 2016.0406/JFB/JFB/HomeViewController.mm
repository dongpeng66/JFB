//
//  HomeViewController.m
//  JFB
//
//  Created by jy on 15/8/14.
//  Copyright (c) 2015年 jy. All rights reserved.
//

#import "HomeViewController.h"
#import <MobClick.h>

#import "HomeShopListCell.h"
#import "HomeCityCollectionViewCell.h"
//#import "CityObject.h"
//#import "CountysObject.h"
#import "checkIphoneNum.h"
#import "QJCheckVersionUpdate.h"
#import "CitySelectViewController.h"
#import "ShopSearchViewController.h"
#import "ShopMapViewController.h"
#import "ShopDetailViewController.h"
#import "ShopListVC.h"
#import "LoadingView.h"
#import "AJAdView.h"
#import "WebViewController.h"
#import "CityDistrictsCoreObject.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "JFBCountDownDayView.h"
#import "JFBCountDownView.h"
#import "JFBSeckillView.h"
#import "HomeActivityMessage.h"
#import "ScanCodeViewController.h"
#import "GoodsDetailViewController.h"
#import "TitleVIew.h"
#import "Specialty.h"
#define Head_View_Height            402     //广告图 + 分类菜单 + 活动
#define Head_ScrollView_Height      180
#define Head_PageControl_Width     80
#define Head_PageControl_Height     30
#define Head_button_Width           48
#define Head_button_Height          48
#define Access_interval_Width        2 //箭头和文字的间隔
#define LeftBtn_MaxWidth            140  //导航左侧按钮最大宽度
#define kTableViewCelllIdentifier      @"HomeShopCell"
#define kCollectionCelllIdentifier      @"HomeCityCollectionCell"
static const float RealSrceenHight =  667.0;
static const float RealSrceenWidth =  375.0;
@interface HomeViewController () <AlreadySelectCityDelegate,LoadingViewDelegate,AJAdViewDelegate,UIAlertViewDelegate,ScanCodeDelegate,JFBSeckillViewDelegate>
{
    NSString *app_version;
    NSDictionary *versionDic;
    UIImageView *imageView1;
    
    UIImageView *imageView2;
    
    UIImageView *imageView3;
    
    UIImageView *imageView4;
    AppDelegate *app;
    MBProgressHUD *_hud;
    MBProgressHUD *_cityHud;
    MBProgressHUD *_firstHud;
    MBProgressHUD *_networkConditionHUD;
    NSArray *merchantTypeArray;
    BMKLocationService* _locService;
    BMKGeoCodeSearch *_searcher;
    CityDistrictsCoreObject *cityObject;
    NSArray *countysArray;  //区县数组
    NSInteger selectItem; //被选中item的下标
    NSArray *recommendArray; //推荐商户列表数据
    NSString *cityName; //城市名称
    NSString *cityID;   //城市ID
    NSString *current_city_code;
    NSString *countyName; //区县名称
    NSString *countyID;  //区县ID
    NSString *current_county_code;
    NSMutableDictionary *mutabDic; //可变字典用于收集已选参数
    BOOL isChangeToMinCity; //是否显示切换到当前城市
    NSString *locationCityName; //定位城市名
    AJAdView *_adView;
    NSArray *_adArray;   //广告图数组
    NSDictionary *_dazhuanpanDic;    //大转盘
    NSDictionary *_zajindanDic;      //砸金蛋
    UILabel *_textL1;
    UILabel *_detailL1;
    UIImageView *_imgV1;
    UILabel *_textL2;
    UILabel *_detailL2;
    UIImageView *_imgV2;
    BOOL hasLottery;   //抽奖是否有数据
    
    NSString *cityDistricts_Version; //城市区域服务端版本号
    NSString *merchantTypeList_Version; //商户类型服务端版本号
    BOOL isOpen; //定位城市是否已开通
    
    NSString *myMerchant_id;
    NSString *myGoods_id;
    int  myIndex;
    
    
    int timeData;
    TitleVIew *titleView;
    
    NSString *nimaCity;
    
    NSDictionary *caoNiMaDic;
}

@property (nonatomic, strong) LoadingView *loadingView;//引导视图
@property (nonatomic, strong) UIScrollView *typeScrollView;
@property (nonatomic, strong) UIPageControl *typePageControl;
@property (nonatomic, strong) UIButton *leftButn;
/**
 首页活动信息模型数组
 */
@property (nonatomic,strong) NSMutableArray *homeActivityMessageArray;

///活动首页的视图
@property (nonatomic,strong) UIImageView *hotAcivityImageView;
/***
 秒杀商品的模型数组
 */
@property (nonatomic,strong) NSMutableArray *goodsSeckillArray;
/**
 *  lat
 */
@property (nonatomic,copy)NSString *lat;
/**
 *  lon
 */
@property (nonatomic,copy)NSString *lon;
//倒计时视图day
@property (nonatomic,strong) JFBCountDownDayView *timeCountDayView;
//倒计时视图noday
@property (nonatomic,strong) JFBCountDownView *timeCountView;
//倒计时提示视图
@property (nonatomic,strong) UILabel *timeCountLabel;
//是否开始活动
@property (assign,nonatomic) BOOL isStartActivity;
//活动是否结束了
@property (assign,nonatomic) BOOL isEndActivity;
//掌上秒杀顶部视图
@property (nonatomic,strong) UIView *goodsSeckillTopView;
//秒杀商品视图
@property (nonatomic,strong) UIScrollView *seckillScollView;
//热门说动显示视图
@property (nonatomic,strong) UIView *hotActivityShowView;
//一元购活动字典
@property (nonatomic,strong) NSArray *oneYuanActivityArray;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isStartActivity=NO;
    self.isEndActivity=NO;
    [self initNavigationView];//导航栏View加载
   
    
    [self requestGetBanner];//广告轮播图
    [self requestGetHomeActivityList];//首页活动
    [self requestGetCityDistricts_Version];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestGetHomeActivityList) name:@"ReloadHome" object:nil];
    
    
    double delayInSeconds = 0.0;
   
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self requrtGetAppVersion];//app是否有新版本

    });
    
    
     [self requestGetCityDistricts_Version];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appUpdateVersion) name:@"appUpdateVersion" object:nil];
    
    merchantTypeList_Version = [[GlobalSetting shareGlobalSettingInstance] merchantTypeList_Version];
    if (merchantTypeList_Version == nil) {
        merchantTypeList_Version = @"1";
        [[GlobalSetting shareGlobalSettingInstance] setMerchantTypeList_Version:@"1"];
    }
    
    
    
    
    
    
    /**********************/
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //   [self requestGetLottery];   //因为抽奖视图会变动，所以首先请求
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    app_version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];//上架版本号
    NSString *locationAppVersion = [[GlobalSetting shareGlobalSettingInstance] appVersion];
    
    if (! [[GlobalSetting shareGlobalSettingInstance] isNotFirst] || ! [locationAppVersion isEqual:app_version]) {   //第一次进入应用
    }
    else {
        [self performSelector:@selector(requestGetCityDistricts) withObject:nil afterDelay:0.3];    //延迟0.1秒
    }
    
    /**********************/
    
    _locService = [[BMKLocationService alloc]init];
    //            初始化检索对象
    _searcher = [[BMKGeoCodeSearch alloc]init];
    
    self.changeCityView.layer.borderColor = Cell_sepLineColor.CGColor;
    self.changeCityView.layer.borderWidth = 1;
    
    //重置tableView的frame，重要！！
    self.myTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49);
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"HomeShopListCell" bundle:nil] forCellReuseIdentifier:kTableViewCelllIdentifier];
    [self.cityCollectionView registerNib:[UINib nibWithNibName:@"HomeCityCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kCollectionCelllIdentifier];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelSelectCity)];
    [self.citySelectBgView addGestureRecognizer:tap];
    
    mutabDic = [[NSMutableDictionary alloc] init];
    selectItem = 0;
    cityID = @"";
    cityName = @"";
    countyID = @"";
    countyName = @"";
    current_city_code = @"";
    current_county_code = @"";
    isChangeToMinCity = YES;    //是否弹框显示定位城市
    
    NSMutableDictionary *dic = [[GlobalSetting shareGlobalSettingInstance] homeSelectedDic];
    NSLog(@"dic: %@",dic);
    if (dic != nil) {
        selectItem = [dic[@"selectItem"] integerValue];
        cityID = dic[@"current_city_code"];
        current_city_code = dic [@"current_city_code"];
        cityName = dic [@"areaName"];
        countyID = dic[@"countyID"];
        current_county_code = dic [@"current_county_code"];
        countyName = dic[@"countName"];
        
        if (! [dic[@"countName"] isEqualToString:@""]) {
            countyName = [NSString stringWithFormat:@"--%@",dic[@"countName"]];     //增加“--”分隔符
        }
        
        self.currentCityL.text = cityName;
        
        [self adjustLeftBtnFrameWithTitle:[NSString stringWithFormat:@"%@%@",cityName,countyName]];
        [self getMerchantListWtih:cityName withCityAreaName:countyName];
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请到设置-隐私-定位服务中打开定位权限！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        [_locService startUserLocationService];     //本地存在省市数据的情况下发起定位
        
        //加载用户选择的数据后直接请求数据
        [self requestGetRecommendShopListWithLocationDic:[[GlobalSetting shareGlobalSettingInstance] myLocation]];
    }
    
    [self initTableViewHeadView];
    [self requestGetMerchantTypeList];
}
#pragma mark - 导航栏左中右部按钮
-(void)initNavigationView{
    
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //导航栏左边按钮
    _leftButn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButn.frame = CGRectMake(0, 9, 100, 26);
    _leftButn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_leftButn setImage:[UIImage imageNamed:@"subject_expand_n"] forState:UIControlStateNormal];
    [_leftButn setImage:[UIImage imageNamed:@"subject_collapse_n"] forState:UIControlStateSelected];
    [_leftButn setTitleEdgeInsets:UIEdgeInsetsMake(0, -12 - Access_interval_Width, 0, 12 + Access_interval_Width)];
    [_leftButn addTarget:self action:@selector(toSelectCity:) forControlEvents:UIControlEventTouchUpInside];
    
    [self adjustLeftBtnFrameWithTitle:@"全部"];
         
    //右部定位按钮
    UIButton *rightButn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButn.frame = CGRectMake(0, 0, 24, 24);
    rightButn.contentMode = UIViewContentModeScaleAspectFit;
    [rightButn setImage:[UIImage imageNamed:@"pd_sendto"] forState:UIControlStateNormal];
    [rightButn addTarget:self action:@selector(toMapView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButn = [[UIBarButtonItem alloc] initWithCustomView:rightButn];
    self.navigationItem.rightBarButtonItem = rightBarButn;
    
    
    //中间titleVIew
    
    
    
}
#pragma mark-懒加载活动信息数组
-(NSMutableArray *)homeActivityMessageArray{
    if (_homeActivityMessageArray==nil) {
        _homeActivityMessageArray=[[NSMutableArray alloc]init];
    }
    return _homeActivityMessageArray;
}
#pragma mark - 特产专区imageview
-(UIImageView *)hotAcivityImageView{
    if (!_hotAcivityImageView) {
        _hotAcivityImageView = [[UIImageView alloc]init];
    }
    return _hotAcivityImageView;
}
#pragma mark-懒加载秒杀商品的信息数组
-(NSMutableArray *)goodsSeckillArray{
    if (_goodsSeckillArray==nil) {
        _goodsSeckillArray=[[NSMutableArray alloc]init];
    }
    return _goodsSeckillArray;
}
-(NSArray *)oneYuanActivityDic{
    if (_oneYuanActivityArray==nil) {
        _oneYuanActivityArray=[[NSArray alloc]init];
    }
    return _oneYuanActivityArray;
}
#pragma mark - 头部视图
-(void) initTableViewHeadView {
    if (1) {
        
        //分类菜单／轮播视图的父视图
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT*([checkIphoneNum shareCheckIphoneNum].homeActivityViewHeight/RealSrceenHight))];
        if(self.goodsSeckillArray.count==0){
            view.height=SCREEN_HEIGHT*([checkIphoneNum shareCheckIphoneNum].homeActivityViewHeight/RealSrceenHight)-SCREEN_HEIGHT*(50/RealSrceenHight)-((SCREEN_WIDTH-10-15)/7*2+40);
        }
        if ([self.oneYuanActivityArray count]!=0) {
            view.height=SCREEN_HEIGHT*([checkIphoneNum shareCheckIphoneNum].homeActivityViewHeight/RealSrceenHight)+SCREEN_HEIGHT*(118.5/RealSrceenHight);
        }
        NSLog(@"%f",view.height);
        view.backgroundColor = [UIColor whiteColor];
        self.myTableView.tableHeaderView = view;
        
        
        
        //----------------将原有高度120修改为 150 -----TSF-2015.11.19----------------------
        //轮播图
        _adView = [[AJAdView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*(150/RealSrceenHight))];
        
        _adView.delegate = self;
        [view addSubview:_adView];
        
        //－－－－－－－将原有y值131修改为 150  TSF-2015.11.19－－－－－－－－－－－－－－－－－－－
        self.typeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_adView.frame), SCREEN_WIDTH,SCREEN_HEIGHT*(110/RealSrceenHight))];
        //------------------------------------------------------------------------------
        
        self.typeScrollView.backgroundColor = [UIColor whiteColor];
        self.typeScrollView.pagingEnabled = YES;
        self.typeScrollView.showsHorizontalScrollIndicator = NO;
        self.typeScrollView.delegate = self;
        // self.typeScrollView.scrollEnabled = NO;
        [view addSubview:self.typeScrollView];
        view.clipsToBounds=YES;
        
        
        self.typePageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,  CGRectGetMaxY(self.typeScrollView.frame)-SCREEN_HEIGHT*(18/RealSrceenHight), SCREEN_WIDTH, SCREEN_HEIGHT*(30/RealSrceenHight))];
        self.typePageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        
        self.typePageControl.currentPageIndicatorTintColor = RGBCOLOR(229, 24, 35);
        [view addSubview:self.typePageControl];
        /**
         一元购商品活动
         */
        UIView *oneYuanActivityView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.typeScrollView.frame)+10, SCREEN_WIDTH, SCREEN_HEIGHT*(118.5/RealSrceenHight))];
        oneYuanActivityView.backgroundColor=RGBCOLOR(239, 239, 239);
        if ([self.oneYuanActivityArray count]!=0) {
            [view addSubview:oneYuanActivityView];
        }
        UIImageView *oneYuanActivityImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*(6.5/RealSrceenWidth), SCREEN_HEIGHT*(6.5/RealSrceenHight), SCREEN_WIDTH*(362/RealSrceenWidth), SCREEN_HEIGHT*(112/RealSrceenHight))];
        oneYuanActivityImageView.userInteractionEnabled=YES;
        
        UIButton *oneYuanActivityBtn=[[UIButton alloc]initWithFrame:oneYuanActivityImageView.frame];
        oneYuanActivityBtn.backgroundColor=[UIColor clearColor];
        [oneYuanActivityImageView addSubview:oneYuanActivityBtn];
        [oneYuanActivityBtn addTarget:self action:@selector(onaYuanAcivityTapAction) forControlEvents:UIControlEventTouchUpInside];
        if ([self.oneYuanActivityArray count]!=0) {
            [oneYuanActivityImageView sd_setImageWithURL:[NSURL URLWithString:[[self.oneYuanActivityArray firstObject]objectForKey:@"img_url"]] placeholderImage:[UIImage imageNamed:@"bg_merchant_photo_placeholder"]];
            [oneYuanActivityView addSubview:oneYuanActivityImageView];
        }
        /**
         分隔条
         */
        UIView *divisionView=[[UIView alloc]init];
        divisionView.backgroundColor=RGBCOLOR(239, 239, 239);
        divisionView.width=SCREEN_WIDTH;
        divisionView.x=0;
        if ([self.oneYuanActivityArray count]==0) {
            divisionView.y=CGRectGetMaxY(self.typeScrollView.frame)+10;
            divisionView.height=SCREEN_HEIGHT*(7/RealSrceenHight);
        }else{
            divisionView.y=CGRectGetMaxY(oneYuanActivityView.frame);
            divisionView.height=SCREEN_HEIGHT*(6.5/RealSrceenHight);
        }
        
        [view addSubview:divisionView];
        /**
         掌上秒杀
         */
        UIView *goodsSeckillTopView=[[UIView alloc]init];
        goodsSeckillTopView.x=0;
        goodsSeckillTopView.y=CGRectGetMaxY(divisionView.frame);
        goodsSeckillTopView.height=SCREEN_HEIGHT*(30/RealSrceenHight);
        goodsSeckillTopView.width=SCREEN_WIDTH;
        [view addSubview:goodsSeckillTopView];
        self.goodsSeckillTopView=goodsSeckillTopView;
        UILabel *seckillLabel=[[UILabel alloc]init];
        seckillLabel.x=11;
        seckillLabel.y=0;
        seckillLabel.width=SCREEN_WIDTH/3;
        seckillLabel.height=goodsSeckillTopView.height;
        [goodsSeckillTopView addSubview:seckillLabel];
        seckillLabel.text=@"限时抢购";
        seckillLabel.font = [UIFont fontWithName:@"Gothic-Bold" size:26];
        UIView *sssLine=[[UIView alloc]initWithFrame:CGRectMake(11, CGRectGetMaxY(seckillLabel.frame), SCREEN_WIDTH-22, 1)];
        sssLine.backgroundColor=RGBCOLOR(235, 235, 235);
        [goodsSeckillTopView addSubview:sssLine];
        /**
         秒杀产品
         */
        UIScrollView *seckillScollView=[[UIScrollView alloc]init];
        seckillScollView.x=11;
        seckillScollView.y=CGRectGetMaxY(goodsSeckillTopView.frame)+SCREEN_HEIGHT*(3/RealSrceenHight);
        seckillScollView.width=(SCREEN_WIDTH-10);
        seckillScollView.height=(seckillScollView.width-15)/7*2+40;
        NSLog(@"%.f",(seckillScollView.width-15)/7*2+40);
        [view addSubview:seckillScollView];
        self.seckillScollView=seckillScollView;
        seckillScollView.showsHorizontalScrollIndicator=NO;
        seckillScollView.pagingEnabled=NO;
        seckillScollView.bounces=NO;
        seckillScollView.delegate=self;
        //分割线
        UIView *divisionView2=[[UIView alloc]init];
        divisionView2.backgroundColor=RGBCOLOR(239, 239, 239);
        divisionView2.width=SCREEN_WIDTH;
        divisionView2.height=SCREEN_HEIGHT*(7/RealSrceenHight);
        divisionView2.x=0;
        if (self.goodsSeckillArray.count==0) {
            divisionView2.y=CGRectGetMaxY(self.typeScrollView.frame)+8;
            divisionView.hidden=YES;
            goodsSeckillTopView.hidden=YES;
            seckillScollView.hidden=YES;
        }else{
            divisionView2.y=CGRectGetMaxY(seckillScollView.frame)+8;
        }
        
        [view addSubview:divisionView2];
        //热门活动视图
        UIView *hotActivityView=[[UIView alloc]initWithFrame:CGRectMake(11, CGRectGetMaxY(divisionView2.frame), (SCREEN_WIDTH-22), 224)];
        //        hotActivityView.backgroundColor=[UIColor blueColor];
        [view addSubview:hotActivityView];
        //热门活动label
        UILabel *hotAcivityLabel=[[UILabel alloc]init];
        hotAcivityLabel.x=0;
        hotAcivityLabel.y=0;
        hotAcivityLabel.width=SCREEN_WIDTH/3;
        hotAcivityLabel.height=SCREEN_HEIGHT*(30/RealSrceenHight);
        //                hotAcivityLabel.backgroundColor=[UIColor yellowColor];
        [hotActivityView addSubview:hotAcivityLabel];
        hotAcivityLabel.text=@"特产专区";
        hotAcivityLabel.font = [UIFont fontWithName:@"Gothic-Bold" size:26];
        //        热门活动的UIImageView
        //        UIImageView *hotAcivityImageView=[[UIImageView alloc]init];
        self.hotAcivityImageView.x=0;
        self.hotAcivityImageView.y=CGRectGetMaxY(hotAcivityLabel.frame);
        self.hotAcivityImageView.width=hotActivityView.width;
        self.hotAcivityImageView.height=SCREEN_HEIGHT*(95/RealSrceenHight);
        //        self.hotAcivityImageView.backgroundColor = [UIColor redColor];
        self.hotAcivityImageView.userInteractionEnabled=YES;
        [hotActivityView addSubview:self.hotAcivityImageView];
        UIButton *hotAcivityBtn=[[UIButton alloc]init];
        hotAcivityBtn.frame=self.hotAcivityImageView.bounds;
        [hotAcivityBtn addTarget:self action:@selector(hotImageViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.hotAcivityImageView addSubview:hotAcivityBtn];
        
        
        
        //热门活动展示视图
        UIView *hotActivityShowView=[[UIView alloc]init];
        hotActivityShowView.x=0;
        hotActivityShowView.y=CGRectGetMaxY(self.hotAcivityImageView.frame)+10;
        hotActivityShowView.width=hotActivityView.width;
        //        hotActivityShowView.backgroundColor=[UIColor yellowColor];
        hotActivityShowView.height=SCREEN_HEIGHT*(130/RealSrceenHight);
        [hotActivityView addSubview:hotActivityShowView];
        self.hotActivityShowView=hotActivityShowView;
        //        hotActivityShowView.backgroundColor=[UIColor greenColor];
        
    }
    
    //在这之后再进行首页tableView头视图的数据加载
    NSDictionary *typeDic = [[GlobalSetting shareGlobalSettingInstance] merchantTypeList];
    NSLog(@"typeDic: %@",typeDic);
    if (typeDic != nil) {
        
        //本地存在，直接加载，并发起版本号校验
        merchantTypeArray = typeDic [DATA];
        NSLog(@"merchantTypeArray:%@",merchantTypeArray);
        [self initHeadScrollViewWithArray:merchantTypeArray];
        
        //发起商户类型版本号校验
        [self requestGetMerchantTypeList_Version];
    }
    else {
        [self requestGetMerchantTypeList];
    }
    
    if (! [cityName isEqualToString:@""]) {
        cityObject = [app selectDataWithName:cityName];    //获取对应城市对象
        NSString *parentID = cityObject.current_code;
        countysArray = [app selectDataWithParentID:parentID];   //获取对应区县数组对象
        [self.cityCollectionView reloadData];   //刷新区县列表
    }
    
    
    
}



#pragma mark - 一元抢购点击事件
-(void)onaYuanAcivityTapAction{
    NSLog(@"点击了一元抢购商品");
}

#pragma mark - 导航栏右部按钮宽度自动调整
-(void)adjustLeftBtnFrameWithTitle:(NSString *)str {
    NSDictionary *attributes = @{NSFontAttributeName : _leftButn.titleLabel.font};
    CGSize size = [str sizeWithAttributes:attributes];
    NSLog(@"size: %@",NSStringFromCGSize(size));
    if (size.width <= LeftBtn_MaxWidth) {
        _leftButn.frame = CGRectMake(0, 9, size.width + 12 + Access_interval_Width, size.height);
    }
    else {
        _leftButn.frame = CGRectMake(0, 9, LeftBtn_MaxWidth + 12 + Access_interval_Width, size.height);
    }
    
    [_leftButn setImageEdgeInsets:UIEdgeInsetsMake(0, _leftButn.frame.size.width - 12, 0, 0)];
    [_leftButn setTitle:str forState:UIControlStateNormal];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:_leftButn];
    
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    titleView = [[TitleVIew alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH -_leftButn.frame.size.width-70, 30)];
    
    [titleView.saoMaBtn addTarget:self action:@selector(SaoMa:) forControlEvents:UIControlEventTouchUpInside];
    [titleView.searchBtn addTarget:self action:@selector(tiaoSou) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = titleView;
    
}


#pragma mark - AJAdViewDelegate
- (NSInteger)numberInAdView:(AJAdView *)adView{
    return [_adArray count];
}

- (NSString *)imageUrlInAdView:(AJAdView *)adView index:(NSInteger)index{
    return _adArray[index] [@"img_url"];
}

- (NSString *)titleStringInAdView:(AJAdView *)adView index:(NSInteger)index {
    return _adArray[index] [@"title"];
}
#pragma mark - 广告轮播点击事件
- (void)adView:(AJAdView *)adView didSelectIndex:(NSInteger)index{
    NSLog(@"--%ld--",(long)index);
    NSDictionary *dic = _adArray [index];
    
    NSString *type = dic[@"link_type"];
    int ink_type = [type intValue];
    
    if (ink_type==0) {
        WebViewController *web = [[WebViewController alloc] init];
        NSString *url = [NSString stringWithFormat:@"banner/load.htm?id=%@",dic[@"id"]];
        web.webUrlStr = NewRequestURL(url);
        web.titleStr = dic [@"title"];
        web.isFrame = @"2";
        web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];
        
    }else if (ink_type == 1){
        GoodsDetailViewController *view = [[GoodsDetailViewController alloc]init];
        view.goods_id = dic[@"good_id"];
        view.isHome = @"1";
        view.hidesBottomBarWhenPushed = YES;
        view.cao = [NSString stringWithFormat:@"%@",dic[@"good_id"]];
        [self.navigationController pushViewController:view animated:YES];
    }else if (ink_type == 2){
        WebViewController *web = [[WebViewController alloc] init];
        web.webUrlStr = dic[@"link_url"];
        web.titleStr = dic [@"title"];
        web.hidesBottomBarWhenPushed = YES;
        web.isFrame = @"2";
        [self.navigationController pushViewController:web animated:YES];
    }
    
}

// 大转盘按钮事件
/*#pragma mark - 活动actions
 -(void)choujiang {  //大转盘
 BOOL isLogined = [[GlobalSetting shareGlobalSettingInstance] isLogined];
 
 if (isLogined) {    //已登录
 WebViewController *web = [[WebViewController alloc] init];
 NSString *urlStr = [NSString stringWithFormat:@"%@?m=%@&mobile=%@",_dazhuanpanDic [@"UrlPath"],[[GlobalSetting shareGlobalSettingInstance] userID],[[GlobalSetting shareGlobalSettingInstance] mMobile]];
 web.webUrlStr = urlStr;
 web.titleStr = _dazhuanpanDic [@"Title"];
 web.canShare = YES; //设置可分享
 web.hidesBottomBarWhenPushed = YES;
 [self.navigationController pushViewController:web animated:YES];
 }
 else {
 
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录，请先登录！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
 alert.tag = 4040;
 [alert show];
 }
 }
 
 //刮刮乐按钮事件
 -(void)zajindan {   //砸金蛋
 BOOL isLogined = [[GlobalSetting shareGlobalSettingInstance] isLogined];
 
 if (isLogined) {    //已登录
 WebViewController *web = [[WebViewController alloc] init];
 NSString *urlStr = [NSString stringWithFormat:@"%@?m=%@&mobile=%@",_zajindanDic [@"UrlPath"],[[GlobalSetting shareGlobalSettingInstance] userID],[[GlobalSetting shareGlobalSettingInstance] mMobile]];
 web.webUrlStr = urlStr;
 web.titleStr = _zajindanDic [@"Title"];
 web.canShare = YES; //设置可分享
 web.hidesBottomBarWhenPushed = YES;
 [self.navigationController pushViewController:web animated:YES];
 }
 else {
 
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录，请先登录！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
 alert.tag = 4040;
 [alert show];
 }
 }*/

#pragma mark -  go to ShopSearchViewController--TSF
- (void)tiaoSou {
    
    ShopSearchViewController *view = [[ShopSearchViewController alloc]init];
    view.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:view animated:NO];
}

#pragma mark - UISearchBarDelegate
//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
//    NSLog(@"推出搜索页");
//    ShopSearchViewController *searchVC = [[ShopSearchViewController alloc] init];
//    searchVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:searchVC animated:YES];
//    return NO;
//}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (! _hud) {
        _hud = [[MBProgressHUD alloc] initWithView:app.window];
        [app.window addSubview:_hud];      }
    
    if (!_networkConditionHUD) {
        _networkConditionHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_networkConditionHUD];
    }
    _networkConditionHUD.mode = MBProgressHUDModeText;
    _networkConditionHUD.yOffset = APP_HEIGHT/2 - HUDBottomH;
    _networkConditionHUD.margin = HUDMargin;
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];  //上架版本号
    NSString *locationAppVersion = [[GlobalSetting shareGlobalSettingInstance] appVersion];
    if (! [[GlobalSetting shareGlobalSettingInstance] isNotFirst] || ! [locationAppVersion isEqual:appVersion]) {   //第一次进入应用
        
        //        if (! _firstHud) {
        //            _firstHud = [[MBProgressHUD alloc] initWithWindow:app.window];
        //            _firstHud.labelText = @"正在更新城市数据...";
        //            [app.window addSubview:_firstHud];
        //        }
        //        [_firstHud show:YES];
        //
        ////        dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //
        //            NSError* err = nil;
        //            NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"CityDistricts" ofType:@"json"];
        //            NSArray* cityDistricts = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath] options:kNilOptions error:&err];
        //            //        NSLog(@"Importd cityDistricts: %@", cityDistricts);
        ////            if ([[app selectAllCoreObject] count] == 0) {
        //            [app deleteAllObjects];
        //                for (NSDictionary *dic in cityDistricts) {
        //                    [app insertCoreDataWithObjectItem:dic];
        //                }
        ////            }
        //
        ////            dispatch_async(dispatch_get_main_queue(), ^{
        ////                    //（需要放在主线程中执行UI更新）
        //////                [_firstHud hide:YES];
        ////            });
        ////        });
        
        
        //        //复制本地数据库文件到安装目录-------------------------------------------------------------------//
        NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        //CoreData是建立在SQLite之上的，数据库名称需与Xcdatamodel文件同名
        NSURL *storeUrl = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"JFB.sqlite"]];
        NSURL *storeUrl1 = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"JFB.sqlite-shm"]];
        NSURL *storeUrl2 = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"JFB.sqlite-wal"]];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:[storeUrl path]]) {
            NSURL *preloadURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"JFB" ofType:@"sqlite"]];
            NSError* err = nil;
            if (![[NSFileManager defaultManager] copyItemAtURL:preloadURL toURL:storeUrl error:&err]) {
                NSLog(@"Oops, could copy preloaded data");
            }
            
            NSURL *preloadURL1 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"JFB" ofType:@"sqlite-shm"]];
            if (![[NSFileManager defaultManager] copyItemAtURL:preloadURL1 toURL:storeUrl1 error:&err]) {
                NSLog(@"Oops, could copy preloaded data");
            }
            
            NSURL *preloadURL2 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"JFB" ofType:@"sqlite-wal"]];
            if (![[NSFileManager defaultManager] copyItemAtURL:preloadURL2 toURL:storeUrl2 error:&err]) {
                NSLog(@"Oops, could copy preloaded data");
            }
        }
        //----------------------------------------------------------------------------------//
        
    }
    
    //注册通知，当城市列表数据下载完成后调用
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAlreadyDownLoadCityCountys:) name:@"CityCountysAlreadyDownLoad" object:nil];
    
   
}

-(void)viewWillAppear:(BOOL)animated {
    _locService.delegate = self;
    _searcher.delegate = self;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];  //上架版本号
    NSString *locationAppVersion = [[GlobalSetting shareGlobalSettingInstance] appVersion];
    
    if (! [[GlobalSetting shareGlobalSettingInstance] isNotFirst] || ! [locationAppVersion isEqual:appVersion]) {
        NSArray *imageArr = nil;//@[@"guide1.png",@"guide2.png",@"guide3.png"];
        imageArr = @[@"guide3",@"guide2",@"guide1"];
        
        self.loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT + 20) withImagesArr:imageArr];
        
        self.loadingView.delegate = self;
        
        app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        [app.window addSubview:self.loadingView];
        
        //        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        //        NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];  //上架版本号
        //        [[GlobalSetting shareGlobalSettingInstance] setAppVersion:appVersion];
        //        [[GlobalSetting shareGlobalSettingInstance] setIsNotFirst:YES];
        //
        //        [self requestGetCityDistricts];
    }
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
}
 
-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CityCountysAlreadyDownLoad" object:nil];
    _locService.delegate = nil;
    _searcher.delegate = nil;
}

#pragma mark -省市数据下载完成后调用通知
-(void)didAlreadyDownLoadCityCountys:(NSNotification *)notification {
    if ([notification.name isEqualToString:@"CityCountysAlreadyDownLoad"]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CityCountysAlreadyDownLoad" object:nil];
        
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请到设置-隐私-定位服务中打开定位权限！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        [_locService startUserLocationService];
    }
}

#pragma mark -
#pragma mark LoadingViewDelegate
//引导页消失的方式
-(void)didEnterAppWithStyle:(NSInteger)style{
    if (style == 1) {
        [self loadingViewDisappearAnimation];
    }
    else {
        [self.loadingView removeFromSuperview];
        self.loadingView = nil;
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];  //上架版本号
        [[GlobalSetting shareGlobalSettingInstance] setAppVersion:appVersion];
        [[GlobalSetting shareGlobalSettingInstance] setIsNotFirst:YES];
        
       // [self requestGetCityDistrictsNew];
    }
}

//引导页消失的动画
-(void) loadingViewDisappearAnimation{
    [UIView animateWithDuration:1 animations:^{
        self.loadingView.transform = CGAffineTransformMakeScale(2, 2);
        self.loadingView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.loadingView.transform = CGAffineTransformIdentity;
            [self.loadingView removeFromSuperview];
            self.loadingView = nil;
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];  //上架版本号
            [[GlobalSetting shareGlobalSettingInstance] setAppVersion:appVersion];
            [[GlobalSetting shareGlobalSettingInstance] setIsNotFirst:YES];
            
           // [self requestGetCityDistrictsNew];
        }
    }];
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


#pragma mark - 定位代理
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"heading is %@",userLocation.heading);
}

- (void)didFailToLocateUserWithError:(NSError *)error {
    [_locService stopUserLocationService];
    
    /************  定位失败，赋初值 *************/
    NSDictionary *locationDic = [NSDictionary dictionaryWithObjectsAndKeys:Latitude,@"latitude",Longitude,@"longitude", nil];
    //存储当前位置坐标
    [[GlobalSetting shareGlobalSettingInstance] setMyLocationWithDic:locationDic];
    NSLog(@"error is %@",[error description]);
    
    if ([cityName isEqualToString:@""] || cityName == nil) { //如果用户还没有选择过城市，那么默认显示定位城市名
        NSString *msgStr = [NSString stringWithFormat:@"获取位置信息失败！将为您展示默认城市的商家信息"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msgStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 555;
        [alert show];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"定位失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 8448;
        [alert show];
    }
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    if (userLocation) {
        [_locService stopUserLocationService];
        
        
        NSString *locationCoordinateStr = [NSString stringWithFormat:@"{\"latitude\":%f,\"longitude\":%f}",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude];
        NSLog(@"locationCoordinateStr: %@",locationCoordinateStr);
        
        NSString *lat = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
        NSString *lon = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
        NSDictionary *locationDic = [NSDictionary dictionaryWithObjectsAndKeys:lat,@"latitude",lon,@"longitude", nil];
        //存储当前位置坐标
        [[GlobalSetting shareGlobalSettingInstance] setMyLocationWithDic:locationDic];
        
        [self getReverseGeoCodeWithLocation:userLocation];
    }
}

-(void)getReverseGeoCodeWithLocation:(BMKUserLocation *)userLocation
{
    //    CLLocationCoordinate2D coor;
    //    coor.latitude = [@"45" doubleValue];
    //    coor.longitude = [@"75" doubleValue];
    
    //            发起反向地理编码检索
    CLLocationCoordinate2D pt = userLocation.location.coordinate;
    NSLog(@"%lf,%lf",pt.latitude,pt.longitude);
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
                                                            BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //      在此处理正常结果
        NSLog(@"result.addressDetail.city: %@,result.addressDetail.streetName: %@,result.address: %@",result.addressDetail.city,result.addressDetail.streetName,result.address);
        
        NSLog(@"%@ --- %@",cityName,result.addressDetail.city);
        
        if( [cityName isEqualToString:@"(null)"]||cityName==nil||[cityName isEqualToString:@"<null>"] || [cityName isEqualToString:@""]){
            
        }else{
            if(![cityName isEqualToString:result.addressDetail.city]){
            nimaCity = result.addressDetail.city;
            NSString *msgStr = [NSString stringWithFormat:@"您当前定位的城市为【%@】是否切换到该城市！",result.addressDetail.city];
            UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"提示" message:msgStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alerView.tag = 4848;
            [alerView show];
           
        }
    }
        
        NSString *cityNameStr = result.addressDetail.city;
        if ([cityName isEqualToString:@""] || cityName == nil) { //如果用户还没有选择过城市，那么默认显示定位城市名
            if ([cityNameStr length] > 0) {
                locationCityName = cityNameStr;
                self.currentCityL.text = locationCityName;
                if ([[app selectAllCoreObject] count]) {
                    CityDistrictsCoreObject *cityInfo = [app selectDataWithName:locationCityName];
                    
                    if (! [cityInfo.isopen boolValue]) {
                        NSString *msgStr = [NSString stringWithFormat:@"您当前定位的城市为【%@】暂未开通！请选择一个城市！",locationCityName];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msgStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        alert.tag = 888;
                        [alert show];
                    }
                    cityObject = cityInfo;
                    NSString *parentID = cityObject.current_code;
                    countysArray = [app selectDataWithParentID:parentID];   //获取对应区县数组对象
                    cityID = cityInfo.areaId;
                    current_city_code = cityInfo.current_code;
                    cityName = cityInfo.areaName;
                    countyID = @"";
                    countyName = @"";
                    current_county_code = @"";
                    
                    [mutabDic setObject:[NSNumber numberWithInteger:0] forKey:@"selectItem"];  //更新字典中selectItem的值
                    [mutabDic setObject:cityID forKey:@"cityID"];
                    [mutabDic setObject:cityName forKey:@"areaName"];
                    [mutabDic setObject:countyID forKey:@"countyID"];
                    [mutabDic setObject:countyName forKey:@"countName"];
                    [mutabDic setObject:current_city_code forKey:@"current_city_code"];
                    [mutabDic setObject:current_county_code forKey:@"current_county_code"];
                    NSLog(@"mutabDic: %@",mutabDic);
                    [[GlobalSetting shareGlobalSettingInstance] setHomeSelectedDic:mutabDic];
                    
                    [self.cityCollectionView reloadData];   //刷新地址
                    
                    [self adjustLeftBtnFrameWithTitle:locationCityName];
                    
                    //定位成功并赋值成功后刷新推荐商户数据
                    [self requestGetRecommendShopListWithLocationDic:[[GlobalSetting shareGlobalSettingInstance] myLocation]];
                }
                else {
                    NSString *msgStr = [NSString stringWithFormat:@"全国省市区县数据未下载成功，请点击确定按钮重新下载！"];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msgStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alert.tag = 111;
                    [alert show];
                }
            }
            else {
                NSString *msgStr = [NSString stringWithFormat:@"获取位置信息失败！将为您展示默认城市的商家信息"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msgStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alert.tag = 555;
                [alert show];
            }
        }
        else if (cityName != nil) {
            if ([cityNameStr length] > 0) {
                CityDistrictsCoreObject *cityInfo = [app selectDataWithName:locationCityName];
                if (! [cityName isEqualToString:locationCityName] && isChangeToMinCity && [cityInfo.isopen boolValue]) {  //定位城市与本地存储的城市民不一致，则提示用户
                    NSString *msgStr = [NSString stringWithFormat:@"您当前定位的城市为【%@】是否需要切换到该城市？",locationCityName];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msgStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.tag = 666;
                    [alert show];
                }
            }
            else {
                
            }
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取城市信息失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}



#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (alertView.tag == 8448) {
        NSString *text = self.leftButn.titleLabel.text;
        
        NSLog(@"%@",text);
        text = [text checkStringIsNullWithNullString:@"衡阳市"];
        self.currentCityL.text =text;
        NSLog(@"count: %lu",(unsigned long)[[app selectAllCoreObject] count]);
        if ([[app selectAllCoreObject] count]) {
            CityDistrictsCoreObject *cityInfo = [app selectDataWithName:text];
            cityObject = cityInfo;
            NSString *parentID = cityObject.areaId;
            countysArray = [app selectDataWithParentID:parentID];   //获取对应区县数组对象
            cityID = cityInfo.areaId;
            current_city_code = cityInfo.current_code;
            cityName = cityInfo.areaName;
            countyID = @"";
            countyName = @"";
            current_county_code = @"";
            
            [mutabDic setObject:[NSNumber numberWithInteger:0] forKey:@"selectItem"];  //更新字典中selectItem的值
            [mutabDic setObject:cityID forKey:@"cityID"];
            [mutabDic setObject:cityName forKey:@"areaName"];
            [mutabDic setObject:countyID forKey:@"countyID"];
            [mutabDic setObject:countyName forKey:@"countName"];
            [mutabDic setObject:current_city_code forKey:@"current_city_code"];
            [mutabDic setObject:current_county_code forKey:@"current_county_code"];
            NSLog(@"mutabDic: %@",mutabDic);
            [[GlobalSetting shareGlobalSettingInstance] setHomeSelectedDic:mutabDic];
            
            [self.cityCollectionView reloadData];   //刷新地址
            
            [self adjustLeftBtnFrameWithTitle:text];
            
            //定位成功并赋值成功后刷新推荐商户数据
            [self getMerchantListWtih:text withCityAreaName:text];
            
            
        }

        
    }else if (alertView.tag == 555) {
       
            NSString *text = self.leftButn.titleLabel.text;
        
        
            text = @"衡阳市";
            self.currentCityL.text =text;
            NSLog(@"count: %lu",(unsigned long)[[app selectAllCoreObject] count]);
            if ([[app selectAllCoreObject] count]) {
                CityDistrictsCoreObject *cityInfo = [app selectDataWithName:text];
                cityObject = cityInfo;
                NSString *parentID = cityObject.areaId;
                countysArray = [app selectDataWithParentID:parentID];   //获取对应区县数组对象
                cityID = cityInfo.areaId;
                current_city_code = cityInfo.current_code;
                cityName = cityInfo.areaName;
                countyID = @"";
                countyName = @"";
                current_county_code = @"";
                
                [mutabDic setObject:[NSNumber numberWithInteger:0] forKey:@"selectItem"];  //更新字典中selectItem的值
                [mutabDic setObject:cityID forKey:@"cityID"];
                [mutabDic setObject:cityName forKey:@"areaName"];
                [mutabDic setObject:countyID forKey:@"countyID"];
                [mutabDic setObject:countyName forKey:@"countName"];
                [mutabDic setObject:current_city_code forKey:@"current_city_code"];
                [mutabDic setObject:current_county_code forKey:@"current_county_code"];
                NSLog(@"mutabDic: %@",mutabDic);
                [[GlobalSetting shareGlobalSettingInstance] setHomeSelectedDic:mutabDic];
                
                [self.cityCollectionView reloadData];   //刷新地址
                
                [self adjustLeftBtnFrameWithTitle:@"衡阳市"];
                
                //定位成功并赋值成功后刷新推荐商户数据
                [self requestGetRecommendShopListWithLocationDic:[[GlobalSetting shareGlobalSettingInstance] myLocation]];

    
            }
        else {
            NSString *msgStr = [NSString stringWithFormat:@"全国省市区县数据未下载成功，请点击确定按钮重新下载！"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msgStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 111;
            [alert show];
        }
    }
    else if (alertView.tag == 666) {
        isChangeToMinCity = NO;
        if (buttonIndex == 1) {
            //切换回当前定位城市
            self.currentCityL.text = locationCityName;
            
            CityDistrictsCoreObject *cityInfo = [app selectDataWithName:locationCityName];
            cityObject = cityInfo;
            NSString *parentID = cityObject.areaId;
            countysArray = [app selectDataWithParentID:parentID];   //获取对应区县数组对象
            cityID = cityInfo.areaId;
            cityName = cityInfo.areaName;
            countyID = @"";
            countyName = @"";
            current_city_code = cityInfo.current_code;
            current_county_code = @"";
            
            
            [mutabDic setObject:[NSNumber numberWithInteger:0] forKey:@"selectItem"];  //更新字典中selectItem的值
            [mutabDic setObject:cityID forKey:@"cityID"];
            [mutabDic setObject:cityName forKey:@"areaName"];
            [mutabDic setObject:countyID forKey:@"countyID"];
            [mutabDic setObject:countyName forKey:@"countName"];
            [mutabDic setObject:current_city_code forKey:@"current_city_code"];
            [mutabDic setObject:current_county_code forKey:@"current_county_code"];
            NSLog(@"mutabDic: %@",mutabDic);
            [[GlobalSetting shareGlobalSettingInstance] setHomeSelectedDic:mutabDic];
            
            [self.cityCollectionView reloadData];   //刷新地址
            
            [self adjustLeftBtnFrameWithTitle:locationCityName];
            
            //定位成功并赋值成功后刷新推荐商户数据
            [self requestGetRecommendShopListWithLocationDic:[[GlobalSetting shareGlobalSettingInstance] myLocation]];
        }
    } else if (alertView.tag == 4848) {
        if (buttonIndex == 1) {
            [self getMerchantListWtih:nimaCity withCityAreaName:nimaCity];
        //    NSString *cityNameStr = result.addressDetail.city;
            
//            
//            if ([cityName isEqualToString:@""] || cityName == nil) { //如果用户还没有选择过城市，那么默认显示定位城市名
//                if ([cityNameStr length] > 0) {
//                    
            
                    
              //      locationCityName = cityNameStr;
                    self.currentCityL.text = nimaCity;
                    if ([[app selectAllCoreObject] count]) {
                        CityDistrictsCoreObject *cityInfo = [app selectDataWithName:nimaCity];
                        
                        if (! [cityInfo.isopen boolValue]) {
                            NSString *msgStr = [NSString stringWithFormat:@"您当前定位的城市为【%@】暂未开通！请选择一个城市！",nimaCity];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msgStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                            alert.tag = 888;
                            [alert show];
                        }
                        cityObject = cityInfo;
                        NSString *parentID = cityObject.current_code;
                        countysArray = [app selectDataWithParentID:parentID];   //获取对应区县数组对象
                        cityID = cityInfo.areaId;
                        current_city_code = cityInfo.current_code;
                        cityName = cityInfo.areaName;
                        countyID = @"";
                        countyName = @"";
                        current_county_code = @"";
                        
                        [mutabDic setObject:[NSNumber numberWithInteger:0] forKey:@"selectItem"];  //更新字典中selectItem的值
                        [mutabDic setObject:cityID forKey:@"cityID"];
                        [mutabDic setObject:cityName forKey:@"areaName"];
                        [mutabDic setObject:countyID forKey:@"countyID"];
                        [mutabDic setObject:countyName forKey:@"countName"];
                        [mutabDic setObject:current_city_code forKey:@"current_city_code"];
                        [mutabDic setObject:current_county_code forKey:@"current_county_code"];
                        NSLog(@"mutabDic: %@",mutabDic);
                        [[GlobalSetting shareGlobalSettingInstance] setHomeSelectedDic:mutabDic];
                        
                        [self.cityCollectionView reloadData];   //刷新地址
                        
                        [self adjustLeftBtnFrameWithTitle:nimaCity];
                        
                        //定位成功并赋值成功后刷新推荐商户数据
                        [self requestGetRecommendShopListWithLocationDic:[[GlobalSetting shareGlobalSettingInstance] myLocation]];
                    }

        }else if (buttonIndex==0){
            [self getMerchantListWtih:self.leftButn.titleLabel.text withCityAreaName:self.leftButn.titleLabel.text];
            
        }
    }

    else if (alertView.tag == 888) {
        CitySelectViewController *selectVC = [[CitySelectViewController alloc] init];
        //        selectVC.citysDic = chongzuDic;
        selectVC.selectDelegate = self;
        selectVC.isMustSelect = YES;
        selectVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:selectVC animated:YES];
    }
    else if (alertView.tag == 4040) {
        if (buttonIndex == 1) {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            loginVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }
    else if (alertView.tag == 111) {
        [self requestGetCityDistrictsNew];     //重新下载省市数据
    }else if (alertView.tag == 52013){
        if (buttonIndex == 1) {
            
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:versionDic[@"url"]]];
        }
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [recommendArray count] ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 44;
    }
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"商家精选";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
//    else if (indexPath.row == [recommendArray count] +1) {
//        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//        cell.textLabel.textAlignment = NSTextAlignmentCenter;
//        cell.textLabel.text = @"查看所有商家";
//        return cell;
//    }
    else {
        NSDictionary *dic = recommendArray[indexPath.row -1];
        
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
    if (indexPath.row == 0) {
        
    }
    else if (indexPath.row == [recommendArray count] + 1) {
        NSLog(@"查看全部商家");
        ShopListVC *listVC = [[ShopListVC alloc] init];
        listVC.menu_subtitle = @"全部分类";
        listVC.menu_code = @"";
        listVC.typeID = @"";
        
        [listVC.typeBtn setTitle:@"全部分类" forState:UIControlStateNormal];
        listVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:listVC animated:YES];
    }
    else {
        NSDictionary *dic = recommendArray [indexPath.row - 1];
        ShopDetailViewController *detailVC = [[ShopDetailViewController alloc] init];
        detailVC.merchantdataDic = dic;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - 顶部商家类型视图
-(void)initHeadScrollViewWithArray:(NSArray *)dataArray {
    
    
    for (UIView *view in self.typeScrollView.subviews) {
        
        [view removeFromSuperview];
        
    }
    
    int page = (int)  (([dataArray count] - 1) / 4 + 1); //总页数
    if (page > 1) {
        self.typePageControl.hidden = NO;
    }
    else {
        self.typePageControl.hidden = YES;
    }
    self.typePageControl.numberOfPages = page;
    
    self.typeScrollView.contentSize = CGSizeMake(page * SCREEN_WIDTH, 0);
    
    int rowMargin = Head_ScrollView_Height - Head_PageControl_Height - Head_button_Height * 2 - 20; //按钮行间距
    //
    int myHeight=(int)SCREEN_HEIGHT;
    float imageViewW;
    float imageViewMarginX;
    if (myHeight==480 || myHeight==568) {
        imageViewW=(SCREEN_WIDTH-30-6*3)/4;
    }else{
        imageViewW=(SCREEN_WIDTH-30-12*3)/4;
    }
    
    float imageViewH=SCREEN_HEIGHT*(84/RealSrceenHight);
    
    int p = 0;
    for (int a = 0; a < page; ++ a) {
        for (int m = 0; m < 1; ++ m) {
            
            
            
            for (int n = 0; n < 4; ++ n) {
                if (p < [dataArray count]) {
                    
                    if (myHeight==480 || myHeight==568) {
                        imageViewMarginX=6 + n * (imageViewW+12) + a * SCREEN_WIDTH;
                    }else{
                        imageViewMarginX=15 + n * (imageViewW+12) + a * SCREEN_WIDTH;
                    }
                    NSDictionary *dic = [dataArray objectAtIndex:p];
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageViewMarginX , SCREEN_HEIGHT*(10/RealSrceenHight) + m * (80 + rowMargin), imageViewW, imageViewH)];
                    imageView.image = [UIImage imageNamed:@"btnSuperViewBG"];
                    
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    //                    button.frame = CGRectMake(imageView.frame.origin.x+12, 20 + m * (80 + rowMargin), Head_button_Width, Head_button_Height);
                    button.width=SCREEN_WIDTH*(48/RealSrceenWidth);
                    button.height=SCREEN_HEIGHT*(48/RealSrceenHight);
                    button.y=SCREEN_HEIGHT*(20/RealSrceenHight)+m*(80+rowMargin);
                    button.x=imageView.x+(imageView.width-button.width)/2;
                    
                    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0,             Head_button_Height - Head_button_Width, 0);
                    button.tag = p + 1000;
                    
                    
                    [button sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"icon_url"]] forState:UIControlStateNormal placeholderImage:IMG(@"bg_merchant_photo_placeholder")];
                    
                    
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    
                    UILabel *subtitleL = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*(48/RealSrceenHight), SCREEN_WIDTH*(48/RealSrceenWidth), SCREEN_HEIGHT*(20/RealSrceenHight))];
                    subtitleL.textAlignment = NSTextAlignmentCenter;
                    subtitleL.font = [UIFont systemFontOfSize:12];
                    subtitleL.textColor=[UIColor colorWithRed:36/255. green:36/255. blue:36/255. alpha:1];
                    subtitleL.text = [dic objectForKey:@"menu_subtitle"];
                    [button addSubview:subtitleL];
                    
                    
                    
                    [button addTarget:self action:@selector(buttontouchAction:) forControlEvents:UIControlEventTouchUpInside];
                    
                    
                    [self.typeScrollView addSubview:imageView];
                    [self.typeScrollView addSubview:button];
                    
                    
                }
                p ++;
            }
        }
    }
}

#pragma mark - 分类点击事件
-(void)buttontouchAction:(UIButton *)sender {
    NSLog(@"sender.tag: %ld",(long)sender.tag);
    NSDictionary *dic = [merchantTypeArray objectAtIndex:sender.tag - 1000];
    //    NSLog(@"sender.icon_url: %@",[dic objectForKey:@"icon_url"]);
    NSLog(@"menu_code: %@",[dic objectForKey:@"menu_code"]);
    
    
    ShopListVC *listVC = [[ShopListVC alloc] init];
    listVC.menu_subtitle = [dic objectForKey:@"menu_subtitle"];
    listVC.menu_code = [dic objectForKey:@"menu_code"];
    listVC.typeID = dic [@"menu_code"];
    [listVC.typeBtn setTitle:[dic objectForKey:@"menu_subtitle"] forState:UIControlStateNormal];
    listVC.hidesBottomBarWhenPushed = YES;
    listVC.caoNiMaDic = caoNiMaDic;
    [self.navigationController pushViewController:listVC animated:YES];
    
}

#pragma mark --UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [countysArray count] + 1; //增加“全部”区县
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCityCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCelllIdentifier forIndexPath:indexPath];
    [cell.cityBtn addTarget:self action:@selector(selectCityAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.cityBtn.tag = indexPath.item + 3000;
    
    if (indexPath.item == 0) {
        [cell.cityBtn setTitle:@"全部" forState:UIControlStateNormal];
    }
    else {
        
        CityDistrictsCoreObject *county = (CityDistrictsCoreObject *)countysArray[indexPath.item - 1];
        [cell.cityBtn setTitle:county.areaName forState:UIControlStateNormal];
    }
    
    if (indexPath.item == selectItem) {
        cell.cityBtn.selected = YES;
    }
    else {
        cell.cityBtn.selected = NO;
    }
    
    return cell;
}

#pragma mark --UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"您选中了----%ld",(long)indexPath.row);
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}



#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(80, 30);
    return size;
}


//itemCell间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


#pragma mark - cell上按钮方法
-(void)selectCityAction:(UIButton *)sender {
    
    NSInteger rowInt = sender.tag - 3000;
    NSLog(@"rowInt: %ld",(long)rowInt);
    selectItem = rowInt;
    if (rowInt == 0) {  //选择全部
        countyID = @"";
        countyName = @"";
        current_county_code = @"";
        [mutabDic setObject:[NSNumber numberWithInteger:selectItem] forKey:@"selectItem"];  //更新字典中selectItem的值
        [mutabDic setObject:cityID forKey:@"cityID"];
        [mutabDic setObject:cityName forKey:@"areaName"];
        [mutabDic setObject:countyID forKey:@"countyID"];
        [mutabDic setObject:countyName forKey:@"countName"];
        [mutabDic setObject:current_city_code forKey:@"current_city_code"];
        [mutabDic setObject:current_county_code forKey:@"current_county_code"];
        NSLog(@"mutabDic: %@",mutabDic);
        [[GlobalSetting shareGlobalSettingInstance] setHomeSelectedDic:mutabDic];
        [self adjustLeftBtnFrameWithTitle:[NSString stringWithFormat:@"%@",cityName]];
        [self getMerchantListWtih:cityName withCityAreaName:cityName];
        
    }
    
    else {
        CityDistrictsCoreObject *county = (CityDistrictsCoreObject *)countysArray[rowInt -1];
        //    [[GlobalSetting shareGlobalSettingInstance] setCountyObject:county];    //存储选中的County对象
        [mutabDic setObject:[NSNumber numberWithInteger:selectItem] forKey:@"selectItem"];  //更新字典中selectItem的值
        NSLog(@"cityID: %@",cityID);
        [mutabDic setObject:cityID forKey:@"cityID"];
        [mutabDic setObject:cityName forKey:@"areaName"];
        [mutabDic setObject:county.areaId forKey:@"countyID"];
        [mutabDic setObject:county.areaName forKey:@"countName"];
        [mutabDic setObject:current_city_code forKey:@"current_city_code"];
        [mutabDic setObject:county.current_code forKey:@"current_county_code"];
        NSLog(@"county.current_code: %@",county.current_code);
        NSLog(@"mutabDic: %@",mutabDic);
        [[GlobalSetting shareGlobalSettingInstance] setHomeSelectedDic:mutabDic];
        NSLog(@"HomeSelectedDic: %@",[[GlobalSetting shareGlobalSettingInstance] homeSelectedDic]);
        countyID = county.areaId;  //区县赋值ID
        countyName = county.areaName;   //区县名称
        NSLog(@"%@",countyName);
        current_county_code = county.current_code;
        [self adjustLeftBtnFrameWithTitle:[NSString stringWithFormat:@"%@--%@",cityName,county.areaName]];
        [self getMerchantListWtih:county.areaName withCityAreaName:county.areaName];
    }
    
    
    
    [self.cityCollectionView reloadData];
    
    //存储当前位置坐标
    
    //选择完后刷新推荐商户数据
    
    
    [self appearOrDismissCityView:YES]; //hidden
    _leftButn.selected = NO;
}

-(void)cancelSelectCity {
    [self appearOrDismissCityView:YES];
    _leftButn.selected = NO;
}


#pragma mark - scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.typePageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
}

- (IBAction)changeCityAction:(id)sender {
    NSLog(@"切换城市！");
    _leftButn.selected = NO;
    [self appearOrDismissCityView:YES];
    
    CitySelectViewController *selectVC = [[CitySelectViewController alloc] init];
    //    selectVC.citysDic = chongzuDic;
    selectVC.selectDelegate = self;
    selectVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:selectVC animated:YES];
}

-(void)toSelectCity:(UIButton *)sender {
    NSLog(@"选择城市！");
    sender.selected = ! sender.selected;
    if (sender.selected) {
        [self appearOrDismissCityView:NO];
    }
    else {
        [self appearOrDismissCityView:YES];
    }
}

//-(void)animationWithViewAlph:(int)alph {
//    [UIView animateWithDuration:0.5 animations:^{
//        self.citySelectView.alpha = alph;
//    }];
//}

-(void)appearOrDismissCityView:(BOOL)hidden {
    self.citySelectBgView.hidden = hidden;
    self.citySelectView.hidden = hidden;
}

-(void)toMapView {
    ShopMapViewController *mapVC = [[ShopMapViewController alloc] init];
    mapVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mapVC animated:YES];
}



#pragma mark - AlreadySelectCityDelegate切换城市
-(void)alreadySelectCity:(CityDistrictsCoreObject *)city {
    
    
    [self adjustLeftBtnFrameWithTitle:city.areaName];
    selectItem = 0;  //默认选中“全部”
    
    isChangeToMinCity = NO;
    
    cityObject = city;
    cityName = city.areaName;
    
    countyID = @"";
    countyName = @"";
    current_city_code = city.current_code;
    current_county_code = @"";
    
    self.currentCityL.text = cityName;
    
    JFBLog(@"===============%@",cityName);
    [mutabDic setObject:[NSNumber numberWithInteger:0] forKey:@"selectItem"];  //更新字典中selectItem的值
    
    [mutabDic setObject:cityName forKey:@"areaName"];
    [mutabDic setObject:countyID forKey:@"countyID"];
    [mutabDic setObject:countyName forKey:@"countName"];
    [mutabDic setObject:current_city_code forKey:@"current_city_code"];
    [mutabDic setObject:current_county_code forKey:@"current_county_code"];
    
    [[GlobalSetting shareGlobalSettingInstance] setHomeSelectedDic:mutabDic];
    
    NSString *parentID = cityObject.current_code;
    countysArray = [app selectDataWithParentID:parentID];   //获取对应区县数组对象
    NSLog(@"areaName: %@,countysArray: %@",city.areaName,countysArray);
    [self.cityCollectionView reloadData];
    //选择完后刷新推荐商户数据
    [self getMerchantListWtih:city.areaName withCityAreaName:city.areaName];
    
}

#pragma mark-请求首页的活动
-(void)requestGetHomeActivityList{
    [_hud show:YES];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:@"GetHomeActivityList" object:nil];
    
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"GetHomeActivityList", @"op", nil];
    
    NSString *url = [NSString stringWithFormat:@"banner/activity.json"];
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL(url) delegate:nil params:nil info:infoDic];
}
#pragma mark - 广告轮播图请求
-(void)requestGetBanner {
    [_hud show:YES];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:GetBanner object:nil];
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:GetBanner, @"op", nil];
    
    
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL(@"banner/list.json") delegate:nil params:nil info:infoDic];
}



/********* 获取城市区县接口版本号，存入本地，当本地版本号和服务器版本号不一致时，重新请求接口，并更新本地版本号 *********/
#pragma mark - 区域接口版本号
-(void)requestGetCityDistricts_Version {
   // [_hud show:YES];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:@"GetCityDistricts_Version" object:nil];
    
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"GetCityDistricts_Version", @"op", nil];
    
    NSString *url = [NSString stringWithFormat:@"interface_version/get_version.json?fname=GETAREA"];
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL(url) delegate:nil params:nil info:infoDic];
    
}

/********* 获取商户类型接口版本号，存入本地，当本地版本号和服务器版本号不一致时，重新请求接口，并更新本地版本号 *********/
-(void)requestGetMerchantTypeList_Version {
    [_hud show:YES];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:@"GetMerchantTypeList_Version" object:nil];
    
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"GetMerchantTypeList_Version", @"op", nil];
    
    NSString *url = [NSString stringWithFormat:@"interface_version/get_version.json?fname=GETMERCHANTTYPELIST"];
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL(url) delegate:nil params:nil info:infoDic];
}
/***********************************************************/


#pragma mark - 商家分类请求
-(void)requestGetMerchantTypeList {
    [_hud show:YES];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:GetMerchantTypeList object:nil];
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:GetMerchantTypeList, @"op", nil];
    
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL(@"appmenu/list.json") delegate:nil params:nil info:infoDic];
}

#pragma mark - 获取市县
-(void)requestGetCityDistricts { //获取市和县区
    
}
#pragma mark - 重写获取市县请求
-(void)requestGetCityDistrictsNew{
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (! _cityHud) {
        _cityHud = [[MBProgressHUD alloc] initWithView:app.window];
        [app.window addSubview:_cityHud];
    }
    [_cityHud show:YES];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:GetCityDistricts object:nil];
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:GetCityDistricts, @"op", nil];
    
    NSString *url = [NSString stringWithFormat:@"area/list.htm"];
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL(url) delegate:nil params:nil info:infoDic];
    
}


#pragma mark - 获取商户列表
-(void)requestGetRecommendShopListWithLocationDic:(NSDictionary *)dic { //获取推荐商户列表
    [_hud show:YES];
    caoNiMaDic = dic;
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:GetMerchantList object:nil];
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:GetMerchantList, @"op", nil];
    
    NSString *url = [NSString stringWithFormat:@"shop/around.htm?lon=%@&lat=%@&limit=10&page=1&sortrule=distance",[dic objectForKey:@"longitude"],[dic objectForKey:@"latitude"]];
    
    NSLog(@"地址位置%@    ===%@",[dic objectForKey:@"longitude"],[dic objectForKey:@"latitude"]);
    [[GlobalSetting shareGlobalSettingInstance] setMyLocationWithDic:dic];
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL(url) delegate:nil params:nil info:infoDic];
    
    
}
#pragma mark - 版本更新
-(void)requrtGetAppVersion{
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetAppVersionData:) name:@"GetAppVersion" object:nil];
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"GetAppVersion", @"op", nil];
    NSString *url= [NSString stringWithFormat:@"check.json?version=%@&type=1",app_version];
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL(url) delegate:nil params:nil info:infoDic];
}
#pragma mark - 版本号返回数据
-(void)didGetAppVersionData:(NSNotification *)notification{
    [_hud hide:YES];
    if ([[notification.userInfo valueForKey:@"RespResult"] isEqualToString:ERROR]) {
        [_cityHud hide:YES];
      //  _networkConditionHUD.labelText = [notification.userInfo valueForKey:@"GetAppVersion"];
        [_networkConditionHUD show:YES];
        [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        return;
    }
    NSDictionary *responseObject = [[NSDictionary alloc] initWithDictionary:[notification.userInfo objectForKey:@"RespData"]];
    if ([notification.name isEqualToString:@"GetAppVersion"]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetAppVersion" object:nil];
        
        NSLog(@"GetLottery_responseObject-------: %@",responseObject);
        
        if ([responseObject[@"code"] intValue]== 0) {
            versionDic = responseObject[@"data"];
            NSString *ca = [NSString stringWithFormat:@"%@",versionDic[@"version"]];
            
           
            
            if (![app_version isEqual:versionDic[@"version"]]) {
                
                if ([ca isEqualToString:@""]||ca==nil||[ca isEqualToString:@"(null)"]||[ca isEqualToString:@"<null>"]||[ca isEqualToString:@"1.3.0"]) {
                    
                }else {
                NSLog(@"%@",versionDic[@"version"]);
                NSLog(@"%@",app_version);
                QJCheckVersionUpdate *update = [[QJCheckVersionUpdate alloc] init];
                    [update showAlertViewWithMessage:versionDic[@"description"] version:versionDic[@"version"]];
                }
                }else {
                                
                NSLog(@"不更新");
            }
            
        } else {
           // _networkConditionHUD.labelText = [responseObject objectForKey:MSG];
            [_networkConditionHUD show:YES];
            [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        }
        
    }
}
#pragma mark-版本更新点击事件
-(void)appUpdateVersion{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"appUpdateVersion" object:nil];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:versionDic[@"url"]]];
    
}
#pragma mark - 网络请求结果数据
-(void) didFinishedRequestData:(NSNotification *)notification{
    [_hud hide:YES];
    if ([[notification.userInfo valueForKey:@"RespResult"] isEqualToString:ERROR]) {
        [_cityHud hide:YES];
        
       //_networkConditionHUD.labelText = [notification.userInfo valueForKey:@"ContentResult"];
        [_networkConditionHUD show:YES];
        [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        return;
    }
    NSDictionary *responseObject = [[NSDictionary alloc] initWithDictionary:[notification.userInfo objectForKey:@"RespData"]];
    if ([notification.name isEqualToString:GetBanner]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:GetBanner object:nil];
        
        NSLog(@"GetBanner_responseObject: %@",responseObject);
        
        if ([responseObject[@"code"] intValue] ==0) {
            _adArray = responseObject [DATA] ;
            [_adView reloadData];
        }
        else {
           _networkConditionHUD.labelText = [responseObject objectForKey:MSG];
            [_networkConditionHUD show:YES];
            [_networkConditionHUD hide:YES afterDelay:HUDDelay];
            
        }
    }
    
    else if ([notification.name isEqualToString:GetMerchantTypeList]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:GetMerchantTypeList object:nil];
        NSLog(@"GetMerchantTypeList_responseObject: %@",responseObject);
        
        if ([responseObject[@"status"] intValue] == 0) {
            
            [[GlobalSetting shareGlobalSettingInstance] setMerchantTypeList:responseObject];
            merchantTypeArray = responseObject[DATA];
            
            [self initHeadScrollViewWithArray:merchantTypeArray];
            
        }
        else {
            _networkConditionHUD.labelText = [responseObject objectForKey:MSG];
            [_networkConditionHUD show:YES];
            [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        }
        
    }
    else if ([notification.name isEqualToString:@"GetCityDistricts_Version"]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetCityDistricts_Version" object:nil];
        NSLog(@"CityDistricts_Version_responseObject: %@",responseObject);
        
        cityDistricts_Version = [NSString stringWithFormat:@"%@",responseObject [@"data"]];
        NSString *locaVersion = [[GlobalSetting shareGlobalSettingInstance]cityDistricts_Version];
        
        NSLog(@"%@---------%@a---",cityDistricts_Version,locaVersion);
        
        if ( [cityDistricts_Version intValue] != [locaVersion intValue] ) {
            //请求新数据
            [self requestGetCityDistrictsNew];
            
            //获取城市区县接口版本号，比较后存入本地
            [[GlobalSetting shareGlobalSettingInstance] setCityDistricts_Version:cityDistricts_Version];
        }
    }
    else if ([notification.name isEqualToString:@"GetMerchantTypeList_Version"]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetMerchantTypeList_Version" object:nil];
        NSLog(@"MerchantTypeList_Version_responseObject: %@",responseObject);
        
        merchantTypeList_Version = responseObject [@"data"];
        NSLog(@"%@",merchantTypeList_Version);
        NSString *locaVersion = [[GlobalSetting shareGlobalSettingInstance] merchantTypeList_Version];
        NSLog(@"locaVersion: %@",locaVersion);
        if ( [merchantTypeList_Version intValue] > [locaVersion intValue] ) {
            
            //请求新数据
            [self requestGetMerchantTypeList];
            
            //获取商户类型接口版本号，比较后存入本地
            [[GlobalSetting shareGlobalSettingInstance] setMerchantTypeList_Version:merchantTypeList_Version];
        }
    }
    
    else if ([notification.name isEqualToString:GetCityDistricts]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:GetCityDistricts object:nil];
        //        NSLog(@"GetCityDistricts_responseObject: %@",responseObject);
        NSArray *cityAry = responseObject [@"data"];
        
        NSLog(@"%@---",cityAry);
        if ([cityAry count] > 0) { //返回的有数据时，更新数据库
       

            [app deleteAllObjects];
            for (NSDictionary *dic in cityAry) {
                [app insertCoreDataWithObjectItem:dic];
            }
         
            [_cityHud hide:YES];    //下载并写入数据库成功后，再关闭hud
            
            CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
            if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请到设置-隐私-定位服务中打开定位权限！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
            [_locService startUserLocationService];
            
        }
        else {
          
            [_cityHud hide:YES];    //没有数据更新，直接关闭hud
            
            [_locService startUserLocationService];
        }
    }
    
    else if ([notification.name isEqualToString:GetMerchantList]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:GetMerchantList object:nil];
        NSLog(@"GetMerchantList_responseObject: %@",responseObject);
        recommendArray = @[]; //置空数组
        
        if ([responseObject[@"code"] intValue] == 0) {
            recommendArray = responseObject[DATA];
        }
        else {
            _networkConditionHUD.labelText = [responseObject objectForKey:MSG];
            [_networkConditionHUD show:YES];
            [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        }
        [self.myTableView reloadData];
    }else if ([notification.name isEqualToString:@"GetHomeActivityList"]){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetHomeActivityList" object:nil];
        NSDictionary *dic1=(NSDictionary *)responseObject;
        id result12=[dic1 objectForKey:@"data"];
        NSLog(@"%@",result12);
        NSLog(@"%@====class==",[result12 class]);
        NSArray *dataArray=(NSArray *)result12;
        id result13=[dataArray firstObject];
        self.oneYuanActivityArray=(NSArray *)[dataArray objectAtIndex:2];
        NSLog(@"%@",[dataArray objectAtIndex:2]);
        NSLog(@"%@=====class",[result13 class]);
        NSArray *messArray=(NSArray *)result13;
        [self.goodsSeckillArray removeAllObjects];
        for (int i=0;i<messArray.count;i++) {
            
            
            
            HomeActivityMessage *messModel=[[HomeActivityMessage alloc]init];
            NSDictionary *myDic=[messArray objectAtIndex:i];

            messModel.activity_img_url=[myDic objectForKey:@"img_url"];
            messModel.activity_start_Time=[myDic objectForKey:@"start_time"];
            messModel.activity_current_Time=[myDic objectForKey:@"nowTime"];
            messModel.activity_end_Time=[myDic objectForKey:@"end_time"];
            messModel.marketPrice=[[myDic objectForKey:@"newgood"]objectForKey:@"marketPrice"];
            messModel.activityPrice=[[myDic objectForKey:@"newgood"]objectForKey:@"activityPrice"];
            messModel.activity_good_id=[myDic objectForKey:@"good_id"];
            messModel.activity_link_type=[myDic objectForKey:@"link_type"];
            messModel.linkUrl = [myDic objectForKey:@"link_url"];
            messModel.title = [myDic objectForKey:@"title"];
            messModel.activity_id = [myDic objectForKey:@"id"];
            [self.goodsSeckillArray addObject:messModel];
            
            
        }
        NSArray *messArray1=(NSArray *)[dataArray objectAtIndex:1];
        JFBLog(@"=========%@",[messArray1 firstObject]);
        for (int i=0;i<messArray1.count;i++) {
            HomeActivityMessage *messModel=[[HomeActivityMessage alloc]init];
            NSDictionary *myDic=[messArray1 objectAtIndex:i];
            messModel.activity_img_url=[myDic objectForKey:@"img_url"];
            JFBLog(@"====%@",messModel.activity_img_url);
            messModel.activity_good_id=[myDic objectForKey:@"good_id"];
            [self.homeActivityMessageArray addObject:messModel];
        }
        NSString *imageUrl=[[messArray1 firstObject] objectForKey:@"img_url"];
        if ([imageUrl isEqualToString:@" "] || imageUrl.length!=0) {
            [self.hotAcivityImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"bg_merchant_photo_placeholder"]];
        }else{
            self.hotAcivityImageView.image=[UIImage imageNamed:@"blackArrow"];
        }
        [self initTableViewHeadView];
        [self initWithMiddleView];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 二维码按钮点击事件
-(void)SaoMa:(UIButton *)btn{
    ScanCodeViewController *scanCodeVC = [[ScanCodeViewController alloc] init];
    scanCodeVC.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:scanCodeVC];
    nav.hidesBottomBarWhenPushed = YES;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}


#pragma mark - 扫码回调
- (void)ScanCodeComplete:(NSString *)codeString {   //会员卡条形码，不需要处理字符串
    codeString =  [codeString substringFromIndex:52];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i=1; i<=codeString.length; i++) {
        [arr addObject:[codeString substringWithRange:NSMakeRange(i-1, 1)]];
        if ([arr[i-1] isEqualToString:@"&"]) {
            myIndex = i;
        }
    }
    myMerchant_id = [codeString substringToIndex:myIndex-1];
    myGoods_id = [codeString substringWithRange:NSMakeRange(myIndex, codeString.length-myIndex)];
    myMerchant_id = [self returnNumber:myMerchant_id];
    myGoods_id = [self returnNumber:myGoods_id];
    
    
    NSLog(@"%@----%@",myMerchant_id,myGoods_id);
    
    GoodsDetailViewController *view = [[GoodsDetailViewController alloc]init];
    view.goods_id = myGoods_id;
    view.isHome = @"1";
    view.hidesBottomBarWhenPushed = YES;
    view.cao = [NSString stringWithFormat:@"%@",myGoods_id];
    [self.navigationController pushViewController:view animated:YES];
}

- (void)ScanCodeError:(NSError *)error {
    
}
#pragma mark - 取扫码之后数字
-(NSString*)returnNumber:(NSString*)str{
    NSScanner *scanner = [NSScanner scannerWithString:str];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    int number;
    [scanner scanInt:&number];
    NSString *string = [NSString stringWithFormat:@"%d",number];
    return string;
}
#pragma mark-秒杀商品图片的点击事件的代理
-(void)seckillViewDidTapImagView:(JFBSeckillView *)seckillView andButton:(UIButton *)btn{
    JFBLog(@"%d",btn.tag);
    if (self.isStartActivity && !self.isEndActivity) {
        
      
        //开始活动了
        HomeActivityMessage *jumpDic=[self getGoodsIDAndMerchantIDFromDidClick:btn.tag FromArray:self.goodsSeckillArray];
        int type = [jumpDic.activity_link_type intValue];
        if (type == 1) {
            GoodsDetailViewController *view = [[GoodsDetailViewController alloc]init];
            view.goods_id = jumpDic.activity_good_id;
            view.isHome = @"1";
            view.hidesBottomBarWhenPushed = YES;
            view.cao = [NSString stringWithFormat:@"%@",jumpDic.activity_good_id];
            [self.navigationController pushViewController:view animated:YES];

        }else if(type == 0){
            WebViewController *web = [[WebViewController alloc] init];
            NSString *url = [NSString stringWithFormat:@"banner/load.htm?id=%@",jumpDic.activity_id];
            web.isFrame = @"2";
            web.webUrlStr = NewRequestURL(url);
            web.titleStr = jumpDic.title;
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
        }else if (type == 2){
            WebViewController *web = [[WebViewController alloc] init];
            web.webUrlStr = jumpDic.linkUrl;
            web.titleStr = jumpDic.title;
            web.isFrame = @"2";
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
        }
        
        
    }else if (self.isEndActivity){
        //活动结束了
        if (!_networkConditionHUD) {
            _networkConditionHUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:_networkConditionHUD];
        }
        _networkConditionHUD.labelText = @"活动已结束";
        _networkConditionHUD.mode = MBProgressHUDModeText;
        _networkConditionHUD.yOffset = APP_HEIGHT/2 - HUDBottomH;
        _networkConditionHUD.margin = HUDMargin;
        [_networkConditionHUD show:YES];
        [_networkConditionHUD hide:YES afterDelay:HUDDelay];
    }else if (!self.isStartActivity){
        //活动没开始
        if (!_networkConditionHUD) {
            _networkConditionHUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:_networkConditionHUD];
        }
        _networkConditionHUD.labelText = @"活动暂未开始";
        _networkConditionHUD.mode = MBProgressHUDModeText;
        _networkConditionHUD.yOffset = APP_HEIGHT/2 - HUDBottomH;
        _networkConditionHUD.margin = HUDMargin;
        [_networkConditionHUD show:YES];
        [_networkConditionHUD hide:YES afterDelay:HUDDelay];
    }
    
}

#pragma mark-秒杀商品scrollView的代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
#pragma mark-抢购活动的点击事件
-(void)hotImageViewTap:(UIButton *)sender{
    
    
    //  if (timeData) {
    HomeActivityMessage*jumpDic=[self getGoodsIDAndMerchantIDFromDidClick:sender.tag FromArray:self.homeActivityMessageArray];
       NSLog(@"抢购了%ld",(long)sender.tag);
    GoodsDetailViewController *view = [[GoodsDetailViewController alloc]init];
    view.goods_id = jumpDic.activity_good_id;
    view.isHome = @"1";
    view.hidesBottomBarWhenPushed = YES;
    view.cao = [NSString stringWithFormat:@"%@",jumpDic.activity_good_id];
    [self.navigationController pushViewController:view animated:YES];
    //    }else {
    //
    //    }
    
}
#pragma mark-特产专区的图片展示点击事件
-(void)hotImageViewClick:(UIButton *)sender{
    
    
    [MobClick event:@"mySpecialty"];
    Specialty *specView = [[Specialty alloc]init];
    [self.navigationController pushViewController:specView animated:YES];
    
    
}
#pragma mark-判断点击的是哪一个按钮取得点击的商品的ID和商户ID
-(HomeActivityMessage *)getGoodsIDAndMerchantIDFromDidClick:(NSInteger)tap FromArray:(NSMutableArray *)array{
    
    NSLog(@"%@",array);
    
    NSMutableDictionary *jmupDic=[[NSMutableDictionary alloc]init];
    
    HomeActivityMessage *mess=[[HomeActivityMessage alloc]init];
    
    
    JFBLog(@"%ld",array.count);
    mess=[array objectAtIndex:tap];
    JFBLog(@"%@",mess.activity_good_id);
    
    [jmupDic setValue:mess.activity_good_id forKey:@"goods_id"];
    [jmupDic setValue:mess.activity_merchant_id forKey:@"merchant_id"];
    return mess;
    
}
#pragma mark-根据选择的城市名称请求商家的列表
-(void)getMerchantListWtih:(NSString *)cityNames withCityAreaName:(NSString *)cityAreaName{
    
    NSLog(@"%@---%@",cityAreaName,cityName);
    
    cityAreaName = [cityAreaName checkStringIsNullWithNullString:cityAreaName];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];  //设置传参方式为JSON
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:[NSArray arrayWithObjects:@"text/plain", @"text/html",nil]];
    
    manager.requestSerializer.timeoutInterval = 120;
    [manager POST:[[NSString stringWithFormat:@"http://api.map.baidu.com/geocoder?address=%@&output=json&key=%@&city=%@",cityAreaName,BaiduMap_Key,cityNames] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *resultDic=(NSDictionary *)responseObject;
        NSDictionary *dic1=[resultDic objectForKey:@"result"];
        NSDictionary *dic2=[dic1 objectForKey:@"location"];
        self.lat=[dic2 objectForKey:@"lat"];
        self.lon=[dic2 objectForKey:@"lng"];
        NSLog(@"=================================%@",[dic2 objectForKey:@"lat"]);
        NSDictionary *locationDic = [NSDictionary dictionaryWithObjectsAndKeys:self.lat,@"latitude",self.lon,@"longitude", nil];
        [self requestGetRecommendShopListWithLocationDic:locationDic];
        [[GlobalSetting shareGlobalSettingInstance] setMyLocationWithDic:locationDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.myTableView reloadData];
    }];
}
#pragma mark-中部视图加载
-(void)initWithMiddleView{
    //秒杀顶部视图
    UILabel *timeCountDownLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.width-(self.goodsSeckillTopView.width/3+10), 0, self.goodsSeckillTopView.width/3, self.goodsSeckillTopView.height)];
    timeCountDownLabel.font=[UIFont systemFontOfSize:12];
    timeCountDownLabel.textColor=[UIColor blackColor];
    timeCountDownLabel.textAlignment=NSTextAlignmentRight;
    [self.goodsSeckillTopView addSubview:timeCountDownLabel];
    self.timeCountLabel=timeCountDownLabel;
    timeCountDownLabel.hidden=YES;
    if (self.goodsSeckillArray.count!=0) {
        int coutnDownTime;
        HomeActivityMessage *messModel1=[self.goodsSeckillArray firstObject];
        NSLog(@"%@",messModel1.activity_end_Time);
        //转换倒计时的剩余秒数
        NSDate *activity_start_Date=[messModel1.activity_start_Time getDateFromTimeString];
        
        //                NSDate *currentDate=[NSDate date];
        NSDate *activity_current_Date=[messModel1.activity_current_Time getDateFromTimeString];
        NSDate *activity_end_Date=[messModel1.activity_end_Time getDateFromTimeString];
        NSLog(@"%@,%@,%@",activity_start_Date,activity_end_Date,activity_current_Date);
        if ([messModel1.activity_start_Time isEqualToString:@" "] || messModel1.activity_start_Time.length==0) {
            coutnDownTime=4;
        }else{
            
            coutnDownTime=(int)[activity_end_Date timeIntervalSinceDate:activity_current_Date];
            NSLog(@"%d",coutnDownTime);
        }
        if ([activity_current_Date timeIntervalSinceDate:activity_start_Date]<0) {//活动未开始
            self.timeCountLabel.hidden=NO;
            self.timeCountLabel.text=@"活动暂未开始";
        }else if (coutnDownTime<0){
            self.timeCountLabel.hidden=NO;
            self.timeCountLabel.text=@"活动已结束";
        }else{//活动已经开始了
            self.isStartActivity=YES;
            
            //            if (coutnDownTime/60/60/24>0) {
            JFBCountDownDayView *timeCountView=[JFBCountDownDayView countDown];
            timeCountView.x=self.goodsSeckillTopView.width/3*2;
            timeCountView.y=0;
            timeCountView.width=self.goodsSeckillTopView.width/3;
            timeCountView.height=self.goodsSeckillTopView.height;
            timeCountView.timestamp=coutnDownTime;
            self.timeCountDayView=timeCountView;
            //                timeCountView.backgroundColor=[UIColor grayColor];
            timeCountView.timerStopBlock=^{
                JFBLog(@"时间结束了");
                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ReloadHome" object:nil];
                self.timeCountDayView.hidden=YES;
                self.timeCountLabel.hidden=NO;
                self.timeCountLabel.text=@"活动已结束";
                self.isEndActivity=YES;
                
            };
            [self.goodsSeckillTopView addSubview:timeCountView];
            //            }else{
            //                JFBCountDownView *timeCountView=[JFBCountDownView countDown];
            //                timeCountView.x=self.goodsSeckillTopView.width/3*2;
            //                timeCountView.y=0;
            //                timeCountView.width=self.goodsSeckillTopView.width/3;
            //                timeCountView.height=self.goodsSeckillTopView.height;
            //                timeCountView.timestamp=coutnDownTime;
            //                timeCountView.dayLabel.hidden=YES;
            //                self.timeCountView=timeCountView;
            //                //                timeCountView.backgroundColor=[UIColor grayColor];
            //                timeCountView.timerStopBlock=^{
            //                    JFBLog(@"时间结束了");
            //                    self.timeCountView.hidden=YES;
            //                    self.timeCountLabel.hidden=NO;
            //                    self.timeCountLabel.text=@"活动已结束";
            //                    self.isEndActivity=YES;
            //                };
            //                [self.goodsSeckillTopView addSubview:timeCountView];
            //            }
        }
        
        
        
    }    //秒杀商品滑动视图
    float mySeckillViewW=(self.seckillScollView.width-15)/7*2;
    float mySeckillViewH=self.seckillScollView.height;
    if (self.goodsSeckillArray.count!=0) {
        for (int i=0; i<self.goodsSeckillArray.count; i++) {
            JFBSeckillView *mySeckillView=[[JFBSeckillView alloc]initWithFrame:CGRectMake((mySeckillViewW+5)*i, 0, mySeckillViewW, mySeckillViewH)];
            mySeckillView.backgroundColor=[UIColor whiteColor];
            [self.seckillScollView addSubview:mySeckillView];
            mySeckillView.btn.tag=i;
            mySeckillView.delegate=self;
            HomeActivityMessage *messModel1=[[HomeActivityMessage alloc]init];
            messModel1=[self.goodsSeckillArray objectAtIndex:i];
            JFBLog(@"%@",messModel1.activity_title);
            [mySeckillView.imageView sd_setImageWithURL:[NSURL URLWithString:messModel1.activity_img_url] placeholderImage:[UIImage imageNamed:@"bg_merchant_photo_placeholder"]];
            NSString *seckillPrice=[NSString stringWithFormat:@"%@",messModel1.activityPrice];
            seckillPrice=[seckillPrice checkStringIsNullWithNullString:@"1.00"];
            [mySeckillView.seckillPriceLabel setText:[NSString stringWithFormat:@"¥ %@",seckillPrice]];
            NSString *marketPrice=[NSString stringWithFormat:@"%@",messModel1.marketPrice];
            marketPrice=[marketPrice checkStringIsNullWithNullString:@"100"];
            NSString *oldPrice = [NSString stringWithFormat:@"¥ %@",marketPrice];
            NSUInteger length = [oldPrice length];
            
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
            
            [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
            [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, length)];
            [attri addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, length)];
            [mySeckillView.realPriceLabel setAttributedText:attri];
            
        }
    }
    
    self.seckillScollView.contentSize=CGSizeMake((self.goodsSeckillArray.count+0.5)*mySeckillViewW-10, 0);
    //热门活动显示视图
    if (self.homeActivityMessageArray.count!=0) {
        HomeActivityMessage *mess=[self.homeActivityMessageArray firstObject];
        [self.hotAcivityImageView sd_setImageWithURL:[NSURL URLWithString:mess.activity_img_url] placeholderImage:[UIImage imageNamed:@"bg_merchant_photo_placeholder"]];
        for (int i=1; i<self.homeActivityMessageArray.count; i++) {
            NSLog(@"%d",i);
            HomeActivityMessage *messModel1=[[HomeActivityMessage alloc]init];
            messModel1=[self.homeActivityMessageArray objectAtIndex:i];
            JFBLog(@"=========%@",messModel1.activity_img_url);
            UIImageView *hotImageView=[[UIImageView alloc]init];
            //                            hotImageView.backgroundColor=[UIColor grayColor];
            hotImageView.userInteractionEnabled=YES;
            hotImageView.width=(self.hotActivityShowView.width-(SCREEN_WIDTH*(8/RealSrceenWidth))*2)/3;
            hotImageView.height=self.hotActivityShowView.height;
            hotImageView.y=0;
            hotImageView.x=(SCREEN_WIDTH*(8/RealSrceenWidth)+hotImageView.width)*(i-1);
            [self.hotActivityShowView addSubview:hotImageView];
            //                hotImageView.tag=i;
            [hotImageView sd_setImageWithURL:[NSURL URLWithString:messModel1.activity_img_url] placeholderImage:[UIImage imageNamed:@"bg_merchant_photo_placeholder"]];
            UIButton *btn=[[UIButton alloc]init];
            btn.frame=hotImageView.bounds;
            [hotImageView addSubview:btn];
            btn.tag=i;
            //                [hotImageView addGestureRecognizer:ges];
            [btn addTarget:self action:@selector(hotImageViewTap:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}
@end