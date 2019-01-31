//
//  MYSnakeItemBox.h
//  Snake
//
//  Created by 明妍 on 2019/1/30.
//  Copyright © 2019 明妍. All rights reserved.
//  蛇的身体Item 立方体 模型

#import <SceneKit/SceneKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface MYSnakeItemBox : SCNBox

+ (instancetype)snakeItemBox;

@property(nonatomic, weak) MYSnakeItemBox *nextItemBox;/**< 下一节  */
@property(nonatomic, weak) MYSnakeItemBox *preItemBox;/**< 上一节  */

@property (nonatomic, assign) SCNVector3 position;
@property(nonatomic, weak) SCNNode *node;/**< 根节点  */

@end

NS_ASSUME_NONNULL_END
