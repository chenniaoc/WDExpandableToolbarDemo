//
//  WDExpendableToolbar.m
//  WDPlugin_Theme
//
//  Created by zhangyuchen on 1/23/15.
//  Copyright (c) 2015 koudai. All rights reserved.
//

#import "WDExpendableToolbar.h"

#import <objc/runtime.h>

static NSString * const kWDExpendableToolbarPreviousToolbarStorageKey = @"kWDExpendableToolbarPreviousToolbarStorageKey";

@interface WDExpendableToolbar ()
{
    NSMutableArray *m_items;
    
    /// 本层菜单需要弹出的下级菜单
    WDExpendableToolbar *m_nextLevelToolbar;
    
    struct kWDDelegateFlag
    {
        int expendToolbarDidClickedAtIndexPath:1;
        int shouldShowExpendToolbarWhenToolbarItemDidClicked:1;
    } m_DelegateFlag;
    
    // 是否正在显示nextlevel
    BOOL m_isNextLevelShowing;
    
    CGRect m_originFrame;
}

@end

@implementation WDExpendableToolbar



- (instancetype)initWithFrame:(CGRect)frame
                     TopItems:(NSArray *)items
           expendToolbarItems:(NSArray *)expandItems
{
    self = [self initWithTopItems:items expendToolbarItems:expandItems];
    if (self) {
        self.frame = frame;
    }
    return self;
}

