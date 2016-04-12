//
//  NSData+AES_Encryption.h
//  OC_Encryption_Sha1&MD5&Base64
//
//  Created by 张可可 on 14/12/19.
//  Copyright (c) 2014年 张可可. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES_Encryption)

/**
 *  AES加密
 *
 *  @param key 公钥
 *
 *  @return 加密后的数据
 */
- (NSData *)AES256EncryptWithKey:(NSString *)key;

/**
 *  AES解密
 *
 *  @param key 公钥
 *
 *  @return 解密后的数据
 */
- (NSData *)AES256DecryptWithKey:(NSString *)key;


@end
