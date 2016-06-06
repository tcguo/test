//
//  NRPersonHeightSettingController.m
//  Nourish
//
//  Created by gtc on 15/3/24.
//  Copyright (c) 2015年 ___BaiduMGame___. All rights reserved.
//

#import "NRPersonHeightSettingController.h"
#import "TRSDialScrollView.h"

@interface NRPersonHeightSettingController ()<UIScrollViewDelegate>
{
    UIImageView *_avatarImgV;
}

@property (strong, nonatomic) TRSDialScrollView *dialView;
@property (strong, nonatomic) UILabel *currentWeightLabel;
@property (strong, nonatomic) UILabel *unitLabel;

@property (assign, nonatomic) BOOL isFromAgeSettingsVC;
@property (strong, nonatomic) NRUserInfoModel *userInfo;

@end

@implementation NRPersonHeightSettingController

#pragma mark  - view cycle

- (id)initWithUserInfo:(NRUserInfoModel *)userInfo isFromAgeVC:(BOOL)fromAgeVC
{
    self = [super init];
    if (self) {
        _userInfo = userInfo;
        _isFromAgeSettingsVC = fromAgeVC;
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoadWithBarStyle:NRBarStyleLeftBack];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"身高设置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.isFromAgeSettingsVC) {
        [self setupBarButton];
    }
    
    _avatarImgV= [[UIImageView alloc] init];
    _avatarImgV.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_avatarImgV];
    [_avatarImgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.top.equalTo(@30);
        make.height.equalTo(@205);
        make.width.equalTo(@138);
    }];
    
    // 当前值
    self.currentWeightLabel = [UILabel new];
    [self.view addSubview:self.currentWeightLabel];
    self.currentWeightLabel.text = [NSString stringWithFormat:@"%li", (long)_dialView.currentValue];
    self.currentWeightLabel.textColor = RgbHex2UIColor(0xff, 0x6c, 0x00);
    self.currentWeightLabel.font = [UIFont fontWithName:@"Avenir" size:28];
    [self.currentWeightLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.top.equalTo(_avatarImgV.mas_bottom).offset(@20);
        make.height.equalTo(@28);
    }];
    
    //    self.dialView.transform = CGAffineTransformMakeRotation(-M_PI_2);//旋转90度
    
    self.unitLabel = [UILabel new];
    [self.view addSubview:self.unitLabel];
    self.unitLabel.textColor = ColorBaseFont;
    self.unitLabel.text = @"cm";
    self.unitLabel.font = [UIFont fontWithName:@"Avenir" size:14];
    [self.unitLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentWeightLabel.mas_right).offset(5);
        //        make.top.equalTo(@30);
        make.height.equalTo(@15);
        make.bottom.equalTo(self.currentWeightLabel.mas_bottom);
    }];
    
    // 标尺
    CGFloat yDial = self.currentWeightLabel.frame.origin.y + self.currentWeightLabel.bounds.size.height + 30;
    self.dialView = [[TRSDialScrollView alloc] initWithFrame:CGRectMake(20, yDial, self.view.bounds.size.width-40, 100)];
    
    [[TRSDialScrollView appearance] setMinorTicksPerMajorTick:10];
    [[TRSDialScrollView appearance] setMinorTickDistance:16];
    [[TRSDialScrollView appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"setting-dialBackground"]]];
    
    //    [[TRSDialScrollView appearance] setBackgroundColor:[UIColor whiteColor]];
    //    [[TRSDialScrollView appearance] setOverlayColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DialShadding"]]];
    
    [[TRSDialScrollView appearance] setLabelStrokeColor:[UIColor colorWithRed:0.400 green:0.525 blue:0.643 alpha:1.000]];
    [[TRSDialScrollView appearance] setLabelStrokeWidth:0.1f];
    [[TRSDialScrollView appearance] setLabelFillColor:[UIColor colorWithRed:0.098 green:0.220 blue:0.396 alpha:1.000]];
    
    [[TRSDialScrollView appearance] setLabelFont:[UIFont fontWithName:@"Avenir" size:20]];
    
    [[TRSDialScrollView appearance] setMinorTickColor:[UIColor colorWithRed:0.800 green:0.553 blue:0.318 alpha:1.000]];
    [[TRSDialScrollView appearance] setMinorTickLength:15.0];
    [[TRSDialScrollView appearance] setMinorTickWidth:1.0];
    
    [[TRSDialScrollView appearance] setMajorTickColor:[UIColor colorWithRed:0.098 green:0.220 blue:0.396 alpha:1.000]];
    [[TRSDialScrollView appearance] setMajorTickLength:33.0];
    [[TRSDialScrollView appearance] setMajorTickWidth:2.0];
    
    [[TRSDialScrollView appearance] setShadowColor:[UIColor colorWithRed:0.593 green:0.619 blue:0.643 alpha:1.000]];
    [[TRSDialScrollView appearance] setShadowOffset:CGSizeMake(0, 1)];
    [[TRSDialScrollView appearance] setShadowBlur:0.9f];
    
    [_dialView setDialRangeFrom:130 to:220];
    if (self.isFromAgeSettingsVC) {
        _dialView.currentValue = 165;//系统默认
    }
    else
        _dialView.currentValue = self.userInfo.height;
    
    self.currentWeightLabel.text = [NSString stringWithFormat:@"%li", (long)_dialView.currentValue];
    
    _dialView.delegate = self;
    _dialView.layer.masksToBounds = YES;
    _dialView.layer.cornerRadius = CornerRadius;
    _dialView.layer.borderWidth = 1.0;
    _dialView.layer.borderColor = ColorRed_Normal.CGColor;
    [self.view addSubview:self.dialView];
    
    [self.dialView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.currentWeightLabel.mas_bottom).offset(@20);
        make.width.equalTo(self.dialView.frame.size.width);
        make.left.equalTo(self.dialView.frame.origin.x);
        make.height.equalTo(self.dialView.bounds.size.height);
    }];
    
    UIView *redLine = [UIView new];
    redLine.frame = CGRectMake(_dialView.frame.size.width/2-1, 0, 2, _dialView.bounds.size.height-20);
    [_dialView addSubview:redLine];
    redLine.backgroundColor = ColorRed_Normal;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *_avatarImagename = nil;
    if (self.userInfo.gender == GenderTypeMale) {
        _avatarImagename = @"settings-person-boy";
    }
    else if (self.userInfo.gender == GenderTypeFemale) {
        _avatarImagename = @"settings-person-girl";
    }
    
    _avatarImgV.image = [UIImage imageNamed:_avatarImagename];
}

- (void)setupBarButton
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextToSetWeight:)];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],
                                NSForegroundColorAttributeName, NRFont(FontNavBarButtonTextSize), NSFontAttributeName, nil];
    [rightItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - Action

- (void)nextToSetWeight:(id)sender {
    //1.校验
    self.userInfo.height  = _dialView.currentValue;
    //2.
    NRPersonWeightSettingController *weightVC = [[NRPersonWeightSettingController alloc] initWithUserInfo:self.userInfo isFromHeightVC:YES];
    [self.navigationController pushViewController:weightVC animated:YES];
}

- (void)back:(id)sender {
    self.userInfo.height  = _dialView.currentValue;
    [super back:sender];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 从中可以读取contentOffset属性以确定其滚动到的位置。
    self.currentWeightLabel.text = [NSString stringWithFormat:@"%li", (long)_dialView.currentValue];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
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