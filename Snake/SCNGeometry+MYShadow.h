//
//  SCNGeometry+MYShadow.h
//  Snake
//
//  Created by 明妍 on 2019/2/1.
//  Copyright © 2019 明妍. All rights reserved.
//

#import <SceneKit/SceneKit.h>

extern CGFloat const diff;

@interface SCNGeometry (MYShadow)

@property(nonatomic, strong) SCNNode *leftShadowNode;/**< 左阴影  */
@property(nonatomic, strong) SCNNode *rightShadowNode;/**< 右阴影  */

@property(nonatomic, strong) SCNNode *foreShadowNode;/**< 前阴影  */
@property(nonatomic, strong) SCNNode *backShadowNode;/**< 后阴影  */

@property (nonatomic, strong) SCNNode *topShadowNode; /**< 上阴影  */
@property (nonatomic, strong) SCNNode *bottomShadowNode; /**< 下阴影  */

@property (nonatomic, strong) SCNMaterial *shadowMaterial; /**< 阴影的材质  */

- (void)shadowWithDuration:(CGFloat)duration byNodePosition:(SCNVector3)vector andNodeLength:(CGFloat)length;

- (void)leftActionWithDuration:(CGFloat)duration byNodePosition:(SCNVector3)vector andNodeLength:(CGFloat)length;
- (void)rightActionWithDuration:(CGFloat)duration byNodePosition:(SCNVector3)vector andNodeLength:(CGFloat)length;

- (void)topActionWithDuration:(CGFloat)duration byNodePosition:(SCNVector3)vector andNodeLength:(CGFloat)length;
- (void)bottomActionWithDuration:(CGFloat)duration byNodePosition:(SCNVector3)vector andNodeLength:(CGFloat)length;

- (void)foreActionWithDuration:(CGFloat)duration byNodePosition:(SCNVector3)vector andNodeLength:(CGFloat)length;
- (void)backActionWithDuration:(CGFloat)duration byNodePosition:(SCNVector3)vector andNodeLength:(CGFloat)length;

@end

