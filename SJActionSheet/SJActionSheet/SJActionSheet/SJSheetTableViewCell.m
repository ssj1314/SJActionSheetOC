//
//  SJSheetTableViewCell.m
//  SJActionSheet
//
//  Created by htf on 2017/11/6.
//  Copyright © 2017年 htf. All rights reserved.
//

#import "SJSheetTableViewCell.h"
#import "Header.h"

@implementation SJSheetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self addSubview:self.myLabel];
    [self addSubview:self.divisionView];
    [self addSubview:self.tableViewDivView];
    
    return self;
}

- (UILabel *)myLabel
{
    if (!_myLabel)
    {
        _myLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, kCellH-1)];
        _myLabel.backgroundColor = [UIColor whiteColor];
        _myLabel.textColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0];//这个可以定义,看需求
        _myLabel.font = [UIFont systemFontOfSize:18];
        //三目运算也可以 kScreenWidth>667?21:(kScreenWidth ==667?20:18)
        
        if (kScreenHeight == 667)
        {
            _myLabel.font = [UIFont systemFontOfSize:20];
        }
        else if (kScreenHeight >667)
        {
            _myLabel.font = [UIFont systemFontOfSize:21];
        }
    }
    
    return _myLabel;
}

-(UIView *)divisionView
{
    if (!_divisionView)
    {
        _divisionView = [[UIView alloc] initWithFrame:CGRectMake(0, kCellH-1, kScreenWidth, 0.5)];
        _divisionView.backgroundColor = [UIColor lightGrayColor];
    }
    
    return _divisionView;
}

-(UIView *)tableViewDivView
{
    if (!_tableViewDivView)
    {
        _tableViewDivView =[[UIView alloc] initWithFrame:CGRectMake(15, kCellH-1, kScreenWidth-30, 0.5)];
        _tableViewDivView.backgroundColor = [UIColor lightGrayColor];
    }
    
    return _tableViewDivView;
}
@end
