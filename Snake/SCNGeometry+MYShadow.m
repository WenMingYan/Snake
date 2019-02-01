//
//  SCNGeometry+MYShadow.m
//  Snake
//
//  Created by 明妍 on 2019/2/1.
//  Copyright © 2019 明妍. All rights reserved.
//

#import "SCNGeometry+MYShadow.h"
#import <objc/runtime.h>

CGFloat const diff = 0.01;

@implementation SCNGeometry (MYShadow)

- (void)foreActionWithDuration:(CGFloat)duration byNodePosition:(SCNVector3)vector andNodeLength:(CGFloat)length {
    SCNVector3 foreVector = SCNVector3Make(-vector.x, vector.y-length/2, diff);// 相对top坐标
    SCNAction *foreAction = [SCNAction moveTo:foreVector duration:duration];
    [self.foreShadowNode runAction:foreAction];
}

- (void)backActionWithDuration:(CGFloat)duration byNodePosition:(SCNVector3)vector andNodeLength:(CGFloat)length {
    SCNVector3 backVector = SCNVector3Make(vector.x, -length/2+vector.y, diff);// 相对bottom坐标
    SCNAction *backAction = [SCNAction moveTo:backVector duration:duration];
    [self.backShadowNode runAction:backAction];
}

- (void)topActionWithDuration:(CGFloat)duration byNodePosition:(SCNVector3)vector andNodeLength:(CGFloat)length {
    SCNVector3 topVector = SCNVector3Make(vector.x, vector.z, diff);// 相对top坐标
    SCNAction *topAction = [SCNAction moveTo:topVector duration:duration];
    [self.topShadowNode runAction:topAction];
}
- (void)bottomActionWithDuration:(CGFloat)duration byNodePosition:(SCNVector3)vector andNodeLength:(CGFloat)length {
    SCNVector3 bottomVector = SCNVector3Make(vector.x, -vector.z, diff);// 相对bottom坐标
    SCNAction *bottomAction = [SCNAction moveTo:bottomVector duration:duration];
    [self.bottomShadowNode runAction:bottomAction];
}

- (void)leftActionWithDuration:(CGFloat)duration byNodePosition:(SCNVector3)vector andNodeLength:(CGFloat)length {
    SCNVector3 leftVector = SCNVector3Make(-vector.z, -length/2+vector.y, diff);// 相对left坐标
    SCNAction *leftAction = [SCNAction moveTo:leftVector duration:duration];
    [self.leftShadowNode runAction:leftAction];
}


- (void)rightActionWithDuration:(CGFloat)duration byNodePosition:(SCNVector3)vector andNodeLength:(CGFloat)length {
    SCNVector3 rightVector = SCNVector3Make(vector.z, -length/2+vector.y, diff);// 相对right坐标
    SCNAction *rightAction = [SCNAction moveTo:rightVector duration:duration];
    [self.rightShadowNode runAction:rightAction];
}



#pragma mark getter and setter

- (void)setBackShadowNode:(SCNNode *)backShadowNode {
    objc_setAssociatedObject(self, @selector(backShadowNode), backShadowNode, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SCNNode *)backShadowNode {
    SCNNode *backSidePlaneNode = objc_getAssociatedObject(self, _cmd);
    if (!backSidePlaneNode) {
        backSidePlaneNode = [self newNode];
        [self setBackShadowNode:backSidePlaneNode];
    }
    return backSidePlaneNode;
}

- (void)setForeShadowNode:(SCNNode *)foreShadowNode {
    objc_setAssociatedObject(self, @selector(foreShadowNode), foreShadowNode, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SCNNode *)foreShadowNode {
    SCNNode *backSidePlaneNode = objc_getAssociatedObject(self, _cmd);
    if (!backSidePlaneNode) {
        backSidePlaneNode = [self newNode];
        [self setForeShadowNode:backSidePlaneNode];
    }
    return backSidePlaneNode;

}

- (void)setBottomShadowNode:(SCNNode *)bottomShadowNode {
    objc_setAssociatedObject(self, @selector(bottomShadowNode), bottomShadowNode, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SCNNode *)bottomShadowNode {
    SCNNode *backSidePlaneNode = objc_getAssociatedObject(self, _cmd);
    if (!backSidePlaneNode) {
        backSidePlaneNode = [self newNode];
        [self setBottomShadowNode:backSidePlaneNode];
    }
    return backSidePlaneNode;
}

- (void)setTopShadowNode:(SCNNode *)topShadowNode {
    objc_setAssociatedObject(self, @selector(topShadowNode), topShadowNode, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SCNNode *)topShadowNode {
    SCNNode *backSidePlaneNode = objc_getAssociatedObject(self, _cmd);
    if (!backSidePlaneNode) {
        backSidePlaneNode = [self newNode];
        [self setTopShadowNode:backSidePlaneNode];
    }
    return backSidePlaneNode;
}

- (void)setRightShadowNode:(SCNNode *)rightShadowNode {
    objc_setAssociatedObject(self, @selector(rightShadowNode), rightShadowNode, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SCNNode *)rightShadowNode {
    SCNNode *backSidePlaneNode = objc_getAssociatedObject(self, _cmd);
    if (!backSidePlaneNode) {
        backSidePlaneNode = [self newNode];
        [self setRightShadowNode:backSidePlaneNode];
    }
    return backSidePlaneNode;
}

- (void)setLeftShadowNode:(SCNNode *)leftShadowNode {
    objc_setAssociatedObject(self, @selector(leftShadowNode), leftShadowNode, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SCNNode *)leftShadowNode {
    SCNNode *backSidePlaneNode = objc_getAssociatedObject(self, _cmd);
    if (!backSidePlaneNode) {
        backSidePlaneNode = [self newNode];
        [self setLeftShadowNode:backSidePlaneNode];
    }
    return backSidePlaneNode;
}

- (SCNNode *)newNode {
    SCNNode *node = [SCNNode node];
    SCNPlane *plane = [self newPlane];
    node.geometry = plane;
    return node;
}

- (SCNPlane *)newPlane {
    SCNPlane *plane = [SCNPlane planeWithWidth:0.5 height:0.5];
    SCNMaterial *material = [SCNMaterial material];
    material.diffuse.contents = [UIColor grayColor];
    plane.materials = @[material];
    return plane;
}

@end
