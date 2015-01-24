//
//  ViewController.m
//  ExpandableToolbarDemo
//
//  Created by zhangyuchen on 1/23/15.
//  Copyright (c) 2015 yuchen. All rights reserved.
//

#import "ViewController.h"
#import "WDExpandableToolbar.h"
#import "WDExpandableToolbarItem.h"

@interface ViewController () <WDExpandableToolbarDelegate>

@property (nonatomic, strong) WDExpandableToolbar *topToolbar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray *a = [NSMutableArray array];
    
    for (int i = 0 ; i< 4; i++) {
        WDExpandableToolbarItem *item = [WDExpandableToolbarItem new];
        item.frame = CGRectMake(0, 0, 100, 44);
        [a addObject:item];
    }
    
    WDExpandableToolbar *et = [[WDExpandableToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) TopItems:a extLevelexpandToolbar:nil];
    
    et.delegate = self;
    
    
//    a = [NSMutableArray array];
//    
//    for (int i = 0 ; i< 4; i++) {
//        WDExpendableToolbarItem *item = [WDExpendableToolbarItem new];
//        item.frame = CGRectMake(0, 0, 100, 44);
//        [a addObject:item];
//    }
//    
    WDExpandableToolbar *etRoot = [[WDExpandableToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) TopItems:a extLevelexpandToolbar:et];
    
    etRoot.delegate = self;
    
    a = [NSMutableArray array];
    
    for (int i = 0 ; i< 4; i++) {
        WDExpandableToolbarItem *item = [WDExpandableToolbarItem new];
        item.frame = CGRectMake(0, 0, 100, 44);
        [a addObject:item];
    }
//
//    etRoot = [[WDExpendableToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) TopItems:a extLevelexpendToolbar:etRoot];
//    
//    etRoot.delegate = self;
//    
//    
//    a = [NSMutableArray array];
//    for (int i = 0 ; i< 4; i++) {
//        WDExpendableToolbarItem *item = [WDExpendableToolbarItem new];
//        item.frame = CGRectMake(0, 0, 100, 44);
//        [a addObject:item];
//    }
//    
//    etRoot = [[WDExpendableToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) TopItems:a extLevelexpendToolbar:etRoot];
//    
//    etRoot.delegate = self;
//    
//    
//    
//    _topToolbar = etRoot;
//    
//    
//    a = [NSMutableArray array];
//    for (int i = 0 ; i< 4; i++) {
//        WDExpendableToolbarItem *item = [WDExpendableToolbarItem new];
//        item.frame = CGRectMake(0, 0, 100, 44);
//        [a addObject:item];
//    }
//    
//    etRoot = [[WDExpendableToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) TopItems:a extLevelexpendToolbar:etRoot];
//    
//    etRoot.delegate = self;
//    
//    
//    
//    _topToolbar = etRoot;
//    
//    
//    a = [NSMutableArray array];
//    for (int i = 0 ; i< 4; i++) {
//        WDExpendableToolbarItem *item = [WDExpendableToolbarItem new];
//        item.frame = CGRectMake(0, 0, 100, 44);
//        [a addObject:item];
//    }
//    
//    etRoot = [[WDExpendableToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) TopItems:a extLevelexpendToolbar:etRoot];
//    
//    etRoot.delegate = self;
//    
//    
//    
//    _topToolbar = etRoot;
//    
//    a = [NSMutableArray array];
//    for (int i = 0 ; i< 4; i++) {
//        WDExpendableToolbarItem *item = [WDExpendableToolbarItem new];
//        item.frame = CGRectMake(0, 0, 100, 44);
//        [a addObject:item];
//    }
//    
//    etRoot = [[WDExpendableToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) TopItems:a extLevelexpendToolbar:etRoot];
//    
//    etRoot.delegate = self;
//    
//    
//    
//    _topToolbar = etRoot;
//    
//    
//    a = [NSMutableArray array];
//    for (int i = 0 ; i< 4; i++) {
//        WDExpendableToolbarItem *item = [WDExpendableToolbarItem new];
//        item.frame = CGRectMake(0, 0, 100, 44);
//        [a addObject:item];
//    }
//    
//    etRoot = [[WDExpendableToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) TopItems:a extLevelexpendToolbar:etRoot];
//    
//    etRoot.delegate = self;
    
    
    
    int count = 30;
    
    while (count > 0) {
        
        a = [NSMutableArray array];
        int randomCount = MAX(arc4random() % 20, 10);
        for (int i = 0 ; i< randomCount; i++) {
            
            NSString *filename = [NSString stringWithFormat:@"%02d", (arc4random()% 11 + 1)];
            WDExpandableToolbarItem *item = [WDExpandableToolbarItem new];
            item.frame = CGRectMake(0, 0, 100, 30);
            NSLog(@"filenmae:%@", filename);
            UIImage *image = [UIImage imageNamed:filename];
            item.imageView.contentMode = UIViewContentModeScaleAspectFit;;
            [item setImage:image forState:UIControlStateNormal];
            [a addObject:item];
        }
        
        etRoot = [[WDExpandableToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) TopItems:a extLevelexpandToolbar:etRoot];
        etRoot.horizontalPadding = 0.01;
        
        etRoot.delegate = self;
        count --;
    }
    
    
    
    _topToolbar = etRoot;
    
    
    
    
    [self.view addSubview:etRoot];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)expandToolbar:(WDExpandableToolbar *)toolbar didClickedAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", toolbar);
    
    WDExpandableToolbar *top = [toolbar topToolbar];
    
    CGFloat height = toolbar.totalVisibleHeight;
    
    
    
    
}

- (BOOL)shouldShowExpandToolbar:(WDExpandableToolbar *)expandToolbar whenToolbarItemDidClicked:(WDExpandableToolbarItem *)toolbarItem
{
    NSLog(@"shouldShowExpandToolbar %@", NSStringFromSelector(_cmd));
    
    return [expandToolbar nextLevelToolbar]? YES : NO;
}

@end
