//
//  MYSnakeFood.h
//  Snake
//
//  Created by 明妍 on 2019/1/31.
//  Copyright © 2019 明妍. All rights reserved.
//

#import <SceneKit/SceneKit.h>

@interface MYSnakeFood : SCNSphere

@property (nonatomic, assign) SCNVector3 position;

+ (instancetype)snakeFood;

@end
