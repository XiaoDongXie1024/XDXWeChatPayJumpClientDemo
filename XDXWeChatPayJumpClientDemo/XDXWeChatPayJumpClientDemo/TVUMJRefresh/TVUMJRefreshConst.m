//  代码地址: https://github.com/CoderMJLee/TVUMJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
#import <UIKit/UIKit.h>

const CGFloat TVUMJRefreshLabelLeftInset = 25;
const CGFloat TVUMJRefreshHeaderHeight = 54.0;
const CGFloat TVUMJRefreshFooterHeight = 44.0;
const CGFloat TVUMJRefreshFastAnimationDuration = 0.25;
const CGFloat TVUMJRefreshSlowAnimationDuration = 0.4;

NSString *const TVUMJRefreshKeyPathContentOffset = @"contentOffset";
NSString *const TVUMJRefreshKeyPathContentInset = @"contentInset";
NSString *const TVUMJRefreshKeyPathContentSize = @"contentSize";
NSString *const TVUMJRefreshKeyPathPanState = @"state";

NSString *const TVUMJRefreshHeaderLastUpdatedTimeKey = @"TVUMJRefreshHeaderLastUpdatedTimeKey";

NSString *const TVUMJRefreshHeaderIdleText = @"TVUMJRefreshHeaderIdleText";
NSString *const TVUMJRefreshHeaderPullingText = @"TVUMJRefreshHeaderPullingText";
NSString *const TVUMJRefreshHeaderRefreshingText = @"TVUMJRefreshHeaderRefreshingText";

NSString *const TVUMJRefreshAutoFooterIdleText = @"TVUMJRefreshAutoFooterIdleText";
NSString *const TVUMJRefreshAutoFooterRefreshingText = @"TVUMJRefreshAutoFooterRefreshingText";
NSString *const TVUMJRefreshAutoFooterNoMoreDataText = @"TVUMJRefreshAutoFooterNoMoreDataText";

NSString *const TVUMJRefreshBackFooterIdleText = @"TVUMJRefreshBackFooterIdleText";
NSString *const TVUMJRefreshBackFooterPullingText = @"TVUMJRefreshBackFooterPullingText";
NSString *const TVUMJRefreshBackFooterRefreshingText = @"TVUMJRefreshBackFooterRefreshingText";
NSString *const TVUMJRefreshBackFooterNoMoreDataText = @"TVUMJRefreshBackFooterNoMoreDataText";

NSString *const TVUMJRefreshHeaderLastTimeText = @"TVUMJRefreshHeaderLastTimeText";
NSString *const TVUMJRefreshHeaderDateTodayText = @"TVUMJRefreshHeaderDateTodayText";
NSString *const TVUMJRefreshHeaderNoneLastDateText = @"TVUMJRefreshHeaderNoneLastDateText";
