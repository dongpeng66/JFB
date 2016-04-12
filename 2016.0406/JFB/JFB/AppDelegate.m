//
//  AppDelegate.m
//  JFB
//
//  Created by JY on 15/8/12.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import "AppDelegate.h"
#import <BaiduMapAPI/BMapKit.h>//引入所有的头文件
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import <AlipaySDK/AlipaySDK.h>
#import <MobClick.h>
#import "checkIphoneNum.h"
@interface AppDelegate ()
{
    MBProgressHUD *_hud;
 
}

@end

@implementation AppDelegate

#pragma mark - Core Data 相关操作
- (void)insertCoreDataWithObjectItem:(NSDictionary *)objectDict
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    CityDistrictsCoreObject *cityDistricts = [NSEntityDescription insertNewObjectForEntityForName:@"CityDistrictsCoreObject" inManagedObjectContext:context];
    cityDistricts.isopen = STRING(objectDict[@"isOpen"]);
    cityDistricts.pyName = STRING(objectDict[@"pyName"]);
    cityDistricts.current_code = STRING(objectDict[@"currentCode"]);
    cityDistricts.parentID = STRING(objectDict[@"parentCode"]);
    
    cityDistricts.areaId = STRING(objectDict[@"currentCode"]);
    cityDistricts.areaName = STRING(objectDict[@"currentName"]);
    
    cityDistricts.level = STRING(objectDict[@"type"]);
    
    
    NSError *error;
    if(![context save:&error])
    {
        NSLog(@"不能保存：%@",[error localizedDescription]);
    }
}

- (void) deleteAllObjects
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CityDistrictsCoreObject" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    for (NSManagedObject *managedObject in items) {
        [_managedObjectContext deleteObject:managedObject];
    }
    if (![self.managedObjectContext save:&error]) {
    }
}

- (NSArray *) selectAllCoreObject    //读取数据库中所有数据
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CityDistrictsCoreObject" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"pyName" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSLog(@"[fetchedObjects count]:%lu",(unsigned long)[fetchedObjects count]);
    
    return fetchedObjects;
}

- (NSArray *) selectDataWithLevel:(NSString*)level {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // 限定查询结果的数量
    //setFetchLimit
    // 查询的偏移量
    //setFetchOffset
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CityDistrictsCoreObject" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    //[fetchRequest setFetchLimit:1];
    //[fetchRequest setFetchBatchSize:1];
    
   // level = @"3";
    

   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(level = %@)",level];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"pyName" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
  
    NSLog(@"----%lu----",(unsigned long)fetchedObjects.count);
    
    return fetchedObjects;
}

- (CityDistrictsCoreObject *) selectDataWithName:(NSString*)name {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // 限定查询结果的数量
    //setFetchLimit
    // 查询的偏移量
    //setFetchOffset
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CityDistrictsCoreObject" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    //[fetchRequest setFetchLimit:1];
    //[fetchRequest setFetchBatchSize:1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(areaName = %@)",name];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"pyName" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return [fetchedObjects firstObject];
}

- (NSArray *) selectDataWithParentID:(NSString*)parentID {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // 限定查询结果的数量
    //setFetchLimit
    // 查询的偏移量
    //setFetchOffset
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CityDistrictsCoreObject" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    //[fetchRequest setFetchLimit:1];
    //[fetchRequest setFetchBatchSize:1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(parentID = %@)",parentID];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"pyName" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [checkIphoneNum shareCheckIphoneNum].homeActivityViewHeight=[checkIphoneNum checkIphoneGetHomeActivityViewHeight:[[UIScreen mainScreen]bounds]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackOpaque];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:Red_BtnColor];
//    [[UINavigationBar appearance] setTranslucent:NO];     //iOS7下会crash，原因为此属性在iOS8以后才有
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(SCREEN_WIDTH, 0) forBarMetrics:UIBarMetricsDefault];
    
    // 要使用百度地图，请先启动BaiduMapManager
    BMKMapManager *_mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:BaiduMap_Key generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    

    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:kShare_WeChat_Appkey appSecret:kShare_WeChat_AppSecret url:@"http://3g.jfb315.cn/"];
    [UMSocialQQHandler setQQWithAppId:kShare_QQ_AppID appKey:kShare_QQ_Appkey url:@"http://3g.jfb315.cn/"];
    
    [MobClick startWithAppkey:@"564d3686e0f55aed17001dc1" reportPolicy:BATCH   channelId:nil];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
       [MobClick setEncryptEnabled:YES];
    
//    [self performSelector:@selector(requestGetCityDistricts) withObject:nil afterDelay:0.1];    //延迟0.1秒
//    [self requestGetCityDistricts]; //请求最新的城市数据
    
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];  //上架版本号
//    NSString *locationAppVersion = [[GlobalSetting shareGlobalSettingInstance] appVersion];
//    
//    if (! [[GlobalSetting shareGlobalSettingInstance] isNotFirst] || ! [locationAppVersion isEqual:appVersion]) {   //第一次进入应用
//        NSError* err = nil;
//        NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"CityDistricts" ofType:@"json"];
//        NSArray* cityDistricts = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath] options:kNilOptions error:&err];
//        NSLog(@"Imported cityDistricts: %@", cityDistricts);
//        if ([[self selectAllCoreObject] count]) {
//            [self deleteAllObjects];
//        }
//        for (NSDictionary *dic in cityDistricts) {
//            [self insertCoreDataWithObjectItem:dic];
//        }
//    }
    
    [checkIphoneNum shareCheckIphoneNum].textFont=[checkIphoneNum checkIphoneGetNormalLabelFont:[[UIScreen mainScreen]bounds]];
    [checkIphoneNum shareCheckIphoneNum].dayTextFont=[checkIphoneNum checkIphoneGetDayLabelFont:[[UIScreen mainScreen]bounds]];
    [checkIphoneNum shareCheckIphoneNum].moveTionLength=[checkIphoneNum checkIphoneGetMoveTionMargin:[[UIScreen mainScreen]bounds]];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    //如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开 发包
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中,商户 app 在后台很可能被系统 kill 了,所以 pay 接口的 callback 就会失效,请商户对 standbyCallback 返回的回调结果进行处理,就是在这个方法里面处理跟 callback 一样的逻辑】
            
            //发送支付宝支付完成通知
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"success",@"RespResult", resultDic, @"RespData",nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:AliPayNotification object:nil userInfo:userInfo];
            
            NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中,商户 app 在后台很可能被系统 kill 了, 所以 pay 接口的 callback 就会失效,请商户对 standbyCallback 返回的回调结果进行处理,就 是在这个方法里面处理跟 callback 一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }
    
    
    else {  //友盟分享
        BOOL result = [UMSocialSnsService handleOpenURL:url];
        if (result == FALSE) {
            //调用其他SDK，例如新浪微博SDK等
        }
        return result;
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadHome" object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "jfb315.JFB" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"JFB" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    /*****数据库轻量迁移******/
    NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
                                       NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],
                                       NSInferMappingModelAutomaticallyOption, nil];
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"JFB.sqlite"];
    NSLog(@"storeURL:   %@",storeURL);
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:optionsDictionary error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
