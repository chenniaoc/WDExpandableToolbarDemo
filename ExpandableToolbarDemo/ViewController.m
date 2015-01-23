//
//  ViewController.m
//  ExpandableToolbarDemo
//
//  Created by zhangyuchen on 1/23/15.
//  Copyright (c) 2015 yuchen. All rights reserved.
//

#import "ViewController.h"
#import "WDExpendableToolbar.h"
#import "WDExpendableToolbarItem.h"

@interface ViewController () <WDExpendableToolbarDelegate>

@property (nonatomic, strong) WDExpendableToolbar *topToolbar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray *a = [NSMutableArray array];
    
    for (int i = 0 ; i< 4; i++) {
        WDExpendableToolbarItem *item = [WDExpendableToolbarItem new];
        item.frame = CGRectMake(0, 0, 100, 44);
        [a addObject:item];
    }
    
    WDExpendableToolbar *et = [[WDExpendableToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) TopItems:a extLevelexpendToolbar:nil];
    
    et.delegate = self;
    
    
    a = [NSMutableArray array];
    
    for (int i = 0 ; i< 4; i++) {
        WDExpendableToolbarItem *item = [WDExpendableToolbarItem new];
        item.frame = CGRectMake(0, 0, 100, 44);
        [a addObject:item];
    }
    
    WDExpendableToolbar *etRoot = [[WDExpendableToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) TopItems:a extLevelexpendToolbar:et];
    
    etRoot.delegate = self;
    
    a = [NSMutableArray array];
    
    for (int i = 0 ; i< 4; i++) {
        WDExpendableToolbarItem *item = [WDExpendableToolbarItem new];
        item.frame = CGRectMake(0, 0, 100, 44);
        [a addObject:item];
    }
    
    etRoot = [[WDExpendableToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) TopItems:a extLevelexpendToolbar:etRoot];
    
    etRoot.delegate = self;
    
    
    a = [NSMutableArray array];
    for (int i = 0 ; i< 4; i++) {
        WDExpendableToolbarItem *item = [WDExpendableToolbarItem new];
        item.frame = CGRectMake(0, 0, 100, 44);
        [a addObject:item];
    }
    
    etRoot = [[WDExpendableToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) TopItems:a extLevelexpendToolbar:etRoot];
    
    etRoot.delegate = self;
    
    
    
    _topToolbar = etRoot;
    
    
    a = [NSMutableArray array];
    for (int i = 0 ; i< 4; i++) {
        WDExpendableToolbarItem *item = [WDExpendableToolbarItem new];
        item.frame = CGRectMake(0, 0, 100, 44);
        [a addObject:item];
    }
    
    etRoot = [[WDExpendableToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) TopItems:a extLevelexpendToolbar:etRoot];
    
    etRoot.delegate = self;
    
    
    
    _topToolbar = etRoot;
    
    
    a = [NSMutableArray array];
    for (int i = 0 ; i< 4; i++) {
        WDExpendableToolbarItem *item = [WDExpendableToolbarItem new];
        item.frame = CGRectMake(0, 0, 100, 44);
        [a addObject:item];
    }
    
    etRoot = [[WDExpendableToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) TopItems:a extLevelexpendToolbar:etRoot];
    
    etRoot.delegate = self;
    
    
    
    _topToolbar = etRoot;
    
    a = [NSMutableArray array];
    for (int i = 0 ; i< 4; i++) {
        WDExpendableToolbarItem *item = [WDExpendableToolbarItem new];
        item.frame = CGRectMake(0, 0, 100, 44);
        [a addObject:item];
    }
    
    etRoot = [[WDExpendableToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) TopItems:a extLevelexpendToolbar:etRoot];
    
    etRoot.delegate = self;
    
    
    
    _topToolbar = etRoot;
    
    
    a = [NSMutableArray array];
    for (int i = 0 ; i< 4; i++) {
        WDExpendableToolbarItem *item = [WDExpendableToolbarItem new];
        item.frame = CGRectMake(0, 0, 100, 44);
        [a addObject:item];
    }
    
    etRoot = [[WDExpendableToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) TopItems:a extLevelexpendToolbar:etRoot];
    
    etRoot.delegate = self;
    
    
    
    _topToolbar = etRoot;
    
    
    
    
    [self.view addSubview:etRoot];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)expendToolbar:(WDExpendableToolbar *)toolbar didClickedAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", toolbar);
    
    WDExpendableToolbar *top = [toolbar topToolbar];
    
    CGFloat height = toolbar.totalVisibleHeight;
    
    
    
    
}

- (BOOL)shouldShowExpendToolbar:(WDExpendableToolbar *)expendToolbar whenToolbarItemDidClicked:(WDExpendableToolbarItem *)toolbarItem
{
    NSLog(@"shouldShowExpendToolbar %@", NSStringFromSelector(_cmd));
    
    return [expendToolbar nextLevelToolbar]? YES : NO;
}

@end
