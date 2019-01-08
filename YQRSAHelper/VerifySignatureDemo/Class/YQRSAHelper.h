//
//  YQSignatureVerify.h
//  VerifySignatureDemo
//
//  Created by 周彬 on 2017/3/18.
//  Copyright © 2017年 Golden. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CommonCrypto/CommonDigest.h>

@interface YQRSAHelper : NSObject

/** 
 * @breif 通过公钥加密
 * @param data 需要加密的字符串 data
 * @param base64 der 编码的公钥，经过 base64 编码
 * @return 加密后的 data
 */
+ (NSData *)encryptData:(NSData *)data withPublicKeyBase64:(NSString *)base64;

/** 
 * @breif 验证签名
 * @param plainString 原始字符串
 * @param publicKeyBase64 der 编码的公钥，经过 base64 编码
 * @param signature base64 编码后的签名
 */
+ (BOOL)validSignatureWithText:(NSString *)plainString publicKey:(NSString *)publicKeyBase64 signatureBase64:(NSString *)signature;

@end
