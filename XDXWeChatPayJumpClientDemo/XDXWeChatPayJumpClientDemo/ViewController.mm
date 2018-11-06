//
//  ViewController.m
//  XDXWeChatPayJumpClientDemo
//
//  Created by 小东邪 on 2018/11/1.
//  Copyright © 2018 小东邪. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "log4cplus.h"
#import "TVUMJRefresh.h"

/*
    本例亲测可以正常跳转及返回
 
    本例注释均英文，如需更详细了解及中文解释，请参考博客，喜欢请给Github星星,简书掘金赞，Thanks!
        GitHub地址(附代码) :
        简书地址     :
        博客地址     :
        掘金地址     :
 

 
    本例包含WKWebview多个属性：与JS交互，上拉刷新，微信支付，请自行选择需要的功能
 
 */



#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define XDX_URL_TIMEOUT 10

static const char *ModuleName = "XDXTestVC";

#warning Note : xdx.tvunetworks.cn -> You must configure it in the Info.plist.  1. the "xdx" prefix you could write any value. 2. xdx.cn you must write your company correct domain by Wechat register.  If your domain is error, it will show "商家参数格式错误，请联系商家解决";


static const NSString *CompanyFirstDomainByWeChatRegister = @"xdx.cn";

@interface ViewController ()<WKNavigationDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView         *webView;
@property (nonatomic, strong) UIProgressView    *progressView;

@property (nonatomic, copy  ) NSString *yourWebAddress;

@end

@implementation ViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    [self initWebView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - Init
- (void)initWebView {
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences = [[WKPreferences alloc] init];
    config.preferences.javaScriptEnabled=YES;
    
    CGFloat webViewY = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, webViewY, kScreenWidth, kScreenHeight-webViewY) configuration:config];
    
#warning Write your webView's address
    self.yourWebAddress = @"http://www.baidu.com";
    log4cplus_info("XDX_LOG", "%s - The web view address is %s",ModuleName, self.yourWebAddress.UTF8String);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.yourWebAddress] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:XDX_URL_TIMEOUT];
    [self.webView loadRequest:request];
    
    TVUMJRefreshNormalHeader *header = [TVUMJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    [header setTitle:@"Pull down to refresh" forState:TVUMJRefreshStateIdle];
    [header setTitle:@"Release to refresh" forState:TVUMJRefreshStatePulling];
    [header setTitle:@"Loading ..." forState:TVUMJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.webView.scrollView.mj_header = header;
    
    [self.view addSubview:self.webView];
    
    //    _webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    
    [self initProgressView];
    // Register event to interact with JS.
    [[_webView configuration].userContentController addScriptMessageHandler:self name:@"getMessage"];
    
    // Listen the web load condition
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)initProgressView {
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 0.8)];
    self.progressView.progressTintColor = [UIColor greenColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.webView addSubview:self.progressView];
}

#pragma mark - UI
- (void)setupUI {
    self.title = @"XDX's World";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(didClickBackBtn)];
    item.tintColor = [UIColor blackColor];
    [self.navigationItem setLeftBarButtonItem:item];
}

- (void)headerRefresh{
    // If user enter our app (not network), the URL is NULL even if we have already setted.
    if (!self.webView.URL) {
        log4cplus_error("XDX_LOG", "Refresh webview error, current URL is NULL !");
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.yourWebAddress] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:XDX_URL_TIMEOUT];
        [self.webView loadRequest:request];
    }
    [self.webView reload];
}

- (void)endRefresh{
    [self.webView.scrollView.mj_header endRefreshing];
}

#pragma mark - Button Action
- (void)didClickBackBtn {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

#pragma mark - Notificaiton
#pragma webView progress view
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([self.progressView isDescendantOfView:self.webView]) {
        if ([keyPath isEqualToString:@"estimatedProgress"]) {
            self.progressView.progress = self.webView.estimatedProgress;
            if (self.progressView.progress == 1) {
                /*
                 *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
                 *动画时长0.25s，延时0.3s后开始动画
                 *动画结束后将progressView隐藏
                 */
                
                __weak ViewController *weakSelf = self;
                [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                    weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
                } completion:^(BOOL finished) {
                    weakSelf.progressView.hidden = YES;
                    
                }];
            }
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
}

#pragma mark - Delegate
#pragma mark WKScriptMessageHandler Delegate
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    log4cplus_info("XDX_LOG", "%s - %s receive the message name is %s, message content is %s.", ModuleName, __func__,[NSString stringWithFormat:@"%@",message.name].UTF8String, [NSString stringWithFormat:@"%@",message.body].UTF8String);
}

