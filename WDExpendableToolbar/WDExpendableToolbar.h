//
//  WDExpendableToolbar.h
//  WDPlugin_Theme
//
//  Created by zhangyuchen on 1/23/15.
//  Copyright (c) 2015 koudai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDExpendableToolbarItem.h"

@class WDExpendableToolbar;

@protocol WDExpendableToolbarDelegate <NSObject>

- (void)expendToolbar:(WDExpendableToolbar *)toolbar
didClickedAtIndexPath:(NSIndexPath *)indexPath;

/************************************
 *
 * 当toolbaritem被点击时，是否需要展示下级菜单
 *
 * @param expendToolbar 二级扩展菜单
 * @param toolbarItem 一级菜单中的按钮
 *
 ***********************************/
- (BOOL)shouldShowExpendToolbar:(WDExpendableToolbar *)expendToolbar
      whenToolbarItemDidClicked:(WDExpendableToolbarItem *)toolbarItem;

@end

@interface WDExpendableToolbar : UIControl

/// toolbar中的一级items
@property (nonatomic, strong, readonly) NSArray *topItems;

/// toolbar中的二级items
@property (nonatomic, strong, readonly) NSArray *expandItems;

@property (nonatomic, weak) id<WDExpendableToolbarDelegate> delegate;


/// 最顶端的Toolbar实例 (如果本身就是最顶端，返回自己，否则返回最顶的)
@property (nonatomic, strong, readonly) WDExpendableToolbar *topToolbar;

/// 返回下一级Toolbar实例，不存在就返回nil
@property (nonatomic, weak, readonly) WDExpendableToolbar *nextLevelToolbar;

/// 返回当前可见的菜单总高度
@property (nonatomic, assign, readonly) CGFloat totalVisibleHeight;

/// 是否处于可见状态
@property (nonatomic, assign) BOOL isShowing;

/// 两边的水平填充(0.0-1.0)
@property (nonatomic, assign) CGFloat horizontalPadding;


- (instancetype)initWithFrame:(CGRect) frame
                     TopItems:(NSArray *)items
              expendToolbarItems:(NSArray *)expandItems;

- (instancetype)initWithTopItems:(NSArray *)items
                  expendToolbarItems:(NSArray *)expandItems NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithFrame:(CGRect) frame
                     TopItems:(NSArray *)items
        extLevelexpendToolbar:(WDExpendableToolbar *)nextLevelToolbar;

- (instancetype)initWithTopItems:(NSArray *)items
              nextLevelexpendToolbar:(WDExpendableToolbar *)nextLevelToolbar NS_DESIGNATED_INITIALIZER;



///************************************
// *
// * 返回最顶端的Toolbar实例
// *
// * @return WDExpendableToolbar 如果本身就是最顶端，返回自己，否则返回最顶的
// *
// ***********************************/
//- (WDExpendableToolbar *)topToolbar;

@end
