//
//  SCNGeometry+MYNode.m
//  Snake
//
//  Created by 明妍 on 2019/2/2.
//  Copyright © 2019 明妍. All rights reserved.
//

#import "SCNGeometry+MYNode.h"
#import <objc/runtime.h>

@implementation SCNGeometry (MYNode)

- (void)setParentNode:(SCNNode *)parentNode {
    objc_setAssociatedObject(self, @selector(parentNode), parentNode, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SCNNode *)parentNode {
    return objc_getAssociatedObject(self, _cmd);
}

@end
