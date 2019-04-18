//
//  HoBaiduIdentificationFlower.m
//  swift-tools
//
//  Created by 叶长生 on 2019/4/18.
//  Copyright © 2019 Hoa. All rights reserved.
//

#import "HoBaiduIdentificationFlower.h"

static NSString * hostUrl = @"https://aip.baidubce.com/rest/2.0/image-classify/v1/plant?access_token=";
static NSString * accessToken = @"24.96b408f7844702d9054a87c1f0bdce6b.2592000.1558144637.282335-16047848";
@implementation HoBaiduIdentificationFlower

+ (void)commitImage:(UIImage *)image accessToken: (NSString * _Nullable)accessT response:(void (^)(NSDictionary * _Nullable, NSError * _Nullable))completionHandlerresponse {
    
    if (accessT == NULL) {
        accessT = accessToken;
    }
    NSString * testURL = [hostUrl stringByAppendingString:accessT];
    
    testURL = [testURL  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:testURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置请求方法
    request.HTTPMethod = @"POST";
    //设置请求体
    UIImage  *image1 = [UIImage imageNamed:@"1"];
    NSData *imageData = UIImagePNGRepresentation(image1);
    NSString *baseStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *urlEncode=  (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                NULL,
                                                                                                (__bridge CFStringRef)baseStr,
                                                                                                NULL,
                                                                                                (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                                CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    
    NSString *str =[NSString stringWithFormat:@"image=%@",urlEncode];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = data;
    NSURLSession *session  = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask =  [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //
        if (error) {
            if (completionHandlerresponse) {
                completionHandlerresponse(NULL, error);
            }
        }else
        {
            NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (completionHandlerresponse) {
                completionHandlerresponse(dic,NULL);
            }
        }
    }];
    [dataTask resume];
    
    
}

@end
