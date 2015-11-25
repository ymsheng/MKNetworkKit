//
//  ViewController.m
//  MKNetworkDemo
//
//  Created by mosn on 11/25/15.
//  Copyright © 2015 com.*. All rights reserved.
//

#import "ViewController.h"
#import "BaseEngine.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

static int code = 0;

- (IBAction)getAction:(id)sender
{
    [[BaseEngine sharedEngine] RunGetRequest:[@{@"code":[NSString stringWithFormat:@"%d",code]} mutableCopy] path:@"api" completionHandler:^(id responseObject) {
        NSDictionary *dict = responseObject;
        NSLog(@"request success====%@",dict);
    } errorHandler:^(id responseObject) {
        NSLog(@"request failed====%@",responseObject);
    } finishHandler:^(id responseObject) {
        code++;
        //stop animation.etc
        if (responseObject) {
            NSLog(@"request finish=====%@",[responseObject objectForKey:@"message"]);
        }
        
    }];
    
}

- (IBAction)postAction:(id)sender
{
    
    [[BaseEngine sharedEngine] RunPostRequest:[@{@"code":[NSString stringWithFormat:@"%d",code]} mutableCopy] path:@"api/post" attactFile:nil completionHandler:^(id responseObject) {
        NSDictionary *dict = responseObject;
        
        NSLog(@"request success====%@",dict);
    } errorHandler:^(id responseObject) {
        NSLog(@"request failed====%@",responseObject);
    } finishHandler:^(id responseObject) {
        code++;
        //stop animation.etc
        if (responseObject) {
            NSLog(@"request finish=====%@",[responseObject objectForKey:@"message"]);
        }
        
    }];
    
}

- (IBAction)postFileAction:(id)sender
{
    [[BaseEngine sharedEngine] RunPostRequest:[@{@"code":[NSString stringWithFormat:@"%d",code]} mutableCopy] path:@"api/post" attactFile:[[NSBundle mainBundle] pathForResource:@"File" ofType:@"txt"] completionHandler:^(id responseObject) {
        NSDictionary *dict = responseObject;
        
        NSLog(@"request success====%@",dict);
    } errorHandler:^(id responseObject) {
        NSLog(@"request failed====%@",responseObject);
    } finishHandler:^(id responseObject) {
        code++;
        //stop animation.etc
        if (responseObject) {
            NSLog(@"request finish=====%@",[responseObject objectForKey:@"message"]);
        }
        
    }];
}

- (IBAction)downloadAction:(id)sender
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"/Documents/temp%d.md",code]];
    NSString *remoteURL = @"https://github.com/ymsheng/ymsheng.github.io/blob/master/README.md";
    [[BaseEngine sharedEngine] DownloadRequest:remoteURL storeFilePath:filePath finishHandler:^(id responseObject) {
        code++;
        if (responseObject) {
            NSLog(@"down load file path=%@",responseObject);
        }
        else{
            NSLog(@"down load failed");
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
