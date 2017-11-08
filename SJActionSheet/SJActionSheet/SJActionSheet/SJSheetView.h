//
//  SJSheetView.h
//  SJActionSheet
//
//  Created by htf on 2017/11/6.
//  Copyright © 2017年 htf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,NSCelltextStyle)
{
    NSTextStyleCenter = 0, //cell 文字默认样式居中
    NSTextStyleLeft,       //cell 文字样式居左
    NSTextStyleRight,      //cell 文字样式居右
};

@protocol SJSheetViewDelegate <NSObject>
- (void)sheetViewDidSelectIndex:(NSInteger)index selectTitle:(NSString *)title;
@end

@interface SJSheetView : UIView

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,weak)id<SJSheetViewDelegate> delegate;
@property (nonatomic,strong)UIColor *cellTextColor;
@property (nonatomic,strong)UIFont *cellTextFont;
@property (nonatomic,assign)CGFloat cellHeight;
@property (nonatomic,assign)BOOL showTableDivLine;//显示分割线否
@property (nonatomic,assign)NSCelltextStyle cellTextStyle;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)UIView *tableDivLine;//表格和标题的分割线
@end
