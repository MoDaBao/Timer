//
//  TimerItemManagerViewController.m
//  Timer
//
//  Created by 莫大宝 on 16/4/25.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "TimerItemManagerViewController.h"
#import "TimerDetailItemOtherCell.h"
#import "TimerDetailItemStepCell.h"
#import "AlterTitleViewController.h"
@interface TimerItemManagerViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *itemArray;
//@property (nonatomic, strong) NSMutableArray *stepArray;
@property (nonatomic, strong) TimerDetailItemModel *orginModel;// 如果是新建显示默认原始数据
//@property (nonatomic, strong) TimerDetailItemModel *selectModel;// 数据库中某一项
@property (nonatomic, strong) TimerDetailItemModel *oldModel;



@end

@implementation TimerItemManagerViewController


#pragma mark -----lazyload-----

- (TimerDetailItemModel *)selectModel {
    if (!_selectModel) {
        TimerDetailItemDB *db = [[TimerDetailItemDB alloc] init];
        [db createTable];
        _selectModel = [db selectDataWithTitle:self.headTitle];
//        NSString *documentPatn = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//        NSLog(@"%@",documentPatn);
    }
    return _selectModel;
}

- (TimerDetailItemModel *)orginModel {
    if (!_orginModel) {
        self.orginModel = [[TimerDetailItemModel alloc] init];
        _orginModel.title = @"新计时器";
        _orginModel.titlecolor = @"kBlue";
        _orginModel.titleicon = @"runWhite";
        _orginModel.step = @"kPink&新建步骤&00:20/kBlue&新建步骤&00:20";
        _orginModel.countdown = @15;
        _orginModel.loopcount = @1;
    }
    return _orginModel;
}

- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        TimerDetailItemDB *db = [[TimerDetailItemDB alloc] init];
        [db createTable];
        if (_isNew) {
            self.itemArray = [NSMutableArray array];
            self.itemArray = [[self.orginModel.step componentsSeparatedByString:@"/"] mutableCopy];
        } else {
//            TimerDetailItemDB *db = [[TimerDetailItemDB alloc] init];
//            [db createTable];
//            self.selectModel = [db selectDataWithTitle:self.title];
            self.itemArray = [NSMutableArray array];
            self.itemArray = [[self.selectModel.step componentsSeparatedByString:@"/"] mutableCopy];
            
        }
    }
    return _itemArray;
}


#pragma mark -----加载视图-----

- (void)createTableView {
//    if (_isNew) {
//        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
//    } else {
//        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
//    }
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    // 保存按钮
    UIButton *managerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    managerBtn.frame = CGRectMake(0, 0, 40, 20);
    [managerBtn setTitle:@"保存" forState:UIControlStateNormal];
    [managerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    managerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [managerBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    // 返回baritem
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    // 管理baritem
    UIBarButtonItem *managerItem = [[UIBarButtonItem alloc] initWithCustomView:managerBtn];
    self.navigationItem.rightBarButtonItem = managerItem;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 20, 20)];
    imageView.layer.cornerRadius = 5;
    [view addSubview:imageView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 50, 30)];
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    if (_isNew) {
        imageView.image = [UIImage imageNamed:self.orginModel.titleicon];
        label.text = self.orginModel.title;
        [self assignmentWithImageView:imageView color:self.orginModel.titlecolor];
    } else {
        imageView.image = [UIImage imageNamed:self.selectModel.titleicon];
        label.text = self.selectModel.title;
        [self assignmentWithImageView:imageView color:self.selectModel.titlecolor];
    }
    label.width = [UILabel getWidthWithTitle:label.text font:label.font];
    view.width = label.width + imageView.width;
    
    self.navigationItem.titleView = view;
    
    [self createTableView];
}


#pragma mark -----按钮方法-----

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save {
    NSLog(@"save");
    TimerDetailItemDB *db = [[TimerDetailItemDB alloc] init];
    if (_isNew) {
        [db insertTimerDetailItemModel:self.orginModel];
        [self.navigationController popViewControllerAnimated:YES];
     } else {
         if (self.oldModel) {
             [db updateWithTitle:self.oldModel.title model:self.selectModel];
//             NSLog(@"更新");
         }
         
     }
    
    
}

#pragma mark -----表视图代理-----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count + 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"reuse";
    if (indexPath.row > 1 && indexPath.row < self.itemArray.count + 2) {// 步骤
        TimerDetailItemStepCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TimerDetailItemStepCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.icon.layer.cornerRadius = 10;
            
        }
        NSString *string = self.itemArray[indexPath.row - 2];// 获取步骤字符串
        NSArray *array = [string componentsSeparatedByString:@"&"];// 通过&符号分割字符串
        [self assignmentWithImageView:cell.icon color:[array firstObject]];// 设置步骤颜色
        cell.stepName.text = array[1];// 设置步骤名称
        cell.time.text = [array lastObject];
        return cell;
        
    } else {// 标题、倒计时、几轮
        TimerDetailItemOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TimerDetailItemOtherCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.icon.layer.cornerRadius = 10;
        }
        if (_isNew) {
            [cell setDataWithModel:self.orginModel indexPath:indexPath];
            
        } else {
            [cell setDataWithModel:self.selectModel indexPath:indexPath];
        }
        return cell;
    }
    
    
}

// 给颜色赋值
- (void)assignmentWithImageView:(UIImageView *)imageView color:(NSString *)color {
    if ([color isEqualToString:@"kPink"]) {
        imageView.backgroundColor = kPink;
    } else if ([color isEqualToString:@"kGray"]) {
        imageView.backgroundColor = kGray;
    } else if ([color isEqualToString:@"kGreen"]) {
        imageView.backgroundColor = kGreen;
    } else if ([color isEqualToString:@"kBlue"]) {
        imageView.backgroundColor = kBlue;
    }

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 1 && indexPath.row < self.itemArray.count + 2) {
        return YES;
    } else {
        return NO;
    }
}

//  左滑进入编辑模式
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 表视图开始更新
    [tableView beginUpdates];
    // 删除单元格
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    NSString *string = [self.itemArray componentsJoinedByString:@"/"];
    // 修改模型的值
    if (_isNew) {
        self.orginModel.step = string;
    } else {
        self.selectModel.step = string;
    }
    // 删除数组中与该单元格绑定的数据,此步骤应该在最后一步做
    [self.itemArray removeObjectAtIndex:indexPath.row - 2];
    // 表视图结束更新
    [tableView endUpdates];
}

//  修改左滑出现的delete按钮的文本
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        AlterTitleViewController *alterTitleVC = [[AlterTitleViewController alloc] init];
        if (_isNew) {
            alterTitleVC.detailItemModel = self.orginModel;
            alterTitleVC.passValue = ^(NSString *title) {
                self.orginModel.title = title;
                [self.tableView reloadData];
            };
        } else {
            alterTitleVC.detailItemModel = self.selectModel;
            alterTitleVC.passValue = ^(NSString *title) {
                if (!self.oldModel) {
                    self.oldModel = [[TimerDetailItemModel alloc] init];
                }
                self.oldModel.title = self.selectModel.title;
                self.selectModel.title = title;
                [self.tableView reloadData];
            };
        }
        [self.navigationController pushViewController:alterTitleVC animated:YES];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
