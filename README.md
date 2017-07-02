# CZYDrawPieBarLineGraphPro
#使用CAShapeLayer结合UIBezierPath绘制折线图，矩形图，饼状图

#折线图效果 绘制坐标系->坐标系箭头->坐标系刻度->坐标系数值->绘制折线->绘制虚线
        [path addLineToPoint:CGPointMake(margin+xSpace+xSpace*i, lineGraphHeight-margin-[_yArr[i] floatValue]/10*ySpace)];
![image](https://github.com/ITIosEthan/CzyDrawPieBarLineGraphProDemo/blob/master/Simulator%20Screen%20Shot%202016%E5%B9%B412%E6%9C%8823%E6%97%A5%20%E4%B8%8B%E5%8D%884.47.14.png)
#柱状图效果
        UIBezierPath *barPath = [UIBezierPath bezierPathWithRect:CGRectMake(margin+xSpace+xSpace*i-15,
                                                                            lineGraphHeight-margin-([_numArr[i] floatValue]/100)*ySpace,
                                                                            30,
                                                                            [_numArr[i] floatValue]/100*ySpace)];
![image](https://github.com/ITIosEthan/CzyDrawPieBarLineGraphProDemo/blob/master/Simulator%20Screen%20Shot%202016%E5%B9%B412%E6%9C%8823%E6%97%A5%20%E4%B8%8B%E5%8D%884.47.18.png)
#饼状图效果
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:arcDotPoint radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
#数值标签坐标
        //标注每一快的值得大小 +15 和-10 为细节调整
        float x = arcDotPoint.x + (radius + 15) * cos(startAngle + (endAngle - startAngle)/2) - 10;
        float y = arcDotPoint.y + (radius + 15) * sin(startAngle + (endAngle - startAngle)/2) - 10;
![image](https://github.com/ITIosEthan/CzyDrawPieBarLineGraphProDemo/blob/master/Simulator%20Screen%20Shot%202016%E5%B9%B412%E6%9C%8823%E6%97%A5%20%E4%B8%8B%E5%8D%884.47.21.png)
