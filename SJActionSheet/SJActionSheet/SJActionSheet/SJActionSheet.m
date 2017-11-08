//
//  HMActionSheet.m
//  SJActionSheet
//
//  Created by LSJ on 16/3/10.
//  Copyright © 2016年 LSJ. All rights reserved.

#import "SJActionSheet.h"
#import "SJSheetView.h"
#import "SJSheetHead.h"
#import "SJSheetFoot.h"
#import "Header.h"

@interface SJActionSheet()<SJSheetViewDelegate>

@property (strong, nonatomic) UIButton *bgButton;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) SJSheetView *sheetView;
@property (strong, nonatomic) SJSheetHead *titleView;
@property (strong, nonatomic) SJSheetFoot *footView;
@property (strong, nonatomic) UIView *marginView;
@property (assign, nonatomic) CGFloat contentVH;
@property (assign, nonatomic) CGFloat contentViewY;
@property (assign, nonatomic) CGFloat footViewY;

@property (strong, nonatomic) NSIndexPath *selectIndex;
@property (strong, nonatomic) SelectIndexBlock selectBlock;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (assign, nonatomic) SJSheetStyle sheetStyle;
@end

@implementation SJActionSheet

- (id)initSheetWithTitle:(NSString *)title
                   style:(SJSheetStyle)style
              itemTitles:(NSMutableArray *)itemTitles
{
    if (self = [super initWithFrame:[[UIScreen mainScreen] bounds]]) {
        
        self.sheetStyle = style;
        self.dataSource = itemTitles;
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        //半透明背景按钮
        self.bgButton = [[UIButton alloc] init];
        [self addSubview:self.bgButton];
        self.bgButton.backgroundColor = [UIColor blackColor];
        self.bgButton.alpha = 0.35;
        //title和sheetView的容器View
        self.contentView = [[UIView alloc] init];
        [self addSubview:self.contentView];
        //取消按钮View
        self.footView = [[SJSheetFoot alloc] init];
        [self addSubview:self.footView];
        //选择TableView
        self.sheetView = [[SJSheetView alloc] init];
        self.sheetView.cellHeight = kCellH;
        self.sheetView.delegate = self;
        self.sheetView.dataSource = self.dataSource;
        [self.contentView addSubview:self.sheetView];
        
        //选择样式
        if (style == SJSheetStyleDefault) {
            self = [self upDefaultStyeWithItems:itemTitles title:title selfView:self];
            [self pushDefaultStyeSheetView];
        }
        else if (style == SJSheetStyleWeiChat) {
            self = [self upWeiChatStyeWithItems:itemTitles title:title selfView:self];
            [self pushWeiChatStyeSheetView];
        }
        else if (style == SJSheetStyleTable) {
            self = [self upTableStyeWithItems:itemTitles title:title selfView:self];
            [self pushTableStyeSheetView];
        }
    }
    return self;
}

///初始化默认样式
- (id)upDefaultStyeWithItems:(NSMutableArray *)itemTitles title:(NSString *)title selfView:(SJActionSheet *)selfView
{
    //半透明背景按钮
    [selfView.bgButton addTarget:self action:@selector(dismissDefaulfSheetView) forControlEvents:UIControlEventTouchUpInside];
    selfView.bgButton.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    //标题
    BOOL isTitle = NO;
    if (title.length > 0) {
        selfView.titleView = [[SJSheetHead alloc] init];
        selfView.titleView.headLabel.text = title;
        isTitle = YES;
        [selfView.contentView addSubview:selfView.titleView];
    }
    //布局子控件
    int cellCount = (int)itemTitles.count;
    selfView.contentVH = kCellH * (cellCount + isTitle);
    CGFloat maxH = kScreenHeight - 50 - (kCellH + kMargin * 2);
    if (selfView.contentVH > maxH) {
        selfView.contentVH = maxH;
        selfView.sheetView.tableView.scrollEnabled = YES;
    } else {
        selfView.sheetView.tableView.scrollEnabled = NO;
    }
    
    selfView.footViewY = kScreenHeight - kCellH - kMargin;
    selfView.footView.frame = CGRectMake(kMargin, kScreenHeight + selfView.contentVH + kMargin, kScreenWW, kCellH);
    selfView.contentViewY = kScreenHeight - CGRectGetHeight(selfView.footView.frame) - selfView.contentVH - kMargin * 2;
    selfView.contentView.frame = CGRectMake(kMargin, kScreenHeight, kScreenWW, selfView.contentVH);
    
    CGFloat sheetY = 0;
    CGFloat sheetH = CGRectGetHeight(selfView.contentView.frame);
    if (isTitle) {
        selfView.titleView.frame = CGRectMake(0, 0, kScreenWW, kCellH);
        sheetY = CGRectGetHeight(selfView.titleView.frame);
        sheetH = CGRectGetHeight(selfView.contentView.frame) - CGRectGetHeight(selfView.titleView.frame);
    }
    selfView.sheetView.frame = CGRectMake(0, sheetY, kScreenWW, sheetH);
    selfView.sheetView.tableView.frame = CGRectMake(0, 1, kScreenWidth, sheetH);
    //设置圆角
    selfView.contentView.layer.cornerRadius = kCornerRadius;
    selfView.contentView.layer.masksToBounds = YES;
    selfView.footView.layer.cornerRadius = kCornerRadius;
    selfView.footView.layer.masksToBounds = YES;
    [selfView.footView.footButton addTarget:selfView action:@selector(dismissDefaulfSheetView) forControlEvents:UIControlEventTouchUpInside];
    return selfView;
}

