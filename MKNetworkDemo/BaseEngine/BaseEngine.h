//
//  BaseEngine.h
//  MKNetworkDemo
//
//  Created by mosn on 11/25/15.
//  Copyright © 2015 com.*. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkKit.h"

typedef void (^ResponseBlock)(id responseObject);
typedef void (^FinishBlock)(id responseObject);
typedef void (^ErrorBlock)(id responseObject);

@interface BaseEngine : NSObject
@property (strong,nonatomic) MKNetworkHost *host;

+ (BaseEngine *)sharedEngine;


- (MKNetworkRequest *)RunGetRequest:(NSMutableDictionary *)params
                            path:(NSString *)path
               completionHandler:(ResponseBlock) completionBlock
                    errorHandler:(ErrorBlock) errorBlock
                   finishHandler:(FinishBlock) finishBlock;
- (MKNetworkRequest *)RunPostRequest:(NSMutableDictionary *)params
                                path:(NSString *)path
                          attactFile:(NSString *)file
                   completionHandler:(ResponseBlock) completionBlock
                        errorHandler:(ErrorBlock) errorBlock
                       finishHandler:(FinishBlock) finishBlock;

- (MKNetworkRequest *)DownloadRequest:(NSString *)remoteURL storeFilePath:(NSString *)filePath finishHandler:(FinishBlock)finishBlock;
@end
