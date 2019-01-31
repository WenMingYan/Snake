//
//  MYSnakeItemBox.m
//  Snake
//
//  Created by 明妍 on 2019/1/30.
//  Copyright © 2019 明妍. All rights reserved.
//

#import "MYSnakeItemBox.h"
#import "MYSnakeItem.h"

@interface MYSnakeItemBox ()

@property (nonatomic, strong) MYSnakeItem *item; /**< 蛇的item  */
@end

@implementation MYSnakeItemBox

+ (instancetype)snakeItemBoxiWithSnakeItem:(MYSnakeItem *)item {
    MYSnakeItemBox *itemBox = [[MYSnakeItemBox alloc] init];
    itemBox.item = item;
    itemBox.width = 0.1;
    itemBox.height = 0.1;
    itemBox.length = 0.1;
    return itemBox;
}

- (void)setItem:(MYSnakeItem *)item {
    _item = item;
    //TODO: wmy set position
}

@end
