//
//  MYSnakeItemBox.h
//  Snake
//
//  Created by 明妍 on 2019/1/30.
//  Copyright © 2019 明妍. All rights reserved.
//  蛇的身体Item 立方体 模型

#import <SceneKit/SceneKit.h>
#import "SCNGeometry+MYNode.h"

extern CGFloat const kBoxLength;

@interface MYSnakeItemBox : SCNBox

+ (instancetype)snakeItemBox;

@property(nonatomic, weak) MYSnakeItemBox *nextItemBox;/**< 下一节  */
@property(nonatomic, weak) MYSnakeItemBox *preItemBox;/**< 上一节  */

@property (nonatomic, assign) SCNVector3 position;


@end