#pragma mark - WKNavigation Delegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURLRequest *request        = navigationAction.request;
    NSString     *scheme         = [request.URL scheme];
    NSString     *absoluteString = navigationAction.request.URL.absoluteString;
    NSLog(@"Current URL is %@",absoluteString);
    
    static NSString *endPayRedirectURL = nil;
    
    // Wechat Pay, Note : modify redirect_url to resolve we couldn't return our app from wechat client.
    if ([absoluteString hasPrefix:@"https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb"] && ![absoluteString hasSuffix:[NSString stringWithFormat:@"redirect_url=xdx.%@://",CompanyFirstDomainByWeChatRegister]]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        
#warning Note : The string "xiaodongxie.cn://" must be configured by wechat background. It must be your company first domin. You also should configure "URL types" in the Info.plist file.
        
        // 1. If the url contain "redirect_url" : We need to remember it to use our scheme replace it.
        // 2. If the url not contain "redirect_url" , We should add it so that we will could jump to our app.
        NSString *redirectUrl = nil;
        if ([absoluteString containsString:@"redirect_url="]) {
            endPayRedirectURL = [self getParamValueByName:@"redirect_url" URLString:absoluteString];
            redirectUrl = [self modityParamValueByName:@"redirect_url" newValue:[NSString stringWithFormat:@"xdx.%@://",CompanyFirstDomainByWeChatRegister] URLString:absoluteString];
        }else {
            redirectUrl = [absoluteString stringByAppendingString:[NSString stringWithFormat:@"&redirect_url=xdx.%@://",CompanyFirstDomainByWeChatRegister]];
        }
        
        NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:redirectUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:XDX_URL_TIMEOUT];
        newRequest.allHTTPHeaderFields = request.allHTTPHeaderFields;
        newRequest.URL = [NSURL URLWithString:redirectUrl];
        [webView loadRequest:newRequest];
        return;
    }
    
    // Judge is whether to jump to other app.
    if (![scheme isEqualToString:@"https"] && ![scheme isEqualToString:@"http"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        if ([scheme isEqualToString:[NSString stringWithFormat:@"xdx.%@",CompanyFirstDomainByWeChatRegister]]) {
            
        }
        
        // The var endPayRedirectURL was our saved origin url's redirect address. We need to load it when we return from wechat client.
        if (endPayRedirectURL) {
            NSString *decodeURL = [endPayRedirectURL stringByRemovingPercentEncoding];
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:decodeURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:XDX_URL_TIMEOUT]];
        }
        
        [[UIApplication sharedApplication] openURL:request.URL];
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self endRefresh];
    
    if ([self.progressView isDescendantOfView:self.webView]) {
        self.progressView.hidden = NO;
        self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSString *absoluteString = self.webView.URL.absoluteString;
    log4cplus_debug("XDX_LOG", "%s - %s : Current URL is %s",ModuleName, __func__, absoluteString.UTF8String);
    
    [self endRefresh];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    log4cplus_error("XDX_LOG", "%s - %s : Error code is %s",ModuleName, __func__, [NSString stringWithFormat:@"%@",error].UTF8String);
    [self endRefresh];
}

#pragma mark Gesture Delegate
// Resolve gesture conflict with webView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - Other
- (NSString *)getParamValueByName:(NSString *)name URLString:(NSString *)url {
    if (url.length == 0 || name.length == 0) {
        return nil;
    }
    
    NSError *error;
    NSString *regTags = [[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)", name];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:url
                                      options:0
                                        range:NSMakeRange(0, [url length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *tagValue = [url substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串
        return tagValue;
    }
    return nil;
}

- (NSString *)modityParamValueByName:(NSString *)name newValue:(NSString *)newValue URLString:(NSString *)url {
    if (url.length == 0 || name.length == 0) {
        return nil;
    }
    
    NSError *error;
    NSString *regTags = [[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)", name];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:url
                                      options:0
                                        range:NSMakeRange(0, [url length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *tagValue = [url substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串
        NSString *newStr = [url stringByReplacingOccurrencesOfString:tagValue withString:newValue];
        return newStr;
    }
    
    return nil;
}


#pragma mark - Dealloc
- (void)dealloc {
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"getMessage"];
}


@end
