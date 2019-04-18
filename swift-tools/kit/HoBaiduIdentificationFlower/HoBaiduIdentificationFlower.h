//
//  HoBaiduIdentificationFlower.h
//  swift-tools
//
//  Created by 叶长生 on 2019/4/18.
//  Copyright © 2019 Hoa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HoBaiduIdentificationFlower : NSObject

+ (void)commitImage: (UIImage *)image accessToken: (NSString * _Nullable)accessToken response: (void (^)(NSDictionary * _Nullable data, NSError * _Nullable error))completionHandlerresponse;

@end

NS_ASSUME_NONNULL_END