- (instancetype)initWithTopItems:(NSArray *)items
              expendToolbarItems:(NSArray *)expandItems
{
    self = [super init];
    if (self) {
        m_items = [items mutableCopy];
        if (expandItems && expandItems.count > 0) {
            m_nextLevelToolbar = [[WDExpendableToolbar alloc] initWithFrame:self.frame
                                                                   TopItems:expandItems
                                                         expendToolbarItems:nil];
        }

        [self _initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect) frame
                     TopItems:(NSArray *)items
        extLevelexpendToolbar:(WDExpendableToolbar *)nextLevelToolbar
{
    self = [self initWithTopItems:items
           nextLevelexpendToolbar:nextLevelToolbar];
    if (self) {
        self.frame = frame;
        
        [self _initialize];
    }
    return self;
}

- (instancetype)initWithTopItems:(NSArray *)items
          nextLevelexpendToolbar:(WDExpendableToolbar *)nextLevelToolbar
{
    self = [super init];
    if (self) {
        m_items = [items mutableCopy];
        m_nextLevelToolbar = nextLevelToolbar;
        
        if (m_nextLevelToolbar) {
            objc_setAssociatedObject(m_nextLevelToolbar, &kWDExpendableToolbarPreviousToolbarStorageKey, self, OBJC_ASSOCIATION_ASSIGN);
        }
    }
    
    return self;
}

- (void)_initialize
{
    m_originFrame = self.frame;
    m_DelegateFlag = (struct kWDDelegateFlag) {0,0};
    _horizontalPadding = 0.0f;
    [self _createItems];
}

- (void)_createItems
{
    [m_items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        WDExpendableToolbarItem *item = obj;
        item.tag = idx;
        [item addTarget:self action:@selector(_itemButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:item];
    }];
}

- (void)setDelegate:(id<WDExpendableToolbarDelegate>)delegate
{
    if ([delegate respondsToSelector:@selector(expendToolbar:didClickedAtIndexPath:)]) {
        m_DelegateFlag.expendToolbarDidClickedAtIndexPath = 1;
    }
    if ([delegate respondsToSelector:@selector(shouldShowExpendToolbar:whenToolbarItemDidClicked:)]) {
        m_DelegateFlag.shouldShowExpendToolbarWhenToolbarItemDidClicked = 1;
    }
    _delegate = delegate;
}


#pragma mark -Accessor

- (WDExpendableToolbar *)nextLevelToolbar
{
    return m_nextLevelToolbar;
}

- (CGFloat)totalVisibleHeight
{
    CGFloat totalHeight = 0;
    // 向上层方向找，包含自己.
    WDExpendableToolbar *temp = self;
    while (temp != nil) {
        if (temp.isShowing) {
            totalHeight += temp.frame.size.height;
        }
        temp = objc_getAssociatedObject(temp, &kWDExpendableToolbarPreviousToolbarStorageKey);
    }
    
    temp = m_nextLevelToolbar;
    // 向下找
    while (temp) {
        if (temp.isShowing) {
            totalHeight += temp.frame.size.height;
        }
        temp = [temp nextLevelToolbar];
    }
    
    return totalHeight;
}

/************************************
 *
 * 返回最顶端的Toolbar实例
 *
 * @return WDExpendableToolbar 如果本身就是最顶端，返回自己，否则返回最顶的
 *
 ***********************************/
- (WDExpendableToolbar *)topToolbar
{
    WDExpendableToolbar *topTemp = self;
    while (topTemp != nil) {
        topTemp = objc_getAssociatedObject(topTemp, &kWDExpendableToolbarPreviousToolbarStorageKey);
    }
    return topTemp ? topTemp : self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)layoutSubviews
{
    // layout buttons
    [self _layoutButtonIfNeeded];
}

- (void)_layoutButtonIfNeeded
{
    CGFloat leftPadding = 0.0f;
    if (_horizontalPadding > 0.0f) {
        leftPadding = roundf(self.frame.size.width * _horizontalPadding);
    }
    
    CGFloat buttonWidth = (self.frame.size.width - leftPadding * 2) / m_items.count;
    
    [m_items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *item = obj;
        CGRect f = item.frame;
        f.origin.x = idx * buttonWidth;
        f.size.width = buttonWidth;
        item.frame = f;
        [self addSubview:item];
    }];
    
}

- (void)_itemButtonClicked:(WDExpendableToolbarItem *)item
{
    BOOL shouldShow = YES;
    if (m_DelegateFlag.shouldShowExpendToolbarWhenToolbarItemDidClicked) {
        shouldShow = [_delegate shouldShowExpendToolbar:self whenToolbarItemDidClicked:item];
    }
    
    if (shouldShow) {
        [self _showNextLevelToolBarFromBottom];
    } else {
        [self _hideNextLevelToolBarFromBottom];
    }
    
    
    if (m_DelegateFlag.expendToolbarDidClickedAtIndexPath) {
        [_delegate expendToolbar:self didClickedAtIndexPath:nil];
    }
    
    [self _adjustFrame];
    
    
    _isShowing = YES;
    
}

- (void)_adjustFrame
{
    WDExpendableToolbar *toolbar = [self nextLevelToolbar];;
    CGRect myFrame = self.frame;
    
    CGFloat heightOffset = 0;
    while (toolbar) {
        if (toolbar.isShowing) {
            heightOffset += toolbar.frame.size.height;
        }
        toolbar = [toolbar nextLevelToolbar];
    }
    
    if (heightOffset > 0) {
        myFrame.size.height = heightOffset + m_originFrame.size.height;
        self.frame = myFrame;
    } else{
        
        WDExpendableToolbar *superToolbar = objc_getAssociatedObject(self, &kWDExpendableToolbarPreviousToolbarStorageKey);
        // 上面还有
        if (superToolbar) {
            
        } else {
            self.frame = m_originFrame;
        }
    }
}

- (void)_showNextLevelToolBarFromBottom
{
    if (m_isNextLevelShowing) {
        return;
    }
    if (m_nextLevelToolbar) {
        [self addSubview:m_nextLevelToolbar];
        m_nextLevelToolbar.center = CGPointMake(self.frame.size.width / 2, 0);
        [UIView animateWithDuration:0.3 animations:^{
           m_nextLevelToolbar.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height + m_nextLevelToolbar.frame.size.height / 2);
        }];
        m_nextLevelToolbar.isShowing = YES;
    }
    
    m_isNextLevelShowing = YES;
}

- (void)_hideNextLevelToolBarFromBottom
{
    if (m_isNextLevelShowing == NO) {
        return;
    }
    
    m_isNextLevelShowing = NO;
}

- (void)hideSelf
{
    
}


@end
