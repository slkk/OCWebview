//
//  WKViewController.m
//  test
//
//  Created by shengli on 2017/11/15.
//  Copyright © 2017年 shengli. All rights reserved.
//

#import "WKViewController.h"
#import <WebKit/WebKit.h>
#import "NewTabVC.h"

@interface WKViewController () <WKNavigationDelegate>

@end

@implementation WKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"温野菜日式火锅";
    
    WKWebView *wkwebview = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:wkwebview];
    wkwebview.navigationDelegate = self;
    

    NSURL *url = [NSURL URLWithString:@"https://m.dianping.com/tuan/deal/11506460"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [wkwebview loadRequest:request];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *url = navigationAction.request.URL.absoluteString;
    if ([url isEqualToString:@"tz:newTab"]) {
        NSLog(@"跳转到新tab页面");
        NewTabVC *newTabvc = [[NewTabVC alloc] init];
        [self.navigationController pushViewController:newTabvc animated:YES];
    }
    
    // 回调必须调用，不可省略
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    NSMutableString *string = [NSMutableString string];
    // 移除头部导航
    [string appendString:@"var header = document.getElementsByTagName('header')[0];header.parentElement.removeChild(header);"];
    // 移除底部导航
    [string appendString:@"var footer = document.getElementsByClassName('footer')[0];footer.parentNode.removeChild(footer);"];
    // 移除底部按钮
    [string appendString:@"var footBtn = document.getElementsByClassName('footer-btn-fix')[0];footBtn.parentNode.removeChild(footBtn);"];
    // 轮播图增加点击事件
    [string appendString:@"var image = document.getElementsByClassName('swipe-wrap')[0];image.onclick = function () {window.location.href='tz:newTab'}"];
    
    [webView evaluateJavaScript:string completionHandler:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
