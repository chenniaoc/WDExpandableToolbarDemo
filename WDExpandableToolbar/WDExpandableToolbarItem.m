//
//  WDExpendableToolbarItem.m
//  WDPlugin_Theme
//
//  Created by zhangyuchen on 1/23/15.
//  Copyright (c) 2015 koudai. All rights reserved.
//

#import "WDExpandableToolbarItem.h"

@implementation WDExpandableToolbarItem


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self setTitle:@"fuck" forState:UIControlStateNormal];
    float a = (arc4random() % 10) * 0.1;
    float b = (arc4random() % 10) * 0.1;
    float c = (arc4random() % 10) * 0.1;
    [self setTitleColor:[UIColor colorWithRed:a green:b blue:c alpha:1.0] forState:UIControlStateNormal];
}


@end
