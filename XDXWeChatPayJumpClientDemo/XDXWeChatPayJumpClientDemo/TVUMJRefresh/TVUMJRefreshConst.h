//  代码地址: https://github.com/CoderMJLee/TVUMJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
#import <UIKit/UIKit.h>
#import <objc/message.h>

// 弱引用
#define MJWeakSelf __weak typeof(self) weakSelf = self;

// 日志输出
#ifdef DEBUG
#define TVUMJRefreshLog(...) NSLog(__VA_ARGS__)
#else
#define TVUMJRefreshLog(...)
#endif

// 过期提醒
#define TVUMJRefreshDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

// 运行时objc_msgSend
#define TVUMJRefreshMsgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define TVUMJRefreshMsgTarget(target) (__bridge void *)(target)

// RGB颜色
#define TVUMJRefreshColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 文字颜色
#define TVUMJRefreshLabelTextColor TVUMJRefreshColor(90, 90, 90)

// 字体大小
#define TVUMJRefreshLabelFont [UIFont boldSystemFontOfSize:14]

// 常量
UIKIT_EXTERN const CGFloat TVUMJRefreshLabelLeftInset;
UIKIT_EXTERN const CGFloat TVUMJRefreshHeaderHeight;
UIKIT_EXTERN const CGFloat TVUMJRefreshFooterHeight;
UIKIT_EXTERN const CGFloat TVUMJRefreshFastAnimationDuration;
UIKIT_EXTERN const CGFloat TVUMJRefreshSlowAnimationDuration;

UIKIT_EXTERN NSString *const TVUMJRefreshKeyPathContentOffset;
UIKIT_EXTERN NSString *const TVUMJRefreshKeyPathContentSize;
UIKIT_EXTERN NSString *const TVUMJRefreshKeyPathContentInset;
UIKIT_EXTERN NSString *const TVUMJRefreshKeyPathPanState;

UIKIT_EXTERN NSString *const TVUMJRefreshHeaderLastUpdatedTimeKey;

UIKIT_EXTERN NSString *const TVUMJRefreshHeaderIdleText;
UIKIT_EXTERN NSString *const TVUMJRefreshHeaderPullingText;
UIKIT_EXTERN NSString *const TVUMJRefreshHeaderRefreshingText;

UIKIT_EXTERN NSString *const TVUMJRefreshAutoFooterIdleText;
UIKIT_EXTERN NSString *const TVUMJRefreshAutoFooterRefreshingText;
UIKIT_EXTERN NSString *const TVUMJRefreshAutoFooterNoMoreDataText;

UIKIT_EXTERN NSString *const TVUMJRefreshBackFooterIdleText;
UIKIT_EXTERN NSString *const TVUMJRefreshBackFooterPullingText;
UIKIT_EXTERN NSString *const TVUMJRefreshBackFooterRefreshingText;
UIKIT_EXTERN NSString *const TVUMJRefreshBackFooterNoMoreDataText;

UIKIT_EXTERN NSString *const TVUMJRefreshHeaderLastTimeText;
UIKIT_EXTERN NSString *const TVUMJRefreshHeaderDateTodayText;
UIKIT_EXTERN NSString *const TVUMJRefreshHeaderNoneLastDateText;

// 状态检查
#define TVUMJRefreshCheckState \
TVUMJRefreshState oldState = self.state; \
if (state == oldState) return; \
[super setState:state];

// 异步主线程执行，不强持有Self
#define TVUMJRefreshDispatchAsyncOnMainQueue(x) \
__weak typeof(self) weakSelf = self; \
dispatch_async(dispatch_get_main_queue(), ^{ \
typeof(weakSelf) self = weakSelf; \
{x} \
});

