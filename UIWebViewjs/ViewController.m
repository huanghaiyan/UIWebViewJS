//
//  ViewController.m
//  UIWebViewjs
//
//  Created by 王恕 on 16/1/15.
//  Copyright © 2016年 王恕. All rights reserved.
//

#import "ViewController.h"
#import "KVNProgress.h"
#import "TransitionVIew.h"

@interface ViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *myWebView;
@property (nonatomic, strong) TransitionVIew *myTransitionView;
@property (nonatomic) KVNProgressConfiguration *basicConfiguration;


@end

@implementation ViewController

- (UIWebView *)myWebView{

    if (!_myWebView) {
        _myWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        
        NSURL *url = [[NSURL alloc] initWithString:@"http://hcios.com"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [_myWebView loadRequest:request];
        _myWebView.delegate = self;
        [self.view addSubview:_myWebView];
        
    }
    return _myWebView;
}

- (void)viewWillAppear:(BOOL)animated{

    [KVNProgress setConfiguration:self.basicConfiguration];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self myWebView];
    self.basicConfiguration = [KVNProgressConfiguration defaultConfiguration];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
     self.basicConfiguration.backgroundType = KVNProgressBackgroundTypeSolid;
      [KVNProgress show];

    self.myTransitionView = [[TransitionVIew alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.myWebView addSubview:self.myTransitionView];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

    //修改网页展示的风格
    NSMutableString *js = [NSMutableString string];
    // 0.删除顶部的导航条
    [js appendString:@"var header = document.getElementsByTagName('header')[0];header.parentNode.removeChild(header);"];
    
    [self.myWebView stringByEvaluatingJavaScriptFromString:js];
    
    
    //消除网页闪现
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [self.myTransitionView removeFromSuperview];
        
    });
    [KVNProgress dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
