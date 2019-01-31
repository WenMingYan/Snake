//
//  MYSnakeFood.m
//  Snake
//
//  Created by 明妍 on 2019/1/31.
//  Copyright © 2019 明妍. All rights reserved.
//

#import "MYSnakeFood.h"

@implementation MYSnakeFood

+ (instancetype)snakeFood {
    MYSnakeFood *snakeFood = [MYSnakeFood sphereWithRadius:0.25];
    SCNMaterial *material = [SCNMaterial material];
    material.diffuse.contents = [UIColor blueColor];
    snakeFood.materials = @[material];
    return snakeFood;
}

@end
