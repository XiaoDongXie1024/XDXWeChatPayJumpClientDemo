//  代码地址: https://github.com/CoderMJLee/TVUMJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  UIScrollView+TVUMJRefresh.m
//  TVUMJRefreshExample
//
//  Created by MJ Lee on 15/3/4.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "UIScrollView+TVUMJRefresh.h"
#import "TVUMJRefreshHeader.h"
#import "TVUMJRefreshFooter.h"
#import <objc/runtime.h>

@implementation NSObject (TVUMJRefresh)

+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

+ (void)exchangeClassMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
}

@end

@implementation UIScrollView (TVUMJRefresh)

#pragma mark - header
static const char TVUMJRefreshHeaderKey = '\0';
- (void)setMj_header:(TVUMJRefreshHeader *)mj_header
{
    if (mj_header != self.mj_header) {
        // 删除旧的，添加新的
        [self.mj_header removeFromSuperview];
        [self insertSubview:mj_header atIndex:0];
        
        // 存储新的
        objc_setAssociatedObject(self, &TVUMJRefreshHeaderKey,
                                 mj_header, OBJC_ASSOCIATION_RETAIN);
    }
}

- (TVUMJRefreshHeader *)mj_header
{
    return objc_getAssociatedObject(self, &TVUMJRefreshHeaderKey);
}

#pragma mark - footer
static const char TVUMJRefreshFooterKey = '\0';
- (void)setMj_footer:(TVUMJRefreshFooter *)mj_footer
{
    if (mj_footer != self.mj_footer) {
        // 删除旧的，添加新的
        [self.mj_footer removeFromSuperview];
        [self insertSubview:mj_footer atIndex:0];
        
        // 存储新的
        objc_setAssociatedObject(self, &TVUMJRefreshFooterKey,
                                 mj_footer, OBJC_ASSOCIATION_RETAIN);
    }
}

- (TVUMJRefreshFooter *)mj_footer
{
    return objc_getAssociatedObject(self, &TVUMJRefreshFooterKey);
}

#pragma mark - 过期
- (void)setFooter:(TVUMJRefreshFooter *)footer
{
    self.mj_footer = footer;
}

- (TVUMJRefreshFooter *)footer
{
    return self.mj_footer;
}

- (void)setHeader:(TVUMJRefreshHeader *)header
{
    self.mj_header = header;
}

- (TVUMJRefreshHeader *)header
{
    return self.mj_header;
}

#pragma mark - other
- (NSInteger)mj_totalDataCount
{
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        
        for (NSInteger section = 0; section<tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        
        for (NSInteger section = 0; section<collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

static const char TVUMJRefreshReloadDataBlockKey = '\0';
- (void)setMj_reloadDataBlock:(void (^)(NSInteger))mj_reloadDataBlock
{
    [self willChangeValueForKey:@"mj_reloadDataBlock"]; // KVO
    objc_setAssociatedObject(self, &TVUMJRefreshReloadDataBlockKey, mj_reloadDataBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"mj_reloadDataBlock"]; // KVO
}

- (void (^)(NSInteger))mj_reloadDataBlock
{
    return objc_getAssociatedObject(self, &TVUMJRefreshReloadDataBlockKey);
}

- (void)executeReloadDataBlock
{
    !self.mj_reloadDataBlock ? : self.mj_reloadDataBlock(self.mj_totalDataCount);
}
@end

@implementation UITableView (TVUMJRefresh)

+ (void)load
{
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(mj_reloadData)];
}

- (void)mj_reloadData
{
    [self mj_reloadData];
    
    [self executeReloadDataBlock];
}
@end

@implementation UICollectionView (TVUMJRefresh)

+ (void)load
{
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(mj_reloadData)];
}

- (void)mj_reloadData
{
    [self mj_reloadData];
    
    [self executeReloadDataBlock];
}
@end
