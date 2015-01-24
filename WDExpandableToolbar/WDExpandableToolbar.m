//
//  WDExpendableToolbar.m
//  WDPlugin_Theme
//
//  Created by zhangyuchen on 1/23/15.
//  Copyright (c) 2015 koudai. All rights reserved.
//

#import "WDExpandableToolbar.h"

#import <objc/runtime.h>

static NSString * const kWDExpandableToolbarPreviousToolbarStorageKey = @"kWDExpandableToolbarPreviousToolbarStorageKey";

@interface WDExpandableToolbar ()
{
    NSMutableArray *m_items;
    
    /// 本层菜单需要弹出的下级菜单
    WDExpandableToolbar *m_nextLevelToolbar;
    
    struct kWDDelegateFlag
    {
        int expandToolbarDidClickedAtIndexPath:1;
        int shouldShowExpandToolbarWhenToolbarItemDidClicked:1;
    } m_DelegateFlag;
    
    // 是否正在显示nextlevel
    BOOL m_isNextLevelShowing;
    
    CGRect m_originFrame;
}

@end

@implementation WDExpandableToolbar



- (instancetype)initWithFrame:(CGRect)frame
                     TopItems:(NSArray *)items
           expandToolbarItems:(NSArray *)expandItems
{
    self = [self initWithTopItems:items expandToolbarItems:expandItems];
    if (self) {
        self.frame = frame;
    }
    return self;
}

- (instancetype)initWithTopItems:(NSArray *)items
              expandToolbarItems:(NSArray *)expandItems
{
    self = [super init];
    if (self) {
        m_items = [items mutableCopy];
        if (expandItems && expandItems.count > 0) {
            m_nextLevelToolbar = [[WDExpandableToolbar alloc] initWithFrame:self.frame
                                                                   TopItems:expandItems
                                                         expandToolbarItems:nil];
        }

        [self _initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect) frame
                     TopItems:(NSArray *)items
        extLevelexpandToolbar:(WDExpandableToolbar *)nextLevelToolbar
{
    self = [self initWithTopItems:items
           nextLevelexpandToolbar:nextLevelToolbar];
    if (self) {
        self.frame = frame;
        
        [self _initialize];
    }
    return self;
}

- (instancetype)initWithTopItems:(NSArray *)items
          nextLevelexpandToolbar:(WDExpandableToolbar *)nextLevelToolbar
{
    self = [super init];
    if (self) {
        m_items = [items mutableCopy];
        m_nextLevelToolbar = nextLevelToolbar;
        
        if (m_nextLevelToolbar) {
            objc_setAssociatedObject(m_nextLevelToolbar, &kWDExpandableToolbarPreviousToolbarStorageKey, self, OBJC_ASSOCIATION_ASSIGN);
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
        WDExpandableToolbarItem *item = obj;
        item.tag = idx;
        [item addTarget:self action:@selector(_itemButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:item];
    }];
}

- (void)setDelegate:(id<WDExpandableToolbarDelegate>)delegate
{
    if ([delegate respondsToSelector:@selector(expandToolbar:didClickedAtIndexPath:)]) {
        m_DelegateFlag.expandToolbarDidClickedAtIndexPath = 1;
    }
    if ([delegate respondsToSelector:@selector(shouldShowExpandToolbar:whenToolbarItemDidClicked:)]) {
        m_DelegateFlag.shouldShowExpandToolbarWhenToolbarItemDidClicked = 1;
    }
    _delegate = delegate;
}


#pragma mark -Accessor

- (BOOL)isTopToolbar
{
    id superToolbar = objc_getAssociatedObject(self, &kWDExpandableToolbarPreviousToolbarStorageKey);
    return superToolbar ? NO : YES;
}

- (WDExpandableToolbar *)nextLevelToolbar
{
    return m_nextLevelToolbar;
}

- (CGFloat)totalVisibleHeight
{
    CGFloat totalHeight = 0;
    // 向上层方向找，包含自己.
    WDExpandableToolbar *temp = self;
    while (temp != nil) {
        if (temp.isShowing) {
            totalHeight += temp.frame.size.height;
        }
        temp = objc_getAssociatedObject(temp, &kWDExpandableToolbarPreviousToolbarStorageKey);
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
- (WDExpandableToolbar *)topToolbar
{
    WDExpandableToolbar *topTemp = self;
    while (topTemp != nil) {
        WDExpandableToolbar *temp = objc_getAssociatedObject(topTemp, &kWDExpandableToolbarPreviousToolbarStorageKey);
        if (temp == nil) {
            break;
        }
        topTemp = temp;
        
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
        f.origin.x = idx * (buttonWidth) + leftPadding;
        f.size.width = buttonWidth;
        item.frame = f;
        [self addSubview:item];
    }];
    
}

- (void)_itemButtonClicked:(WDExpandableToolbarItem *)item
{
    BOOL shouldShow = YES;
    if (m_DelegateFlag.shouldShowExpandToolbarWhenToolbarItemDidClicked) {
        shouldShow = [_delegate shouldShowExpandToolbar:self whenToolbarItemDidClicked:item];
    }
    
    if (shouldShow) {
        [self _showNextLevelToolBarFromBottom];
    } else {
        [self _hideNextLevelToolBarFromBottom];
    }
    
    
    if (m_DelegateFlag.expandToolbarDidClickedAtIndexPath) {
        [_delegate expandToolbar:self didClickedAtIndexPath:nil];
    }
    
    [self _adjustFrame];
    
    
    _isShowing = YES;
    
}

- (void)_adjustFrame
{
    WDExpandableToolbar *toolbar = [self nextLevelToolbar];;
    CGRect myFrame = self.frame;
    
    CGFloat heightOffset = 0;
    while (toolbar) {
        if (toolbar.isShowing) {
            heightOffset += toolbar.frame.size.height;
        }
        toolbar = [toolbar nextLevelToolbar];
    }
    
    if (heightOffset > 0) {
        
        
        // top toolbar - [N - 1]位置的toolbar，如果最下层的toolbar已经处于展示状态，就不用重新算了
        // 直接返回.
        WDExpandableToolbar *superToolbar = objc_getAssociatedObject(self, &kWDExpandableToolbarPreviousToolbarStorageKey);
        if (m_nextLevelToolbar && m_nextLevelToolbar.isShowing) {
            if (superToolbar || [self isTopToolbar]) {
                return;
            }
        }
        if (m_nextLevelToolbar || [self isTopToolbar] ){
            heightOffset += m_originFrame.size.height;
        }

        
        myFrame.size.height = heightOffset;
        
        
        self.frame = myFrame;
    } else{
        
        WDExpandableToolbar *superToolbar = objc_getAssociatedObject(self, &kWDExpandableToolbarPreviousToolbarStorageKey);
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
        
        
        WDExpandableToolbar *superToolbar = objc_getAssociatedObject(m_nextLevelToolbar, &kWDExpandableToolbarPreviousToolbarStorageKey);
        CGFloat heightOffset = self.frame.size.height;
        while (superToolbar != nil) {
            CGRect superF = superToolbar.frame;
            superF.size.height += heightOffset;
//            heightOffset += superF.size.height;
            superToolbar.frame = superF;
            superToolbar = objc_getAssociatedObject(superToolbar, &kWDExpandableToolbarPreviousToolbarStorageKey);
        }
        
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
