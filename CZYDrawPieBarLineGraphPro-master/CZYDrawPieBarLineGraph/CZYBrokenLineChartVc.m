//
//  CZYBrokenLineChartVc.m
//  CZYDrawPieBarLineGraph
//
//  Created by macOfEthan on 16/12/15.
//  Copyright © 2016年 macOfEthan. All rights reserved.
//

#import "CZYBrokenLineChartVc.h"

@interface CZYBrokenLineChartVc ()

@property (nonatomic, weak) UIView *lineGraphBgView;
@property (nonatomic, strong) NSMutableArray *xArr;
@property (nonatomic, strong) NSMutableArray *yArr;
@property (nonatomic, strong) UIBarButtonItem *jumpToPieChart;
@property (nonatomic, strong) UIBarButtonItem *jumpToBarChart;

@end

@implementation CZYBrokenLineChartVc

#pragma mark - 初始化
- (UIView *)lineGraphBgView
{
    if (_lineGraphBgView == nil) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFullWidth, lineGraphHeight)];
        bgView.backgroundColor = kLightGrayColor;
        _lineGraphBgView = bgView;
        [self.view addSubview:_lineGraphBgView];
    }
    return _lineGraphBgView;
}

- (NSMutableArray *)xArr
{
    if (!_xArr) {
        self.xArr = [[NSMutableArray alloc] initWithObjects:@"Mon",@"Tue",@"Thi",@"For",@"Fri",@"Sat",@"Sun", nil];
    }
    return _xArr;
}

- (NSMutableArray *)yArr
{
    if (!_yArr) {
        self.yArr = [[NSMutableArray alloc] initWithObjects:@"20",@"30",@"23",@"45",@"67",@"32",@"13", nil];
    }
    return _yArr;
}


- (UIBarButtonItem *)jumpToPieChart
{
    if (_jumpToPieChart == nil) {
        self.jumpToPieChart = [[UIBarButtonItem alloc] initWithTitle:@"饼状图" style:UIBarButtonItemStylePlain target:self action:@selector(jumpToPieChart:)];
    }
    return _jumpToPieChart;
}

- (UIBarButtonItem *)jumpToBarChart
{
    if (_jumpToBarChart == nil) {
        self.jumpToBarChart = [[UIBarButtonItem alloc] initWithTitle:@"柱状图" style:UIBarButtonItemStylePlain target:self action:@selector(jumpToBarChart:)];
    }
    return _jumpToBarChart;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"折线图";
    self.navigationController.navigationBar.translucent = NO;
    
    [self drawLineGraph];
    
    self.navigationItem.rightBarButtonItem = self.jumpToPieChart;
    self.navigationItem.leftBarButtonItem = self.jumpToBarChart;
}


