//
//  CZYBarChartVc.m
//  CZYDrawPieBarLineGraph
//
//  Created by macOfEthan on 16/12/15.
//  Copyright © 2016年 macOfEthan. All rights reserved.
//

#import "CZYBarChartVc.h"

@interface CZYBarChartVc ()

@property (nonatomic, weak) UIView *barChartBgView;

@property (nonatomic, strong) NSMutableArray *numArr;

@property (nonatomic, strong) NSMutableArray *xArr;

@end

@implementation CZYBarChartVc

#pragma mark - 初始化
- (UIView *)barChartBgView
{
    if (_barChartBgView == nil) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFullWidth, 400)];
        view.backgroundColor = kLightGrayColor;
        [self.view addSubview:view];
        
        self.barChartBgView = view;
    }
    return _barChartBgView;
}

- (NSMutableArray *)numArr
{
    if (_numArr == nil) {
        self.numArr = [[NSMutableArray alloc] init];
    }
    return _numArr;
}

- (NSMutableArray *)xArr
{
    if (_xArr == nil) {
        self.xArr = [[NSMutableArray alloc] init];
    }
    return _xArr;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (NSInteger i=0; i<arc4random()%5+4; i++) {
        NSString *randomStr = [NSString stringWithFormat:@"%d",arc4random()%300+100];
        [self.xArr addObject:[NSString stringWithFormat:@"第%ld个",i+1]];
        [self.numArr addObject:randomStr];
    }
    
    self.navigationItem.title = @"柱状图";
    
    [self czyDrawBarChart];
}

#pragma mark - 画柱状图
- (void)czyDrawBarChart
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    //原点
    CGPoint basePoint = CGPointMake(margin, lineGraphHeight-margin);
    
    //原点的值为0
    UILabel *baseLab = [[UILabel alloc] init];
    baseLab.frame = CGRectMake(0, lineGraphHeight-margin-10, margin, 20);
    baseLab.textAlignment = NSTextAlignmentCenter;
    baseLab.font = kFont(10);
    baseLab.text = @"0";
    [self.barChartBgView addSubview:baseLab];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //画x轴
    [path moveToPoint:basePoint];
    [path addLineToPoint:CGPointMake(kFullWidth-margin, lineGraphHeight-margin)];
    
    //画y轴
    [path moveToPoint:basePoint];
    [path addLineToPoint:CGPointMake(margin, margin)];
    
    //画x轴的箭头
    [path moveToPoint:CGPointMake(kFullWidth-margin, lineGraphHeight-margin)];
    [path addLineToPoint:CGPointMake(kFullWidth-margin-5, lineGraphHeight-margin-5)];
    [path moveToPoint:CGPointMake(kFullWidth-margin, lineGraphHeight-margin)];
    [path addLineToPoint:CGPointMake(kFullWidth-margin-5, lineGraphHeight-margin+5)];
    
    //画y轴的箭头
    [path moveToPoint:CGPointMake(margin, margin)];
    [path addLineToPoint:CGPointMake(margin-5, margin+5)];
    [path moveToPoint:CGPointMake(margin, margin)];
    [path addLineToPoint:CGPointMake(margin+5, margin+5)];
    
    //标注线条的layer 区分坐标系线条
    CAShapeLayer *xyLayer = [CAShapeLayer layer];
    xyLayer.lineWidth = 3;
    xyLayer.strokeColor = kBlackColor.CGColor;
    [self.barChartBgView.layer addSublayer:xyLayer];
    UIBezierPath *xyPath = [UIBezierPath bezierPath];
    
    //画x轴上的标注
    float xSpace = (kFullWidth-margin-margin-30)/self.numArr.count;
    for (NSInteger i=0; i<self.numArr.count; i++) {
        [xyPath moveToPoint:CGPointMake(margin+xSpace+xSpace*i, lineGraphHeight-margin)];
        [xyPath addLineToPoint:CGPointMake(margin+xSpace+xSpace*i, lineGraphHeight-margin-3)];
    }
    
    //画y轴上的标注
    float ySpace = (lineGraphHeight-margin-margin-30)/self.numArr.count;
    for (NSInteger i=0; i<self.numArr.count; i++) {
        [xyPath moveToPoint:CGPointMake(margin, lineGraphHeight-margin-ySpace-ySpace*i)];
        [xyPath addLineToPoint:CGPointMake(margin+3, lineGraphHeight-margin-ySpace-ySpace*i)];
    }
    
    xyLayer.path = xyPath.CGPath;
    
    //画x轴上的值
    for (NSInteger i=0; i<self.xArr.count; i++) {
        UILabel *xLab = [[UILabel alloc] initWithFrame:CGRectMake(margin+xSpace+xSpace*i-20,
                                                                  lineGraphHeight-margin,
                                                                  40,
                                                                  20)];
        xLab.text = _xArr[i];
        xLab.font = kFont(10);
        xLab.textAlignment = NSTextAlignmentCenter;
        [self.barChartBgView addSubview:xLab];
    }
    
    //画y轴上的值
    for (NSInteger i=0; i<self.numArr.count; i++) {
        UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                    lineGraphHeight-margin-ySpace-ySpace*i-10,
                                                                    margin,
                                                                    20)];
        numLab.text = [NSString stringWithFormat:@"%ld",100+100*i];
        numLab.font = kFont(10);
        numLab.textAlignment = NSTextAlignmentCenter;
        [self.barChartBgView addSubview:numLab];
    }
    
    //画矩形
    for (NSInteger i=0; i<_numArr.count; i++) {
        CAShapeLayer *barLayer = [CAShapeLayer layer];
        barLayer.lineWidth = 2;
        //填充颜色
        barLayer.fillColor = kRandomColor.CGColor;
        //外部线条的颜色
        barLayer.strokeColor = kClearColor.CGColor;
        UIBezierPath *barPath = [UIBezierPath bezierPathWithRect:CGRectMake(margin+xSpace+xSpace*i-15,
                                                                            lineGraphHeight-margin-([_numArr[i] floatValue]/100)*ySpace,
                                                                            30,
                                                                            [_numArr[i] floatValue]/100*ySpace)];
        barLayer.path = barPath.CGPath;
        [self.barChartBgView.layer addSublayer:barLayer];
    }
    
    //绘制每个矩形上面的值
    for (NSInteger i=0; i<_numArr.count; i++) {
        UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(margin+xSpace+xSpace*i-15,
                                                                    lineGraphHeight-margin-([_numArr[i] floatValue]/100)*ySpace-20,
                                                                    30,
                                                                    20)];
        numLab.text = _numArr[i];
        numLab.textAlignment = NSTextAlignmentCenter;
        numLab.font = kFont(9);
        [self.barChartBgView addSubview:numLab];
    }
    
    layer.path = path.CGPath;
    layer.strokeColor = kRedColor.CGColor;
    layer.lineWidth = 1;
    [self.barChartBgView.layer addSublayer:layer];
}


@end
