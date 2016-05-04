//
//  AlterTitleViewController.m
//  Timer
//
//  Created by 莫大宝 on 16/5/3.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "AlterTitleViewController.h"


@interface AlterTitleViewController ()

@property (nonatomic, strong) UIImageView  *iconImageView;
@property (nonatomic, strong) UITextField *textField;
//@property (nonatomic, strong) pick *<#name#>;

@end

@implementation AlterTitleViewController

// 创建视图
- (void)createView {
    CGFloat margin = 10;
    CGFloat headViewHeight = 40;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavigationHeight + 10, kScreenWidth, headViewHeight)];
    headView.backgroundColor = [UIColor whiteColor];
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    self.iconImageView.centerY = headViewHeight * .5;
    self.iconImageView.x = margin;
    self.iconImageView.image = [UIImage imageNamed:self.detailItemModel.titleicon];
    self.iconImageView.layer.cornerRadius = self.iconImageView.width * 0.25;
    [self assignmentWithImageView:self.iconImageView color:self.detailItemModel.titlecolor];// 设置背景色
    [headView addSubview:self.iconImageView];
    
    CGFloat textFieldHeight = self.iconImageView.height;
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(margin * 1.5 + self.iconImageView.width, headViewHeight * 0.5 - textFieldHeight * 0.5, kScreenWidth - margin * 2 - margin * .5 - self.iconImageView.width, textFieldHeight)];
    //    self.textField.centerY = headViewHeight * 0.5;
    //    self.textField.width = kScreenWidth - margin * 2 - margin * .5;
    //    self.textField.height = headViewHeight * 2 / 3.0;
    //    self.textField.x = margin * 1.5 + self.iconImageView.width;
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.text = self.detailItemModel.title;
    self.textField.font = [UIFont systemFontOfSize:14];
    [headView addSubview:self.textField];
    
    [self.view addSubview:headView];
    
    CGFloat marginTop = 20;
    UILabel *label = [[UILabel alloc] init];
    label.text = @"修改颜色和图标";
    label.font = [UIFont systemFontOfSize:12];
    label.x = margin;
    label.width = [UILabel getWidthWithTitle:label.text font:label.font];
    label.y = headView.y + headViewHeight + marginTop;
    label.height = [UILabel getHeightByWidth:label.width title:label.text font:label.font];
    [self.view addSubview:label];
}

// 创建选择视图
- (void)createPickerView {
    
}

// 创建按钮
- (void)createBtn {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
}

- (void)back {
    self.passValue(self.textField.text);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00];
    self.navigationItem.title = @"修改计时器";
    
    [self createView];// 创建视图
    [self createPickerView];// 创建选择视图
    [self createBtn];// 创建按钮
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