///初始化微信样式
- (id)upWeiChatStyeWithItems:(NSMutableArray *)itemTitles title:(NSString *)title selfView:(SJActionSheet *)selfView
{
    [selfView.bgButton addTarget:selfView action:@selector(dismissWeiChatStyeSheetView) forControlEvents:UIControlEventTouchUpInside];
    selfView.bgButton.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [selfView.footView.footButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    selfView.footView.footButton.titleLabel.font = [UIFont systemFontOfSize:18];
    if ([[UIScreen mainScreen] bounds].size.height == 667) {
        selfView.footView.footButton.titleLabel.font = [UIFont systemFontOfSize:20];
    }
    else if ([[UIScreen mainScreen] bounds].size.height > 667) {
        selfView.footView.footButton.titleLabel.font = [UIFont systemFontOfSize:21];
    }
    
    //中间空隙
    selfView.marginView = [[UIView alloc] init];
    selfView.marginView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    selfView.marginView.alpha = 0.0;
    [selfView addSubview:selfView.marginView];
    
    //标题
    BOOL isTitle = NO;
    if (title.length > 0) {
        //[[SJSheetHead alloc] init]
        //[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SJSheetHead class]) owner:selfView options:nil].lastObject
        selfView.titleView = [[SJSheetHead alloc] init];
        selfView.titleView.headLabel.text = title;
        isTitle = YES;
        [selfView.contentView addSubview:selfView.titleView];
    }
    selfView.sheetView.cellTextColor = [UIColor darkGrayColor];
    
    //布局子控件
    int cellCount = (int)itemTitles.count;
    selfView.contentVH = kCellH * (cellCount + isTitle);
    CGFloat maxH = kScreenHeight - 50 - (kCellH + kMargin);
    if (selfView.contentVH > maxH) {
        selfView.contentVH = maxH;
        selfView.sheetView.tableView.scrollEnabled = YES;
    } else {
        selfView.sheetView.tableView.scrollEnabled = NO;
    }
    
    selfView.footViewY = kScreenHeight - kCellH;
    selfView.footView.frame = CGRectMake(0, selfView.footViewY + selfView.contentVH, kScreenWidth, kCellH);
    
    selfView.contentViewY = kScreenHeight - CGRectGetHeight(selfView.footView.frame) - selfView.contentVH - kMargin;
    selfView.contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, selfView.contentVH);
    
    CGFloat sheetY = 0;
    CGFloat sheetH = CGRectGetHeight(selfView.contentView.frame);
    if (isTitle) {
        selfView.titleView.frame = CGRectMake(0, 0, kScreenWidth, kCellH);
        sheetY = CGRectGetHeight(selfView.titleView.frame);
        sheetH = CGRectGetHeight(selfView.contentView.frame) - CGRectGetHeight(selfView.titleView.frame);
    }
    selfView.sheetView.frame = CGRectMake(0, sheetY, kScreenWidth, sheetH);
    selfView.sheetView.tableView.frame = CGRectMake(0, 1, kScreenWidth, sheetH);
    selfView.marginView.frame = CGRectMake(0, kScreenHeight + sheetH, kScreenWidth, kMargin);
    
    [selfView.footView.footButton addTarget:self action:@selector(dismissWeiChatStyeSheetView) forControlEvents:UIControlEventTouchUpInside];
    return selfView;
}

