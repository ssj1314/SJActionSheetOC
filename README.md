# SJActionSheetOC
iOS-一个自定义封装的 ActionSheet, 传入一组数组即可.集成简单.
>iOS 本身的 ActionSheet 比较单一,很多时候满足不了需求,所以很多封装就出现了,百家争鸣,各有一长,没有最好,只有更好.给大家安利一个比较实用的项目https://github.com/ssj1314/SJActionSheetOC,
只需要传入一组数组即可实现.显示风格可高度自定义,可满足特定情况下的需求.

![SJActionSheet.gif](http://upload-images.jianshu.io/upload_images/1761100-9a463657bc8621e3.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 1.环境要求
- iOS 7.0+
- Xcode 7.0+
- Objective-C 

##### 2.介绍
- 代理回调
- 文字颜色可自定义
- 初始化简单
- 集成方便
-不支持横屏-转屏

##### 3.使用方法
1.导入头文件,`#import "SJActionSheet.h"`
2.初始化--一行代码搞定,传入一个数组即可,可以传入标题.回调的 block 包含选中的 index 和 title.
```
        SJActionSheet *actionSheet = [[SJActionSheet alloc] initSheetWithTitle:nil style:SJSheetStyleDefault itemTitles:@[@"头等舱",@"商务舱",@"经济舱",@"不限"]];
            __weak typeof(self) weakSelf = self;
            [actionSheet didFinishSelectIndex:^(NSInteger index, NSString *title) {
                NSString *text = [NSString stringWithFormat:@"第%ld行,%@",index, title];
                [weakSelf.selectSource replaceObjectAtIndex:indexPath.row withObject:text];
                [weakSelf.tableView reloadData];
            }];
```
##### 4.一共三种样式,默认类似系统风格,微信风格,表格风格
```
typedef NS_ENUM(NSInteger, SJSheetStyle)
{
    /** 默认的样式*/
    SJSheetStyleDefault = 0,
    /** 微博,微信样式*/
    SJSheetStyleWeiChat,
    /** tableView 样式 (无取消按钮)*/
    SJSheetStyleTable,
};
```
每种风格都能自定义样式,
```
//标题颜色,默认是 darkGaryColor
@property (nonatomic,strong)UIColor *titleTextColor;
//item 字体颜色,默认是 blueColor
@property (nonatomic,strong)UIColor *itemTextColor;
//取消字体颜色,默认是 blueColor
@property (nonatomic,strong)UIColor *cancleTextColor;
//标题文字字体
@property (nonatomic,strong)UIFont *titleTextFont;
//item 文字字体
@property (nonatomic,strong)UIFont *itemTextFont;
//取消按钮字体
@property (nonatomic,strong)UIFont *cancelTextFont;
//取消按钮文字设置,默认是"取消"
@property (nonatomic,copy)NSString *cancelTitle;
//是否统一处理取消按钮事件
@property (nonatomic,assign)BOOL isUnifyCancelAction;
```
##### 5.代理方法- 一个初始化,一个代理回调
```
//初始化方法, title不传则不显示, tableView 当 item 显示不完的时候可以滑动, style 默认是 UIActionSheet 样式
- (id)initSheetWithTitle:(NSString *)title
                   style:(SJSheetStyle)style
              itemTitles:(NSArray *)itemTitles;

//回调 block 中包含选中的 index 和 title -- 也可实现代理方法获取选中的数据
- (void)didFinishSelectIndex:(SelectIndexBlock)block;
```
##### 6.根据需求可自己改变
改变可在-- SJActionSheet.m 中进行,根据项目需求,进行定制.

###没错,就这么简单,  简书 地址 http://www.jianshu.com/p/3a41a70f0fba
,请给出意见,谢谢啦
