//
//  CZYPieChartVc.m
//  CZYDrawPieBarLineGraph
//
//  Created by macOfEthan on 16/12/15.
//  Copyright © 2016年 macOfEthan. All rights reserved.
//

#import "CZYPieChartVc.h"

@interface CZYPieChartVc ()

@property (nonatomic, weak) UIView *pieChartBgView;

@property (nonatomic, strong) NSMutableArray *numArr;

@end

@implementation CZYPieChartVc

#pragma mark - 初始化
- (UIView *)pieChartBgView
{
    if (_pieChartBgView == nil) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFullWidth, kFullHeight)];
        view.backgroundColor = kLightGrayColor;
        [self.view addSubview:view];
        self.pieChartBgView = view;
    }
    return _pieChartBgView;
}

- (NSMutableArray *)numArr
{
    if (_numArr == nil) {
        self.numArr = [[NSMutableArray alloc] init];
    }
    return _numArr;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"饼状图";
    
    //绘制饼状图
    [self.numArr addObjectsFromArray:@[@"12",@"34",@"45",@"98",@"87"]];
    
    [self drawPieChartGraph];
}

#pragma mark - 绘制饼状图
- (void)drawPieChartGraph
{
    //原点
    CGPoint arcDotPoint = CGPointMake(self.view.center.x, self.view.center.y+20);
    
    //半径
    float radius = 100;
    
    //起始幅度和结束幅度
    CGFloat startAngle = 0;
    CGFloat endAngle;
    
    float sum = 0;
    for (NSString *numStr in self.numArr) {
        sum += [numStr floatValue];
    }
    
    for (NSInteger i=0; i<self.numArr.count; i++) {
        
        float percent = [self.numArr[i] floatValue]/sum;
        
        endAngle = startAngle + percent * 2 * M_PI;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:arcDotPoint radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
        [path addLineToPoint:arcDotPoint];
        
        
        
        //标注每一快的值得大小 +15 和-10 为细节调整
        float x = arcDotPoint.x + (radius + 15) * cos(startAngle + (endAngle - startAngle)/2) - 10;
        float y = arcDotPoint.y + (radius + 15) * sin(startAngle + (endAngle - startAngle)/2) - 10;
        
        
        UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 20, 20)];
        numLab.text = self.numArr[i];
        numLab.font = kFont(9);
        [self.pieChartBgView addSubview:numLab];
        
        
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = path.CGPath;
        
        //这个颜色是弧和弧末端点到圆形的直线的颜色
        layer.strokeColor = kRandomColor.CGColor;
        
        //这个是填充的颜色
        layer.fillColor = kRandomColor.CGColor;
        
        layer.lineWidth = 1;
        [self.pieChartBgView.layer addSublayer:layer];
        
        startAngle = endAngle;
        
    }
    
    
}

@end
