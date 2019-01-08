//
//  ViewController.m
//  VerifySignatureDemo
//
//  Created by 周彬 on 2017/3/18.
//  Copyright © 2017年 Golden. All rights reserved.
//

#import "ViewController.h"
#import "YQRSAHelper.h"

@interface ViewController ()

@end

@implementation ViewController

///测试公钥加密
- (void)testEncryption {
    NSString *pubkeyBase64 = @"MIICITCCAYoCCQD8skayww6LKzANBgkqhkiG9w0BAQsFADBVMQswCQYDVQQGEwJBVTERMA8GA1UECAwIc2hhbmdoYWkxETAPBgNVBAcMCHNoYW5naGFpMQ8wDQYDVQQKDAZ5aW5ncWkxDzANBgNVBAsMBnlpbmdxaTAeFw0xNzAzMTgwNzQ5MTJaFw0yNzAzMTYwNzQ5MTJaMFUxCzAJBgNVBAYTAkFVMREwDwYDVQQIDAhzaGFuZ2hhaTERMA8GA1UEBwwIc2hhbmdoYWkxDzANBgNVBAoMBnlpbmdxaTEPMA0GA1UECwwGeWluZ3FpMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCzQAvTOu/+74XbeqaPFfzdYhRGjgjW5Agvd5XdQ0OHPA75kNpgQbpvOrxq7rNNAz62SHo0TKu2W1puUR/iDcsxomJe5r6lFJm7N/tm/Q6ViK2PtRW8G4ZonjXjytwqx9H8zsQsRuU94MnndRtza6yGdhU3H7/86yH4An9Awh+hxQIDAQABMA0GCSqGSIb3DQEBCwUAA4GBALBHrk+K4V4IfLpqglsABDss1rI5TQ8YePofEASNXICw28E9h1CSpatavUwvP0Q7BEk4ysFXFB5w6i1PYfBdrw2oiZKO6hr8YmzUMehNsQXoVTvWcLpAscX9UdVC+WtzoWGiq5bhS9WfYcmm57pKjSMk2kzXOav1UMdOhE20dj/o";
    
    NSString *plainText = @"123";
    
    NSData *encryptData = [YQRSAHelper encryptData:[plainText dataUsingEncoding:NSUTF8StringEncoding] withPublicKeyBase64:pubkeyBase64];
    
    NSData *base64Data = [encryptData base64EncodedDataWithOptions:0];
    NSString *base64 = [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", base64);
}

///测试签名验证
- (void)testSignature {
    
    NSString *pubkeyBase64 = @"MIICITCCAYoCCQD8skayww6LKzANBgkqhkiG9w0BAQsFADBVMQswCQYDVQQGEwJBVTERMA8GA1UECAwIc2hhbmdoYWkxETAPBgNVBAcMCHNoYW5naGFpMQ8wDQYDVQQKDAZ5aW5ncWkxDzANBgNVBAsMBnlpbmdxaTAeFw0xNzAzMTgwNzQ5MTJaFw0yNzAzMTYwNzQ5MTJaMFUxCzAJBgNVBAYTAkFVMREwDwYDVQQIDAhzaGFuZ2hhaTERMA8GA1UEBwwIc2hhbmdoYWkxDzANBgNVBAoMBnlpbmdxaTEPMA0GA1UECwwGeWluZ3FpMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCzQAvTOu/+74XbeqaPFfzdYhRGjgjW5Agvd5XdQ0OHPA75kNpgQbpvOrxq7rNNAz62SHo0TKu2W1puUR/iDcsxomJe5r6lFJm7N/tm/Q6ViK2PtRW8G4ZonjXjytwqx9H8zsQsRuU94MnndRtza6yGdhU3H7/86yH4An9Awh+hxQIDAQABMA0GCSqGSIb3DQEBCwUAA4GBALBHrk+K4V4IfLpqglsABDss1rI5TQ8YePofEASNXICw28E9h1CSpatavUwvP0Q7BEk4ysFXFB5w6i1PYfBdrw2oiZKO6hr8YmzUMehNsQXoVTvWcLpAscX9UdVC+WtzoWGiq5bhS9WfYcmm57pKjSMk2kzXOav1UMdOhE20dj/o";
    
    BOOL valid = [YQRSAHelper validSignatureWithText:@"我的天啊" publicKey:pubkeyBase64 signatureBase64:@"UENP2uCY3V3a7G3Dx8mJcQQ5o6V+GEnnPWGWgRVGGkbcXV04jxii0G88x9T6NSP3kahu7MIPQj1wbtvV2RZ8X3C1bZ7vRXvCoYd/d8tIT0gbFeagrKFuRu3zIzFgfOHDlejR2ajiaL7YXOs+PYx0/UKTiWNhVsYh+/yp7YBerJ4="];
    
    if (valid) {
        NSLog(@"签名通过");
    }else {
        NSLog(@"签名未通过");
    }
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self testEncryption];
    [self testSignature];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
