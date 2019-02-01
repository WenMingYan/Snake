//
//  MYSnakeItemBox.m
//  Snake
//
//  Created by 明妍 on 2019/1/30.
//  Copyright © 2019 明妍. All rights reserved.
//

#import "MYSnakeItemBox.h"

CGFloat const kBoxLength = 10;

@implementation MYSnakeItemBox

+ (instancetype)snakeItemBox {
    MYSnakeItemBox *itemBox = [[MYSnakeItemBox alloc] init];
    itemBox.width = 0.5;
    itemBox.height = 0.5;
    itemBox.length = 0.5;
    itemBox.chamferRadius = 0.1;
    // 材质
    SCNMaterial *material = [SCNMaterial material];
    material.diffuse.contents = [UIColor redColor];
    itemBox.materials = @[material];
    
    return itemBox;
}
@end
