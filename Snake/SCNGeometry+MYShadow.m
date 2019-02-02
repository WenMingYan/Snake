//
//  SCNGeometry+MYShadow.m
//  Snake
//
//  Created by 明妍 on 2019/2/1.
//  Copyright © 2019 明妍. All rights reserved.
//

#import "SCNGeometry+MYShadow.h"
#import <objc/runtime.h>
#import "SCNGeometry+MYNode.h"

CGFloat const diff = 0.03;

@implementation SCNGeometry (MYShadow)

- (void)shadowWithDuration:(CGFloat)duration byNodePosition:(SCNVector3)vector andNodeLength:(CGFloat)length {
    self.leftShadowNode.hidden =
    self.rightShadowNode.hidden =
    self.topShadowNode.hidden =
    self.bottomShadowNode.hidden =
    self.foreShadowNode.hidden =
    self.backShadowNode.hidden =
    self.parentNode.hidden;
    if (self.parentNode.hidden) {
        return;
    }
    [self leftActionWithDuration:duration byNodePosition:vector andNodeLength:length];
    [self rightActionWithDuration:duration byNodePosition:vector andNodeLength:length];
    [self topActionWithDuration:duration byNodePosition:vector andNodeLength:length];
    [self bottomActionWithDuration:duration byNodePosition:vector andNodeLength:length];
    [self foreActionWithDuration:duration byNodePosition:vector andNodeLength:length];
    [self backActionWithDuration:duration byNodePosition:vector andNodeLength:length];
}

- (void)foreActionWithDuration:(CGFloat)duration byNodePosition:(SCNVector3)vector andNodeLength:(CGFloat)length {
    SCNVector3 foreVector = SCNVector3Make(-vector.x, vector.y, diff);// 相对top坐标
    if ([self isOutOfBox:foreVector]) {
        self.foreShadowNode.hidden = YES;
        return;
    }
    self.foreShadowNode.hidden = NO;
    SCNAction *foreAction = [SCNAction moveTo:foreVector duration:duration];
    [self.foreShadowNode runAction:foreAction];
}

- (void)backActionWithDuration:(CGFloat)duration byNodePosition:(SCNVector3)vector andNodeLength:(CGFloat)length {
    SCNVector3 backVector = SCNVector3Make(vector.x, vector.y, diff);// 相对bottom坐标
    if ([self isOutOfBox:backVector]) {
        self.backShadowNode.hidden = YES;
        return;
    }
    self.backShadowNode.hidden = NO;
    SCNAction *backAction = [SCNAction moveTo:backVector duration:duration];
    [self.backShadowNode runAction:backAction];
}

- (void)topActionWithDuration:(CGFloat)duration byNodePosition:(SCNVector3)vector andNodeLength:(CGFloat)length {
    SCNVector3 topVector = SCNVector3Make(vector.x, vector.z, diff);// 相对top坐标
    if ([self isOutOfBox:topVector]) {
        self.topShadowNode.hidden = YES;
        return;
    }
    self.topShadowNode.hidden = NO;
    SCNAction *topAction = [SCNAction moveTo:topVector duration:duration];
    [self.topShadowNode runAction:topAction];
}
- (void)bottomActionWithDuration:(CGFloat)duration byNodePosition:(SCNVector3)vector andNodeLength:(CGFloat)length {
    SCNVector3 bottomVector = SCNVector3Make(vector.x, -vector.z, diff);// 相对bottom坐标
    if ([self isOutOfBox:bottomVector]) {
        self.bottomShadowNode.hidden = YES;
        return;
    }
    self.bottomShadowNode.hidden = NO;
    SCNAction *bottomAction = [SCNAction moveTo:bottomVector duration:duration];
    [self.bottomShadowNode runAction:bottomAction];
}

- (void)leftActionWithDuration:(CGFloat)duration byNodePosition:(SCNVector3)vector andNodeLength:(CGFloat)length {
    SCNVector3 leftVector = SCNVector3Make(-vector.z, vector.y, diff);// 相对left坐标
    if ([self isOutOfBox:leftVector]) {
        self.leftShadowNode.hidden = YES;
        return;
    }
    self.leftShadowNode.hidden = NO;
    SCNAction *leftAction = [SCNAction moveTo:leftVector duration:duration];
    [self.leftShadowNode runAction:leftAction];
}


- (void)rightActionWithDuration:(CGFloat)duration byNodePosition:(SCNVector3)vector andNodeLength:(CGFloat)length {
    SCNVector3 rightVector = SCNVector3Make(vector.z, vector.y, diff);// 相对right坐标
    if ([self isOutOfBox:rightVector]) {
        self.rightShadowNode.hidden = YES;
        return;
    }
    self.rightShadowNode.hidden = NO;
    SCNAction *rightAction = [SCNAction moveTo:rightVector duration:duration];
    [self.rightShadowNode runAction:rightAction];
}

- (BOOL)isOutOfBox:(SCNVector3)vector {
    return fabsf(vector.x) < 5.f && fabsf(vector.y) < 5.f && fabsf(vector.z) < 5.f;
}



#pragma mark getter and setter

- (void)setShadowMaterial:(SCNMaterial *)shadowMaterial {
    objc_setAssociatedObject(self, @selector(shadowMaterial), shadowMaterial, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.leftShadowNode.geometry.materials = @[shadowMaterial];
    self.rightShadowNode.geometry.materials = @[shadowMaterial];
    self.foreShadowNode.geometry.materials = @[shadowMaterial];
    self.backShadowNode.geometry.materials = @[shadowMaterial];
    self.topShadowNode.geometry.materials = @[shadowMaterial];
    self.bottomShadowNode.geometry.materials = @[shadowMaterial];
}

- (SCNMaterial *)shadowMaterial {
    return objc_getAssociatedObject(self, _cmd);
}

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
    if ([self isKindOfClass:[SCNSphere class]]) {
        plane.cornerRadius = [(SCNSphere *)self radius];
        plane.width = plane.height = [(SCNSphere *)self radius] * 2;
    }
    material.diffuse.contents = [UIColor lightGrayColor];
    plane.materials = @[material];
    return plane;
}

@end
