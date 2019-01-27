//
//  GameViewController.m
//  Snake
//
//  Created by 明妍 on 2019/1/27.
//  Copyright © 2019 明妍. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@property (nonatomic, strong) SCNView *sceneView; /**< 场景View  */

@end

@implementation GameViewController

#pragma mark - --------------------dealloc ------------------

#pragma mark - --------------------life cycle--------------------
#pragma mark - --------------------UITableViewDelegate--------------
#pragma mark - --------------------CustomDelegate--------------
#pragma mark - --------------------Event Response--------------
#pragma mark - --------------------private methods--------------
#pragma mark - --------------------getters & setters & init members ------------------

- (SCNView *)sceneView {
    if (!_sceneView) {
        _sceneView = [[SCNView alloc] init];
    }
    return  _sceneView;
}

@end
