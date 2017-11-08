//
//  SJSheetFoot.m
//  SJActionSheet
//
//  Created by htf on 2017/11/6.
//  Copyright © 2017年 htf. All rights reserved.
//

#import "SJSheetFoot.h"
#import "Header.h"

@implementation SJSheetFoot

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.footButton];
    }
    return self;
}

-(UIButton *)footButton
{
    if (!_footButton)
    {
        _footButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, kCellH)];
        [_footButton setTitle:@"取消" forState:0];
        [_footButton setTitleColor:[UIColor blueColor] forState:0];//按钮文字颜色,这个看需求
        _footButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _footButton.titleLabel.font = [UIFont systemFontOfSize:18];
        if (kScreenHeight == 667)
        {
            _footButton.titleLabel.font = [UIFont systemFontOfSize:20];
        }
        else if (kScreenHeight >667)
        {
            _footButton.titleLabel.font = [UIFont systemFontOfSize:21];
        }
        
    }
    return _footButton;
}
@end
