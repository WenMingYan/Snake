//
//  MYGridView.m
//  Snake
//
//  Created by 明妍 on 2019/1/30.
//  Copyright © 2019 明妍. All rights reserved.
//

#import "MYGridView.h"

CGFloat kGridView = 10;

@implementation MYGridView

- (void)drawRect:(CGRect)rect {
    [self drawLines];
    self.backgroundColor = [UIColor redColor];
}

- (void)drawLines {
    //1.获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //2.设置当前上下问路径
    //设置起始点
    CGContextMoveToPoint(context, 0, 0);
    //增加点
    int kCount = self.frame.size.width / kGridView;
    
    CGContextAddLineToPoint(context, 0, kGridView * kCount);
    CGContextAddLineToPoint(context, kGridView * kCount, kGridView * kCount);
    CGContextAddLineToPoint(context, kGridView * kCount, 0);
    CGContextAddLineToPoint(context, 0, 0);
    
    for (int i = 0; i < kCount; i++) {
        CGContextMoveToPoint(context, kGridView * i, 0);
        CGContextAddLineToPoint(context, kGridView * i, kGridView * kCount);
    }
    for (int i = 0; i < kCount; i++) {
        CGContextMoveToPoint(context, 0, kGridView * i);
        CGContextAddLineToPoint(context, kGridView * kCount, kGridView * i);
    }
    //关闭路径
    CGContextClosePath(context);
    //3.设置属性
    /*
     UIKit会默认导入 core Graphics框架，UIKit对常用的很多的唱歌方法做了封装
     UIColor setStroke设置边线颜色
     uicolor setFill 设置填充颜色
     
     */
    [[UIColor blackColor]setStroke];
    [[UIColor whiteColor]setFill];
//    [[UIColor yellowColor]set];
    //4.绘制路径
    CGContextDrawPath(context, kCGPathFillStroke);
}

+ (UIImage *)gridImage {
    MYGridView *gridView = [[MYGridView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    return [gridView screenShot];
}

-(UIImage *)screenShot{
    
    UIGraphicsBeginImageContext(self.bounds.size);   //self为需要截屏的UI控件 即通过改变此参数可以截取特定的UI控件
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"image:%@",image); //至此已拿到image
//    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);//把图片保存在本地
    return image;
}

@end
