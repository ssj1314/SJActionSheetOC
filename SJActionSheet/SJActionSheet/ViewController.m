//
//  ViewController.m
//  SJActionSheet
//
//  Created by htf on 2017/11/6.
//  Copyright © 2017年 htf. All rights reserved.
//

#define kScreenWidth     [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height
#import "ViewController.h"
#import "SJActionSheet.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)  UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *selectSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:0];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    [self loadDataSource];
}

- (void)loadDataSource
{
    self.dataSource = [NSMutableArray new];
    [_dataSource addObject:@"普通模式"];
    [_dataSource addObject:@"变色变字模式"];
    [_dataSource addObject:@"行数超多模式"];
    [_dataSource addObject:@"WeiChat模式"];
    [_dataSource addObject:@"WeiChat多行模式"];
    [_dataSource addObject:@"TableView模式"];
    
    self.selectSource = [NSMutableArray new];
    
    for (int i = 0; i < self.dataSource.count; i++) {
        [_selectSource addObject:@""];
    }
}

#pragma mark - UITableView数据源和代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:20.0];
    cell.textLabel.text = _dataSource[indexPath.row];
    cell.detailTextLabel.text = _selectSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 选中后立即取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.row) {
        case 0:
        {
            SJActionSheet *actionSheet = [[SJActionSheet alloc] initSheetWithTitle:nil style:SJSheetStyleDefault itemTitles:@[@"头等舱",@"商务舱",@"经济舱",@"不限"]];
            __weak typeof(self) weakSelf = self;
            [actionSheet didFinishSelectIndex:^(NSInteger index, NSString *title) {
                NSString *text = [NSString stringWithFormat:@"第%ld行,%@",index, title];
                [weakSelf.selectSource replaceObjectAtIndex:indexPath.row withObject:text];
                [weakSelf.tableView reloadData];
            }];
            
        }
            break;
        case 1:
        {
            SJActionSheet *actionSheet = [[SJActionSheet alloc] initSheetWithTitle:@"选择舱位" style:SJSheetStyleDefault itemTitles:@[@"头等舱",@"商务舱",@"经济舱",@"不限"]];
            actionSheet.titleTextFont = [UIFont systemFontOfSize:15];
            actionSheet.itemTextFont = [UIFont systemFontOfSize:18];
            actionSheet.cancelTextFont = [UIFont systemFontOfSize:16];
            actionSheet.titleTextColor = [UIColor redColor];
            actionSheet.itemTextColor = [UIColor orangeColor];
            actionSheet.cancleTextColor = [UIColor blackColor];
            __weak typeof(self) weakSelf = self;
            [actionSheet didFinishSelectIndex:^(NSInteger index, NSString *title) {
                NSString *text = [NSString stringWithFormat:@"第%ld行,%@",index, title];
                [weakSelf.selectSource replaceObjectAtIndex:indexPath.row withObject:text];
                [weakSelf.tableView reloadData];
            }];
        }
            break;
        case 2:
        {
            SJActionSheet *actionSheet = [[SJActionSheet alloc] initSheetWithTitle:@"席座选择" style:SJSheetStyleDefault itemTitles:@[@"头等舱",@"商务舱",@"经济舱",@"特等座",@"一等座",@"二等座",@"软座",@"硬座",@"头等舱",@"商务舱",@"经济舱",@"特等座",@"一等座",@"二等座",@"软座",@"硬座",@"不限"]];
            __weak typeof(self) weakSelf = self;
            [actionSheet didFinishSelectIndex:^(NSInteger index, NSString *title) {
                NSString *text = [NSString stringWithFormat:@"第%ld行,%@",index, title];
                [weakSelf.selectSource replaceObjectAtIndex:indexPath.row withObject:text];
                [weakSelf.tableView reloadData];
            }];
        }
            break;
        case 3:
        {
            SJActionSheet *actionSheet = [[SJActionSheet alloc] initSheetWithTitle:nil style:SJSheetStyleWeiChat itemTitles:@[@"头等舱",@"商务舱",@"经济舱",@"不限"]];
            __weak typeof(self) weakSelf = self;
            [actionSheet didFinishSelectIndex:^(NSInteger index, NSString *title) {
                NSString *text = [NSString stringWithFormat:@"第%ld行,%@",index, title];
                [weakSelf.selectSource replaceObjectAtIndex:indexPath.row withObject:text];
                [weakSelf.tableView reloadData];
            }];
        }
            break;
        case 4:
        {
            SJActionSheet *actionSheet = [[SJActionSheet alloc] initSheetWithTitle:@"席座选择" style:SJSheetStyleWeiChat itemTitles:@[@"头等舱",@"商务舱",@"经济舱",@"特等座",@"一等座",@"二等座",@"软座",@"硬座",@"头等舱",@"商务舱",@"经济舱",@"特等座",@"一等座",@"二等座",@"软座",@"硬座",@"不限"]];
            actionSheet.cancelTitle = @"取消选择";
            __weak typeof(self) weakSelf = self;
            [actionSheet didFinishSelectIndex:^(NSInteger index, NSString *title) {
                NSString *text = [NSString stringWithFormat:@"第%ld行,%@",index, title];
                [weakSelf.selectSource replaceObjectAtIndex:indexPath.row withObject:text];
                [weakSelf.tableView reloadData];
            }];
        }
            break;
        case 5:
        {
            SJActionSheet *actionSheet = [[SJActionSheet alloc] initSheetWithTitle:@"时间选择" style:SJSheetStyleTable itemTitles:@[@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00",@"23:59"]];
            __weak typeof(self) weakSelf = self;
            [actionSheet didFinishSelectIndex:^(NSInteger index, NSString *title) {
                NSString *text = [NSString stringWithFormat:@"第%ld行,%@",index, title];
                [weakSelf.selectSource replaceObjectAtIndex:indexPath.row withObject:text];
                [weakSelf.tableView reloadData];
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
