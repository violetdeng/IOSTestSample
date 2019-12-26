//
//  WebviewViewController.m
//  TestSample
//
//  Created by Violet Deng on 2019/12/25.
//  Copyright © 2019 Violet Deng. All rights reserved.
//

#import "WebviewViewController.h"

@interface WebviewViewController()

@property (strong, nonatomic) WKWebView *webView;

@end

@implementation WebviewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //创建网页配置对象
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    // 实现console.log
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addScriptMessageHandler:self name:@"log"];
    [self showConsole:userContentController];
    config.userContentController = userContentController;
    
    [config.preferences setValue:@YES forKey:@"allowFileAccessFromFileURLs"];
//    [config.preferences setValue:@YES forKey:@"developerExtrasEnabled"];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    
    // 设置代理alert/confirm
    self.webView.UIDelegate = self;
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"index.html" ofType:nil];
//    NSString *htmlString = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    [self.webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    
    NSString* productURL = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"index.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:productURL]];
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.webView];
}

- (void)showConsole:(WKUserContentController *)userContentController {
    //rewrite the method of console.log
//    NSString *jsCode = @"console.log = (function(oriLogFunc){\
//    return function(str)\
//    {\
//    window.webkit.messageHandlers.log.postMessage({type: 'log', data: str});\
//    oriLogFunc.call(console,str);\
//    }\
//    })(console.log);\
//    console.error = (function(oriLogFunc){\
//    return function(str)\
//    {\
//    window.webkit.messageHandlers.log.postMessage({type: 'error', data: str});\
//    oriLogFunc.call(console,str);\
//    }\
//    })(console.error);";
    
    NSString *jsCode = @"";
    
    //injected the method when H5 starts to create the DOM tree
    [userContentController addUserScript:[[WKUserScript alloc] initWithSource:jsCode injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES]];
}

#pragma mark -- WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    // NSNumber, NSString, NSDate, NSArray, NSDictionary, and NSNull
    if ([message.body isKindOfClass:[NSDictionary class]]) {
        NSDictionary *body = [NSDictionary dictionaryWithDictionary:message.body];
        NSString *type = [NSString stringWithString:[body objectForKey:@"type"]];
        if ([type isEqualToString:@"error"]) {
            NSLog(@"console.error %@", [body objectForKey:@"data"]);
        } else {
            NSLog(@"console.log %@", [body objectForKey:@"data"]);
        }
    } else {
        NSLog(@"console.log %@", message.body);
    }
}

#pragma mark -- WKUIDelegate
// alert
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

// confirm
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

// prompt
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