///初始化TableView样式
- (id)upTableStyeWithItems:(NSMutableArray *)itemTitles title:(NSString *)title selfView:(SJActionSheet *)selfView
{
    if (selfView.footView) {
        [selfView.footView removeFromSuperview];
    }
    [selfView.bgButton addTarget:selfView action:@selector(dismissTableStyeSheetView) forControlEvents:UIControlEventTouchUpInside];
    selfView.bgButton.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    //标题
    BOOL isTitle = NO;
    if (title.length > 0) {
        selfView.titleView = [[SJSheetHead alloc] init];
        selfView.titleView.headLabel.text = title;
        selfView.titleView.headLabel.textAlignment = NSTextAlignmentLeft;
        isTitle = YES;
        [selfView.contentView addSubview:selfView.titleView];
    }
    selfView.sheetView.cellTextColor = [UIColor darkGrayColor];
    selfView.sheetView.cellTextStyle = NSTextStyleLeft;
    selfView.sheetView.tableView.scrollEnabled = YES;
    selfView.sheetView.showTableDivLine = YES;
    
    //布局子控件
    int cellCount = (int)itemTitles.count;
    selfView.contentVH = kCellH * (cellCount + isTitle);
    CGFloat maxH = kScreenHeight - 100;
    if (selfView.contentVH > maxH) {
        selfView.contentVH = maxH;
    }
    
    selfView.contentViewY = kScreenHeight - selfView.contentVH;
    selfView.contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, selfView.contentVH);
    
    CGFloat sheetY = 0;
    CGFloat sheetH = CGRectGetHeight(selfView.contentView.frame);
    if (isTitle) {
        selfView.titleView.frame = CGRectMake(0, 0, kScreenWidth, kCellH);
        sheetY = CGRectGetHeight(selfView.titleView.frame);
        sheetH = CGRectGetHeight(selfView.contentView.frame) - CGRectGetHeight(selfView.titleView.frame);
    }
    selfView.sheetView.frame = CGRectMake(0, sheetY, kScreenWidth, sheetH);
    selfView.sheetView.tableView.frame = CGRectMake(0, 1, kScreenWidth, sheetH);
    return selfView;
}

//显示默认样式
- (void)pushDefaultStyeSheetView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kPushTime animations:^{
        weakSelf.contentView.frame = CGRectMake(kMargin, weakSelf.contentViewY, kScreenWW, weakSelf.contentVH);
        weakSelf.footView.frame = CGRectMake(kMargin, weakSelf.footViewY, kScreenWW, kCellH);
        weakSelf.bgButton.alpha = 0.35;
    }];
}

//显示像微信的样式
- (void)pushWeiChatStyeSheetView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kPushTime animations:^{
        weakSelf.contentView.frame = CGRectMake(0, weakSelf.contentViewY, kScreenWidth, weakSelf.contentVH);
        weakSelf.footView.frame = CGRectMake(0, weakSelf.footViewY, kScreenWidth, kCellH);
        weakSelf.marginView.frame = CGRectMake(0, weakSelf.footViewY - kMargin, kScreenWidth, kMargin);
        weakSelf.bgButton.alpha = 0.35;
        weakSelf.marginView.alpha = 1.0;
    }];
}

//显示TableView的样式
- (void)pushTableStyeSheetView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kPushTime animations:^{
        weakSelf.contentView.frame = CGRectMake(0, weakSelf.contentViewY, kScreenWidth, weakSelf.contentVH);
        weakSelf.bgButton.alpha = 0.35;
    }];
}

//显示
- (void)show
{
    if (_sheetStyle == SJSheetStyleDefault) {
        [self pushDefaultStyeSheetView];
    }
    else if (_sheetStyle == SJSheetStyleWeiChat) {
        [self pushWeiChatStyeSheetView];
    }
    else if (_sheetStyle == SJSheetStyleTable) {
        [self pushTableStyeSheetView];
    }
}


//消失默认样式
- (void)dismissDefaulfSheetView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kDismissTime animations:^{
        weakSelf.contentView.frame = CGRectMake(kMargin, kScreenHeight, kScreenWW, weakSelf.contentVH);
        weakSelf.footView.frame = CGRectMake(kMargin, kScreenHeight + weakSelf.contentVH, kScreenWW, kCellH);
        weakSelf.bgButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakSelf.contentView removeFromSuperview];
        [weakSelf.footView removeFromSuperview];
        [weakSelf.bgButton removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}

