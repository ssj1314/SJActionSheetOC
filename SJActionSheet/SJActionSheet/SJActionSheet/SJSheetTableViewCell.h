//
//  SJSheetTableViewCell.h
//  SJActionSheet
//
//  Created by htf on 2017/11/6.
//  Copyright © 2017年 htf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJSheetTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel * myLabel;
@property (nonatomic,strong)UIView * divisionView;//分割线,顶左右的
@property (nonatomic,strong)UIView * tableViewDivView;//距边界15px分割线
@end
