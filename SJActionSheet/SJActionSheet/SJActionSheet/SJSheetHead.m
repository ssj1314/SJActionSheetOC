//
//  SJSheetHead.m
//  SJActionSheet
//
//  Created by htf on 2017/11/6.
//  Copyright © 2017年 htf. All rights reserved.
//

#import "SJSheetHead.h"
#import "Header.h"
@implementation SJSheetHead

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.headLabel];
    }
    return self;
}

-(UILabel *)headLabel
{
    if (!_headLabel)
    {
        _headLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-30, kCellH)];
        _headLabel.text = @"标题";
        _headLabel.backgroundColor = [UIColor whiteColor];
        _headLabel.textColor = [UIColor darkGrayColor];
        _headLabel.textAlignment = NSTextAlignmentCenter;
        if (kScreenHeight == 667)
        {
            _headLabel.font = [UIFont systemFontOfSize:20];
        }
        else if (kScreenHeight >667)
        {
            _headLabel.font = [UIFont systemFontOfSize:21];
        }
    }
    
    return _headLabel;
}
@end
