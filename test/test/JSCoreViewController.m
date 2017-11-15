//
//  JSCoreViewController.m
//  test
//
//  Created by shengli on 2017/11/15.
//  Copyright © 2017年 shengli. All rights reserved.
//

#import "JSCoreViewController.h"
#import "NewTabVC.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface JSCoreViewController () <UIWebViewDelegate>

@end

@implementation JSCoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"温野菜日式火锅";
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:webView];
    webView.delegate = self;
    // 请求部分
    NSURL *url = [NSURL URLWithString:@"https://m.dianping.com/tuan/deal/11506460"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    // 执行js代码
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"pushNewTab"] = ^() {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",[NSThread currentThread]);
            NewTabVC *newTabvc = [[NewTabVC alloc] init];
            [self.navigationController pushViewController:newTabvc animated:YES];
        });
    };
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSMutableString *string = [NSMutableString string];
    // 移除头部导航
    [string appendString:@"var header = document.getElementsByTagName('header')[0];header.parentElement.removeChild(header);"];
    // 移除底部导航
    [string appendString:@"var footer = document.getElementsByClassName('footer')[0];footer.parentNode.removeChild(footer);"];
    // 移除底部按钮
    [string appendString:@"var footBtn = document.getElementsByClassName('footer-btn-fix')[0];footBtn.parentNode.removeChild(footBtn);"];
    // 轮播图增加点击事件
    [string appendString:@"var image = document.getElementsByClassName('swipe-wrap')[0];image.onclick = function () {pushNewTab()}"];
    // 执行js代码
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [context evaluateScript:string];
}

@end
