//
//  YQSignatureVerify.m
//  VerifySignatureDemo
//
//  Created by 周彬 on 2017/3/18.
//  Copyright © 2017年 Golden. All rights reserved.
//

#import "YQRSAHelper.h"


@implementation YQRSAHelper


#pragma mark - Encryption

///通过公钥加密
+ (NSData *)encryptData:(NSData *)data withPublicKeyBase64:(NSString *)base64 {
    
    SecKeyRef keyRef = [YQRSAHelper publicKeyRef:base64];
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    void *outbuf = malloc(block_size);
    size_t src_block_size = block_size - 11;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyEncrypt(keyRef,
                               kSecPaddingPKCS1,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
            ret = nil;
            break;
        }else{
            [ret appendBytes:outbuf length:outlen];
        }
    }
    
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}


#pragma mark - Signature

//static SecKeyRef _public_key = nil;

///从公钥(base64)获取 SecKeyRef
+ (SecKeyRef)publicKeyRef:(NSString *)certificateDataBase64 {
    
    SecKeyRef public_key = nil;
    
    if (public_key == nil) {
        
        NSData *certificateData = [[NSData alloc] initWithBase64EncodedString:certificateDataBase64 options:0];
        
        SecCertificateRef myCertificate =  SecCertificateCreateWithData(kCFAllocatorDefault, (CFDataRef)certificateData);
        SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
        SecTrustRef myTrust;
        OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);
        SecTrustResultType trustResult;
        
        if (status == noErr) {
            status = SecTrustEvaluate(myTrust, &trustResult);
        }
        public_key = SecTrustCopyPublicKey(myTrust);
        
        CFRelease(myCertificate);
        CFRelease(myPolicy);
        CFRelease(myTrust);
    }
    
    return public_key;
}


+ (BOOL)validSignatureWithText:(NSString *)plainString publicKey:(NSString *)publicKeyBase64 signatureBase64:(NSString *)signature {
    SecKeyRef publicKeyRef = [YQRSAHelper publicKeyRef:publicKeyBase64];
    NSData *plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *signatureData = [[NSData alloc] initWithBase64EncodedString:signature options:0];
    if (signatureData == nil) {
        return NO;
    }
    BOOL isValidSignature = PKCSVerifyBytesSHA256withRSA(plainData, signatureData, publicKeyRef);
    return isValidSignature;
}


///验证签名
BOOL PKCSVerifyBytesSHA256withRSA(NSData* plainData, NSData* signature, SecKeyRef publicKey) {
    
    size_t signedHashBytesSize = SecKeyGetBlockSize(publicKey);
    const void* signedHashBytes = [signature bytes];
    
    size_t hashBytesSize = CC_SHA1_DIGEST_LENGTH;
    uint8_t* hashBytes = malloc(hashBytesSize);
    if (!CC_SHA1([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
        return nil;
    }
    
    OSStatus status = SecKeyRawVerify(publicKey,
                                      kSecPaddingPKCS1SHA1,
                                      hashBytes,
                                      hashBytesSize,
                                      signedHashBytes,
                                      signedHashBytesSize);
    
    return status == errSecSuccess;
}

@end