//消失微信样式
- (void)dismissWeiChatStyeSheetView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kDismissTime animations:^{
        weakSelf.contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, weakSelf.contentVH);
        weakSelf.footView.frame = CGRectMake(0, weakSelf.footViewY + weakSelf.contentVH, kScreenWidth, kCellH);
        weakSelf.marginView.frame = CGRectMake(0, kScreenHeight + CGRectGetHeight(weakSelf.contentView.frame) + CGRectGetHeight(weakSelf.titleView.frame), kScreenWidth, kMargin);
        weakSelf.bgButton.alpha = 0.0;
        weakSelf.marginView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakSelf.contentView removeFromSuperview];
        [weakSelf.footView removeFromSuperview];
        [weakSelf.marginView removeFromSuperview];
        [weakSelf.bgButton removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}

//消失TableView样式
- (void)dismissTableStyeSheetView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kDismissTime animations:^{
        weakSelf.contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, weakSelf.contentVH);
        weakSelf.bgButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakSelf.contentView removeFromSuperview];
        [weakSelf.bgButton removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}

- (void)setTitleTextFont:(UIFont *)titleTextFont
{
    _titleView.headLabel.font = titleTextFont;
}

- (void)setTitleTextColor:(UIColor *)titleTextColor
{
    if (titleTextColor) {
        _titleView.headLabel.textColor = titleTextColor;
    }
}

- (void)setItemTextFont:(UIFont *)itemTextFont
{
    if (itemTextFont) {
        _sheetView.cellTextFont = itemTextFont;
    }
}

- (void)setItemTextColor:(UIColor *)itemTextColor
{
    if (itemTextColor) {
        _sheetView.cellTextColor = itemTextColor;
    }
}

- (void)setCancleTextFont:(UIFont *)cancleTextFont
{
    if (cancleTextFont) {
        [_footView.footButton.titleLabel setFont:cancleTextFont];
    }
}

- (void)setCancleTextColor:(UIColor *)cancleTextColor
{
    if (cancleTextColor) {
        [_footView.footButton setTitleColor:cancleTextColor forState:UIControlStateNormal];
    }
}

- (void)setCancleTitle:(NSString *)cancleTitle
{
    if (cancleTitle) {
        [_footView.footButton setTitle:cancleTitle forState:UIControlStateNormal];
    }
}

- (void)setIsUnifyCancleAction:(BOOL)isUnifyCancleAction
{
    if (isUnifyCancleAction) {
        [self.footView.footButton addTarget:self action:@selector(footButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)didFinishSelectIndex:(SelectIndexBlock)block
{
    _selectBlock = block;
}

//把取消按钮的点击加入TableView的事件中统一处理
- (void)footButtonAction:(id)sender
{
    NSInteger indexsCount = (NSInteger)self.dataSource.count;
    if (indexsCount) {
        [self sheetViewDidSelectIndex:indexsCount selectTitle:_footView.footButton.titleLabel.text];
    }
}

//点击了TableView的哪行
- (void)sheetViewDidSelectIndex:(NSInteger)Index selectTitle:(NSString *)title
{
    if (_selectBlock) {
        _selectBlock(Index,title);
    }
    
    if ([self.delegate respondsToSelector:@selector(sheetViewDidSelectIndex:title:)]) {
        [self.delegate sheetViewDidSelectIndex:Index title:title];
    }
    
    if ([self.delegate respondsToSelector:@selector(sheetViewDidSelectIndex:title:sender:)]) {
        [self.delegate sheetViewDidSelectIndex:Index title:title sender:self];
    }
    if (_sheetStyle == SJSheetStyleDefault) {
        [self dismissDefaulfSheetView];
    }
    else if (_sheetStyle == SJSheetStyleWeiChat) {
        [self dismissWeiChatStyeSheetView];
    }
    else if (_sheetStyle == SJSheetStyleTable) {
        [self dismissTableStyeSheetView];
    }
}


- (SJSheetFoot *)footView
{
    
    if (!_footView) {
        _footView = [[SJSheetFoot alloc] init];
        
    }
    return _footView;
    
}
- (SJSheetHead *)titleView
{
    if (!_titleView) {
        _titleView = [[SJSheetHead alloc] init];
    }
    return _titleView;
    
}

@end
//ssj

