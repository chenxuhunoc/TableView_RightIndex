//
//  ViewController.m
//  IndexDemo
//
//  Created by 陈绪混 on 16/9/15.
//  Copyright © 2016年 陈绪混. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
// 列表
@property(nonatomic, strong)UITableView *cityTableView;
// 地区的第一个key
@property(nonatomic, strong)NSMutableArray *allKeyArr;
// 装置所有城市信息Dic
@property(nonatomic, strong)NSDictionary *citicyDic;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 获取数据
    [self getPlistData];
    
    // 创建表格
    [self creatTableView];
}

- (void)getPlistData
{
    // 获取文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"citydict" ofType:@"plist"];
    
    // 获取所有城市的首字母key
    self.citicyDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    NSLog(@"%@",self.citicyDic);
    
    // 对所有的城市的字母进行排序并储蓄到数组中 A--Z
    [self.allKeyArr addObjectsFromArray:[[self.citicyDic allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    
   // NSLog(@"sort Kwy = %@",self.allKeyArr);
    
}

- (void)creatTableView
{
    [self.view addSubview:self.cityTableView];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.allKeyArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.citicyDic[self.allKeyArr[section]];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identfier = @"cityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identfier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    NSArray *arr = self.citicyDic[self.allKeyArr[indexPath.section]];
    cell.textLabel.text = arr[indexPath.row];
    return cell;
}

// 分区头标题
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.allKeyArr[section];
}

// 分区头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

// 右侧分区的标题
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.allKeyArr;
}

// 选中索引回调方法
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hub.mode = MBProgressHUDModeCustomView;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{

        hub.label.text = title;
        dispatch_async(dispatch_get_main_queue(), ^{
            [hub hideAnimated:YES afterDelay:.5];
        });
    });
    return index;
}

- (UITableView *)cityTableView
{
    if (!_cityTableView)
    {
        self.cityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        self.cityTableView.delegate = self;
        self.cityTableView.dataSource = self;
    }
    return _cityTableView;
}

- (NSMutableArray *)allKeyArr
{
    if (!_allKeyArr)
    {
        self.allKeyArr = [NSMutableArray array];
    }
    return _allKeyArr;
}

- (NSDictionary *)citicyDic
{
    if (!_citicyDic)
    {
        self.citicyDic = [NSDictionary dictionary];
    }
    return _citicyDic;
}

@end
