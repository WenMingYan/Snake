//
//  SCNGeometry+MYNode.h
//  Snake
//
//  Created by 明妍 on 2019/2/2.
//  Copyright © 2019 明妍. All rights reserved.
//

#import <SceneKit/SceneKit.h>

@interface SCNGeometry (MYNode)

@property(nonatomic, weak) SCNNode *parentNode;/**< 节点  */

@end
