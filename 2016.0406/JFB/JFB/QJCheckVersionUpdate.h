//
//  QJCheckVersionUpdate.h
//  QJVersionUpdateView
//
//  Created by Justin on 16/3/8.
//  Copyright © 2016年 Justin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^UpdateBlock)(NSString *str, NSArray *DataArr);

@interface QJCheckVersionUpdate : NSObject

/**
 *  show updateVersion View
 */
- (void)showAlertViewWithMessage:(NSString *)message version:(NSString *)version;

@property(nonatomic, copy)UpdateBlock updateBlock;
@end
