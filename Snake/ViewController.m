//
//  ViewController.m
//  Snake
//
//  Created by 明妍 on 2019/1/30.
//  Copyright © 2019 明妍. All rights reserved.
//

#import "ViewController.h"
#import <SceneKit/SceneKit.h>
#import <Masonry/Masonry.h>
#import "MYSnakeItem.h"
#import "MYSnakeItemBox.h"
#import "MYGridView.h"

CGFloat kSnakeInitialCount = 6;
CGFloat kPlandLength = 20;

@interface ViewController ()

@property (nonatomic, strong) SCNView *threeDscnView; /**< 3D View  */
@property (nonatomic, strong) SCNScene *threeScene; /**< 3D场景  */
@property (nonatomic, strong) NSMutableArray<MYSnakeItemBox *> *snakeItems; /**< 蛇身体的每一块 初始值有6块 */

@property (nonatomic, strong) SCNPlane *bottomPlane; /**< 底板  */
@property (nonatomic, strong) SCNPlane *leftPlane; /**< 左侧板  */
@property (nonatomic, strong) SCNPlane *rightPlane; /**< 右侧板  */
@property (nonatomic, strong) SCNPlane *topPlane; /**< 顶部板  */
@property (nonatomic, strong) SCNPlane *forePlane; /**< 前部板  */
@property (nonatomic, strong) SCNPlane *backPlane; /**< 背部板  */

@property (nonatomic, strong) SCNCamera *camera; /**< 照相机  */

@end

@implementation ViewController

#pragma mark - --------------------dealloc ------------------
#pragma mark - --------------------life cycle--------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)initData {
    [self setupSnake];
}

- (void)initView {
    [self.view addSubview:self.threeDscnView];
    [self.threeDscnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


/**
 初始化蛇item
 */
- (void)setupSnake {
    MYSnakeItemBox *preItemBox;
    SCNVector3 vector = SCNVector3Make(0.1, 0.1, 5);
    for (int i = 0; i < kSnakeInitialCount; i++) {
        MYSnakeItem *item = [[MYSnakeItem alloc] init];
        item.position = vector;
        MYSnakeItemBox *itemBox = [MYSnakeItemBox snakeItemBoxiWithSnakeItem:item];
        preItemBox.nextItemBox = itemBox;
        itemBox.preItemBox = preItemBox;
        preItemBox = itemBox;
        
        // 改变vector
        
        [self.snakeItems addObject:itemBox];
    }
    // 添加蛇到场景中
    for (MYSnakeItemBox *snakeItemBox in self.snakeItems) {
        [self.threeScene.rootNode addChildNode:[SCNNode nodeWithGeometry:snakeItemBox]];
    }
}

#pragma mark - --------------------UITableViewDelegate--------------
#pragma mark - --------------------CustomDelegate--------------
#pragma mark - --------------------Event Response--------------
#pragma mark - --------------------private methods--------------
#pragma mark - --------------------getters & setters & init members ------------------

- (SCNCamera *)camera {
    if (!_camera) {
        _camera = [[SCNCamera alloc] init];
    }
    return _camera;
}

- (NSMutableArray<MYSnakeItemBox *> *)snakeItems {
    if (!_snakeItems) {
        _snakeItems = [NSMutableArray<MYSnakeItemBox *> array];
    }
    return _snakeItems;
}

- (SCNScene *)threeScene {
    if (!_threeScene) {
        _threeScene = [SCNScene sceneNamed:@"snake.scnassets/snake.scn"];
        // 添加照相机
        SCNNode *bottomNode = [_threeScene.rootNode childNodeWithName:@"bottomPlane" recursively:NO];
        SCNNode *topNode = [_threeScene.rootNode childNodeWithName:@"topPlane" recursively:NO];
        SCNNode *backNode = [_threeScene.rootNode childNodeWithName:@"backPlane" recursively:NO];
        SCNNode *leftNode = [_threeScene.rootNode childNodeWithName:@"leftPlane" recursively:NO];
        SCNNode *foreNode = [_threeScene.rootNode childNodeWithName:@"forePlane" recursively:NO];
        SCNNode *rightNode = [_threeScene.rootNode childNodeWithName:@"rightPlane" recursively:NO];
        
        SCNNode *cameraNode = [_threeScene.rootNode childNodeWithName:@"camera" recursively:NO];
        
        self.bottomPlane = (SCNPlane *)bottomNode.geometry;
        self.topPlane = (SCNPlane *)topNode.geometry;
        self.backPlane = (SCNPlane *)backNode.geometry;
        self.leftPlane = (SCNPlane *)leftNode.geometry;
        self.rightPlane = (SCNPlane *)rightNode.geometry;
        self.forePlane = (SCNPlane *)foreNode.geometry;
        self.camera = cameraNode.camera;

        SCNMaterial *material = [SCNMaterial material];
        material.diffuse.contents = [MYGridView gridImage];
        // 底板
        self.bottomPlane.materials = @[material];
        // 顶板
        self.topPlane.materials = @[material];
        // 后侧
        self.backPlane.materials = @[material];
        // 前侧
        self.forePlane.materials = @[material];
        // 左侧
        self.leftPlane.materials = @[material];
        // 右侧
        self.rightPlane.materials = @[material];
        
        self.camera.focalLength = 70;
    }
    return _threeScene;
}

- (SCNView *)threeDscnView {
    if (!_threeDscnView) {
        _threeDscnView = [[SCNView alloc] init];
        _threeDscnView.scene = self.threeScene;
        _threeDscnView.backgroundColor = [UIColor grayColor];
        _threeDscnView.allowsCameraControl = YES;
        _threeDscnView.showsStatistics = YES;
        _threeDscnView.autoenablesDefaultLighting = YES;
        _threeDscnView.playing = YES;
        
    }
    return _threeDscnView;
}

@end
