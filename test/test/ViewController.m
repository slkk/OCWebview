//
//  ViewController.m
//  test
//
//  Created by shengli on 2017/11/9.
//  Copyright © 2017年 shengli. All rights reserved.
//

#import "ViewController.h"
#import "NewTabVC.h"


@interface ViewController () <UIWebViewDelegate>

@end

@implementation ViewController

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

}

// 网页将要加载的时候调用
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    // 请求的地址
    NSString *url = request.URL.absoluteString;
    NSLog(@"url--->%@",url);
    // 判断url是否是我们在webViewDidFinishLoad中给轮播图增加的自定义方法
    // 如果是，在判断中增加自己的跳转操作
    if ([url isEqualToString:@"tz:newTab"]) {
        NSLog(@"跳转到新tab页面");
        NewTabVC *newTabvc = [[NewTabVC alloc] init];
        [self.navigationController pushViewController:newTabvc animated:YES];
    }
    
    return YES;
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
    [string appendString:@"var image = document.getElementsByClassName('swipe-wrap')[0];image.onclick = function () {window.location.href='tz:newTab'}"];
    // 执行js代码
    [webView stringByEvaluatingJavaScriptFromString:string];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