#pragma mark - 画折线图
- (void)drawLineGraph
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //原点
    CGPoint dotPoint = CGPointMake(margin, lineGraphHeight-margin);
    
    
    //画x轴
    [path moveToPoint:dotPoint];
    [path addLineToPoint:CGPointMake(kFullWidth-margin, lineGraphHeight-margin)];
    
    
    //画x轴的箭头
    [path moveToPoint:CGPointMake(kFullWidth-margin, lineGraphHeight-margin)];
    [path addLineToPoint:CGPointMake(kFullWidth-margin-5, lineGraphHeight-margin-5)];
    [path moveToPoint:CGPointMake(kFullWidth-margin, lineGraphHeight-margin)];
    [path addLineToPoint:CGPointMake(kFullWidth-margin-5, lineGraphHeight-margin+5)];
    
    //画y轴
    [path moveToPoint:dotPoint];
    [path addLineToPoint:CGPointMake(margin, kTopSpace)];
    
    //画y轴上的箭头
    [path moveToPoint:CGPointMake(margin, kTopSpace)];
    [path addLineToPoint:CGPointMake(margin-5, kTopSpace+5)];
    [path moveToPoint:CGPointMake(margin, kTopSpace)];
    [path addLineToPoint:CGPointMake(margin+5, kTopSpace+5)];
    
    //画x轴上的标注
    CGFloat xSpace = (kFullWidth-2*margin-20)/self.xArr.count;
    for (NSInteger i=1; i<=self.xArr.count; i++) {
        [path moveToPoint:CGPointMake(margin+xSpace*i, lineGraphHeight-margin)];
        [path addLineToPoint:CGPointMake(margin+xSpace*i, lineGraphHeight-margin-5)];
    }
    
    //画x轴上的数据
    for (NSInteger i=0; i<self.xArr.count; i++) {
        UILabel *xLab = [[UILabel alloc] initWithFrame:CGRectMake(margin+xSpace*(i+1)-10, lineGraphHeight-margin-+2, 20, 25)];
        xLab.text = _xArr[i];
        xLab.font = kFont(9);
        xLab.textAlignment = NSTextAlignmentCenter;
        [self.lineGraphBgView addSubview:xLab];
    }
    
    //画y轴上的标注
    CGFloat ySpace = (lineGraphHeight-margin-kTopSpace-20)/self.yArr.count;
    for (NSInteger i=1; i<=self.yArr.count; i++) {
        [path moveToPoint:CGPointMake(margin, lineGraphHeight-margin-ySpace*i)];
        [path addLineToPoint:CGPointMake(margin+5, lineGraphHeight-margin-ySpace*i)];
    }
    
    //画y轴上的数据
    for (NSInteger i=0; i<_yArr.count; i++) {
        UILabel *yLab = [[UILabel alloc] initWithFrame:CGRectMake(margin-20, lineGraphHeight-margin-ySpace*(i+1)-10, 20, 20)];
        yLab.text = [NSString stringWithFormat:@"%ld",10*(i+1)];
        yLab.textAlignment = NSTextAlignmentCenter;
        yLab.font = kFont(9);
        [self.lineGraphBgView addSubview:yLab];
    }
    
    //开始画折线
    [path moveToPoint:CGPointMake(margin+xSpace, lineGraphHeight-margin-[_yArr[0] floatValue]/10*ySpace)];
    for (NSInteger i=0; i<_yArr.count; i++) {
        [path addLineToPoint:CGPointMake(margin+xSpace+xSpace*i, lineGraphHeight-margin-[_yArr[i] floatValue]/10*ySpace)];
        [path moveToPoint:CGPointMake(margin+xSpace+xSpace*i, lineGraphHeight-margin-[_yArr[i] floatValue]/10*ySpace)];
    }
    
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [kRedColor CGColor];
    shapeLayer.lineWidth = 2;
    shapeLayer.lineCap = kCALineCapRound;
    [self.lineGraphBgView.layer addSublayer:shapeLayer];
    
    
    //画点虚线
    CAShapeLayer *dashLayer = [CAShapeLayer layer];
    dashLayer.strokeColor = [kBlackColor CGColor];
    dashLayer.lineWidth = 1;
    dashLayer.lineJoin = kCALineJoinRound;
    [dashLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:8], nil]];
    
    
    CGMutablePathRef dashPath = CGPathCreateMutable();
    
    
    //点到x轴的虚线
    for (NSInteger i=0; i<_yArr.count; i++) {
        CGPathMoveToPoint(dashPath, NULL, margin+xSpace+xSpace*i, lineGraphHeight-margin-[_yArr[i] floatValue]/10*ySpace);
        CGPathAddLineToPoint(dashPath, NULL, margin+xSpace+xSpace*i, lineGraphHeight-margin);
    }
    
    //点到y轴的虚线
    for (NSInteger i=0; i<_yArr.count; i++) {
        CGPathMoveToPoint(dashPath, NULL, margin+xSpace+xSpace*i, lineGraphHeight-margin-[_yArr[i] floatValue]/10*ySpace);
        CGPathAddLineToPoint(dashPath, NULL, margin, lineGraphHeight-margin-[_yArr[i] floatValue]/10*ySpace);
    }
    
    dashLayer.path = dashPath;
    
    CGPathRelease(dashPath);
    
    [self.lineGraphBgView.layer addSublayer:dashLayer];
    
    //标上每一个点的值
    for (NSInteger i=0; i<_yArr.count; i++) {
        UILabel *valueLab = [[UILabel alloc] initWithFrame:CGRectMake(margin+xSpace+xSpace*i-10, lineGraphHeight-margin-[_yArr[i] floatValue]/10*ySpace-20, 20, 20)];
        valueLab.text = [NSString stringWithFormat:@"%@",_yArr[i]];
        valueLab.font = kFont(9);
        valueLab.textAlignment = NSTextAlignmentCenter;
        [self.lineGraphBgView addSubview:valueLab];
    }
    
}


#pragma mark - 饼状图
- (void)jumpToPieChart:(UIBarButtonItem *)sender
{
    CZYPieChartVc *pieVc = [[CZYPieChartVc alloc] init];
    [self.navigationController pushViewController:pieVc animated:YES];
}

#pragma mark - 柱状图
- (void)jumpToBarChart:(UIBarButtonItem *)sender
{
    CZYBarChartVc *barVc = [[CZYBarChartVc alloc] init];
    [self.navigationController pushViewController:barVc animated:YES];
}

@end
