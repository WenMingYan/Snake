//
//  MYGridBox.m
//  Snake
//
//  Created by 明妍 on 2019/1/30.
//  Copyright © 2019 明妍. All rights reserved.
//

#import "MYGridBox.h"

@interface MYGridBox ()



@end

@implementation MYGridBox

+ (instancetype)gridBox {
    MYGridBox *gridBox = [[MYGridBox alloc] init];
    
    return gridBox;
}

- (void)fetchGrid {
//    UIView
}

- (void)drawLine {
    //提示 使用ref的对象不用使用*
    //1.获取上下文.-UIView对应的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //2.创建可变路径并设置路径
    //当我们开发动画的时候，通常制定对象运动的路线，然后由动画负责动画效果
    CGMutablePathRef path = CGPathCreateMutable();
    //2-1.设置起始点
    CGPathMoveToPoint(path, NULL, 0, 0);
    //2-2.设置目标点
    CGPathAddLineToPoint(path, NULL, 10, 10);
    
    CGPathAddLineToPoint(path, NULL, 50, 200);
    //封闭路径
    //第一种方法
    //CGPathAddLineToPoint(path, NULL, 50, 50);
    //第二张方法
    CGPathCloseSubpath(path);
    //3.将路径添加到上下文
    CGContextAddPath(context, path);
    //4.设置上下文属性
    //4.1.设置线条颜色
    /*
     red 0～1.0  red / 255
     green 0～1.0  green / 255
     blue 0～1.0  blue / 255
     plpha   透明度  0 ～ 1.0
     0 完全透明
     1.0 完全不透明
     提示：在使用rgb设置颜色时。最好不要同时指定rgb和alpha,否则会对性能造成影响。
     
     线条和填充默认都是黑色
     */
    CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1.0);
    //设置填充颜色
    CGContextSetRGBFillColor(context, 0, 1.0, 0, 1.0);
    //4.2 设置线条宽度
    CGContextSetLineWidth(context, 3.0f);
    //设置线条顶点样式
    CGContextSetLineCap(context, kCGLineCapRound);
    //设置连接点的样式
    CGContextSetLineJoin(context, kCGLineJoinRound);
    //设置线条的虚线样式
    CGContextDrawPath(context, kCGPathFillStroke);
    //6.释放路径
    CGPathRelease(path);
}

@end

