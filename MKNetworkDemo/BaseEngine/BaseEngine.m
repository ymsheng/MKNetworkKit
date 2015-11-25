//
//  BaseEngine.m
//  MKNetworkDemo
//
//  Created by mosn on 11/25/15.
//  Copyright © 2015 com.*. All rights reserved.
//

#import "BaseEngine.h"

@interface BaseEngine()



@end

@implementation BaseEngine
- (instancetype)init{
    if (self=[super init]) {
        self.host = [[MKNetworkHost alloc] initWithHostName:@"install.sinaapp.com"];
    }
    return self;
}
+ (BaseEngine *)sharedEngine
{
    static BaseEngine *sharedSingleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingleton = [[BaseEngine alloc] init];
    });
    return sharedSingleton;
}

#pragma mark -
#pragma mark Get
- (MKNetworkRequest *)RunGetRequest:(NSMutableDictionary *)params
                               path:(NSString *)path
                  completionHandler:(ResponseBlock) completionBlock
                       errorHandler:(ErrorBlock) errorBlock
                      finishHandler:(FinishBlock) finishBlock
{
    MKNetworkRequest *request = [self RunRequest:params path:path httpMethod:@"GET" completionHandler:completionBlock errorHandler:errorBlock finishHandler:finishBlock];
    [self.host startRequest:request];
    return request;
}

#pragma mark -
#pragma mark Post
- (MKNetworkRequest *)RunPostRequest:(NSMutableDictionary *)params
                                path:(NSString *)path
                          attactFile:(NSString *)file
                   completionHandler:(ResponseBlock) completionBlock
                        errorHandler:(ErrorBlock) errorBlock
                       finishHandler:(FinishBlock) finishBlock
{
    MKNetworkRequest *request = [self RunRequest:params path:path httpMethod:@"POST" completionHandler:completionBlock errorHandler:errorBlock finishHandler:finishBlock];
    if (file==nil) {
        [self.host startRequest:request];
    }
    else{
        [request attachFile:file forKey:@"file" mimeType:[[file componentsSeparatedByString:@"."] lastObject]];
        [self.host startUploadRequest:request];
    }
    
    return request;
}

#pragma mark -
#pragma mark BuildRequest
- (MKNetworkRequest *)RunRequest:(NSMutableDictionary *)params
                            path:(NSString *)path
                      httpMethod:(NSString *)type
               completionHandler:(ResponseBlock) completionBlock
                    errorHandler:(ErrorBlock) errorBlock
                   finishHandler:(FinishBlock) finishBlock
{
    ///custom Required param
    [params setObject:@"custom device id" forKey:@"deviceId"];
    
    MKNetworkRequest *request = [self.host requestWithPath:path params:params httpMethod:type];
    [request addCompletionHandler:^(MKNetworkRequest *completedRequest) {
        id response = completedRequest.responseAsJSON;
        
        if (completedRequest.state==MKNKRequestStateCompleted ||
            completedRequest.state==MKNKRequestStateResponseAvailableFromCache ||
            completedRequest.state==MKNKRequestStateStaleResponseAvailableFromCache) {
            //sever response status=0, 0 mean this request call success,other mean business error
            if ([[response objectForKey:@"status"] intValue]==0) {
                if (completionBlock) {
                    completionBlock(response);
                }
                response = nil; //status=0,business success,finish do nothing
            }
            
        }
        else if(completedRequest.state==MKNKRequestStateError ||
                completedRequest.state==MKNKRequestStateCancelled){
            if (errorBlock) {
                errorBlock(@"custom error message");
            }
        }
        
        if (finishBlock) {
            finishBlock(response);
        }
    }];
    
    return request;
}


#pragma mark -
#pragma mark Download
- (MKNetworkRequest *)DownloadRequest:(NSString *)remoteURL storeFilePath:(NSString *)filePath finishHandler:(FinishBlock)finishBlock
{
    MKNetworkRequest *request = [self.host requestWithURLString:remoteURL];
    request.downloadPath = filePath;
    [request addCompletionHandler:^(MKNetworkRequest *completedRequest) {

        if (completedRequest.state==MKNKRequestStateCompleted) {
            if (finishBlock) {
                finishBlock(filePath);
            }
        }
        else if (completedRequest.state==MKNKRequestStateError || completedRequest.state==MKNKRequestStateCancelled){
            if (finishBlock) {
                finishBlock(nil);
            }
        }
        
        
    }];
    [self.host startDownloadRequest:request];
    
    return request;
}
@end
