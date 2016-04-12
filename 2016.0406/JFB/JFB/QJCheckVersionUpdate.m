//
//  QJCheckVersionUpdate.m
//  QJVersionUpdateView
//
//  Created by Justin on 16/3/8.
//  Copyright © 2016年 Justin. All rights reserved.
//

#import "QJCheckVersionUpdate.h"
#import "QJVersionUpdateVIew.h"

#define GetUserDefaut [[NSUserDefaults standardUserDefaults] objectForKey:@"VersionUpdateNotice"]
#define OLDVERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APPID  @"111111111"
@implementation QJCheckVersionUpdate{
    
    QJVersionUpdateVIew *versionUpdateView;
}

/**
 *  demo
 */
+ (void)CheckVerion:(UpdateBlock)updateblock andMessage:(NSString *)message andVersion:(NSString *)version
{
    
    
    NSArray *dataArr = [QJCheckVersionUpdate separateToRow:message];
    if (updateblock) {
        updateblock(version,dataArr);
    }
    
}

+ (BOOL)versionlessthan:(NSString *)oldOne Newer:(NSString *)newver
{
    if ([oldOne isEqualToString:newver]) {
        return YES;
    }else{
        if ([oldOne compare:newver options:NSNumericSearch] == NSOrderedDescending)
        {
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}


+ (NSArray *)separateToRow:(NSString *)describe
{
    NSArray *array= [describe componentsSeparatedByString:@"\n"];
    return array;
}

- (void)showAlertViewWithMessage:(NSString *)message version:(NSString *)version
{
//    __weak typeof(self) weakself = self;
    [QJCheckVersionUpdate CheckVerion:^(NSString *str, NSArray *DataArr) {
        if (!versionUpdateView) {
            versionUpdateView = [[QJVersionUpdateVIew alloc] initWith:[NSString stringWithFormat:@"版本:%@",str] Describe:DataArr];
//            versionUpdateView.delegate=self;
//            versionUpdateView.GoTOAppstoreBlock = ^{
////                [weakself goToAppStore];
//            };
//            versionUpdateView.removeUpdateViewBlock = ^{
//                [weakself removeVersionUpdateView];
//            };
            [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"VersionUpdateNotice"];
        }
    } andMessage:message andVersion:version];
}

- (void)removeVersionUpdateView
{
    [versionUpdateView removeFromSuperview];
    versionUpdateView = nil;
}

- (void)goToAppStore
{
    NSString *urlStr = [self getAppStroeUrlForiPhone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

-(NSString *)getAppStroeUrlForiPhone{
    return [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/%@",APPID];
}

@end
