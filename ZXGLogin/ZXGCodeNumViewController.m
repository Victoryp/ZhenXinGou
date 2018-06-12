//
//  ZXGCodeNumViewController.m
//  ZhenXinGou
//
//  Created by Victor on 2017/11/29.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import "ZXGCodeNumViewController.h"
#import "ZXGCodeTableViewCell.h"

static NSString *codeID = @"codeID";
@interface ZXGCodeNumViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *codeTableView;

@property (strong, nonatomic) NSArray *contryArray;
@property (strong, nonatomic) NSArray *codeArray;

@end

@implementation ZXGCodeNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.codeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXGCodeTableViewCell class]) bundle:nil] forCellReuseIdentifier:codeID];
    self.codeTableView.delegate = self;
    self.codeTableView.dataSource = self;

    self.contryArray = @[@"中国",@"美国",@"香港",@"澳门",@"日本",@"台湾",@"韩国",@"新加坡",@"澳大利亚",@"加拿大",@"英国",@"法国",@"德国",@"意大利"];
    self.codeArray = @[@"+86",@"+1",@"+852",@"+853",@"+81",@"+886",@"+82",@"+65",@"+61",@"+1",@"+44",@"+33",@"+49",@"+39"];
}

- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZXGCodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:codeID forIndexPath:indexPath];
    cell.selectionStyle = 0;
    cell.contryName.text = self.contryArray[indexPath.row];
    cell.contryCode.text = self.codeArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delgate respondsToSelector:@selector(getCodeNum:)]) {
        [self.delgate getCodeNum:self.codeArray[indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
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
