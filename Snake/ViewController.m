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
#import "MYSnakeItemBox.h"
#import "MYGridView.h"
#import "MYRestartView.h"
#import "MYSnakeFood.h"
#import "SCNGeometry+MYShadow.h"

CGFloat kSnakeInitialCount = 6;
CGFloat kPlandLength = 20;

CGFloat kGridWidth = 0.5;
CGFloat kAnimationDuration = 0.5;



typedef enum : NSUInteger {
    MYCurrentDirectionLeft,
    MYCurrentDirectionRight,
    MYCurrentDirectionFore,
    MYCurrentDirectionBack,
    MYCurrentDirectionTop,
    MYCurrentDirectionBottom,
} MYCurrentDirection;

@interface ViewController ()

@property (nonatomic, strong) SCNView *threeDscnView; /**< 3D View  */
@property (nonatomic, strong) SCNScene *threeScene; /**< 3D场景  */
@property (nonatomic, strong) NSMutableArray<MYSnakeItemBox *> *snakeItems; /**< 蛇身体的每一块 初始值有6块 */

@property (nonatomic, weak) SCNPlane *bottomPlane; /**< 底板  */
@property (nonatomic, weak) SCNNode *bottomNode; /**< 底板  */

@property (nonatomic, weak) SCNPlane *leftPlane; /**< 左侧板  */
@property (nonatomic, weak) SCNNode *leftNode; /**< 左侧板  */

@property (nonatomic, weak) SCNPlane *rightPlane; /**< 右侧板  */
@property (nonatomic, weak) SCNNode *rightNode; /**< 右侧板  */

@property (nonatomic, weak) SCNPlane *topPlane; /**< 顶部板  */
@property (nonatomic, weak) SCNNode *topNode; /**< 顶部板  */

@property (nonatomic, weak) SCNPlane *forePlane; /**< 前部板  */
@property (nonatomic, weak) SCNNode *foreNode; /**< 前部板  */

@property (nonatomic, weak) SCNPlane *backPlane; /**< 背部板  */
@property (nonatomic, weak) SCNNode *backNode; /**< 背部板  */

@property (nonatomic, strong) SCNCamera *camera; /**< 照相机  */
@property (nonatomic, strong) SCNNode *cameraNode; /**< 照相机  */

@property(nonatomic, weak) SCNNode *snakeNode;/**< 几何基Node  */

@property (nonatomic, assign) BOOL isPlaying;/** < 是否正在游戏*/
@property (nonatomic, strong) NSTimer *timer; /**< 每秒做的动作  */
@property (nonatomic, assign) MYCurrentDirection currentDirection;/** < 当前的方向*/
@property (nonatomic, assign) NSInteger timeStep;/** < 时间间隔*/

@property (nonatomic, strong) MYRestartView *pageView;
@property(nonatomic, weak) MYSnakeItemBox *headItemBox;
@property(nonatomic, weak) MYSnakeItemBox *lastItemBox;
@property (nonatomic, strong) MYSnakeFood *snakeFood;
@property (nonatomic, assign) SCNVector3 lastVector;/** < 蛇尾的位置*/
@property (nonatomic, assign) CGPoint beginPoint;

@end

@implementation ViewController

#pragma mark - --------------------dealloc ------------------
#pragma mark - --------------------life cycle--------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    [self setupChildNodeShadows];
    self.timeStep = 1;
   
}

- (void)initData {
    [self setupSnake];
    [self setupFood];
    
}

- (void)setupChildNodeShadows {
    for (SCNNode *childNode in self.snakeNode.childNodes) {
        SCNGeometry *geometry = childNode.geometry;
        if ([childNode isEqual:self.leftNode] ||
            [childNode isEqual:self.rightNode] ||
            [childNode isEqual:self.topNode] ||
            [childNode isEqual:self.bottomNode] ||
            [childNode isEqual:self.foreNode] ||
            [childNode isEqual:self.backNode] ||
            childNode.camera
            ) {
            continue;
        }
        [self.leftNode addChildNode:geometry.leftShadowNode];
        [self.rightNode addChildNode:geometry.rightShadowNode];
        [self.topNode addChildNode:geometry.topShadowNode];
        [self.bottomNode addChildNode:geometry.bottomShadowNode];
        [self.foreNode addChildNode:geometry.foreShadowNode];
        [self.backNode addChildNode:geometry.backShadowNode];
        [geometry shadowWithDuration:0 byNodePosition:childNode.position andNodeLength:kBoxLength];
    }
}


- (void)initView {
    [self.view addSubview:self.threeDscnView];
    [self.threeDscnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view addSubview:self.pageView];
    [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    // 添加蛇到场景中
    for (MYSnakeItemBox *snakeItemBox in self.snakeItems) {
        SCNNode *node = [SCNNode nodeWithGeometry:snakeItemBox];
        snakeItemBox.parentNode = node;
        [self.snakeNode addChildNode:node];
        node.position = snakeItemBox.position;
        
    }
    MYSnakeItemBox *firstSnakeItemBox = [self.snakeItems objectAtIndex:0];
    
    self.headItemBox = firstSnakeItemBox;
    SCNMaterial *material = [SCNMaterial material];
    material.diffuse.contents = [UIColor greenColor];
    firstSnakeItemBox.materials = @[material];
    
    [self.snakeNode addChildNode:self.snakeFood.parentNode];
}


- (void)setupFood {
    SCNNode *node = [SCNNode node];
    MYSnakeFood *snakeFood = [MYSnakeFood snakeFood];
    node.geometry = snakeFood;
    snakeFood.parentNode = node;
    node.position = [self getFoodPosition];
    
    self.snakeFood = snakeFood;
}

- (SCNVector3)getFoodPosition {
    SCNVector3 vector = SCNVector3Zero;
    BOOL isLegalFoodPosition = YES;
    do {
        int x = arc4random() % (2 * (int)kBoxLength - 1);
        CGFloat vectorX = kGridWidth / 2 + kGridWidth * (x - kBoxLength);
        int y = arc4random() % (2 * (int)kBoxLength - 1);
        CGFloat vectorY = kGridWidth / 2 + kGridWidth * (y - kBoxLength);
        int z = (arc4random() % (2 * (int)kBoxLength - 1));
        CGFloat vectorZ = kGridWidth / 2 + kGridWidth * (z - kBoxLength);
        
        vector = SCNVector3Make(vectorX, vectorY, vectorZ);
        for (MYSnakeItemBox *itemBox in self.snakeItems) {
            if (SCNVector3EqualToVector3(vector, itemBox.position)) {
                isLegalFoodPosition = NO;
                break;
            }
        }
    } while (!isLegalFoodPosition);
    return vector;
}

- (void)refreshFoodPosition {
    SCNVector3 vector = [self getFoodPosition];
    SCNAction *action = [SCNAction moveTo:vector duration:0];
    [self.snakeFood.parentNode runAction:action];
    [self.snakeFood shadowWithDuration:0.1 byNodePosition:vector andNodeLength:kBoxLength];
}

/**
 初始化蛇item
 */
- (void)setupSnake {
    MYSnakeItemBox *preItemBox;
    //TODO: wmy 初始化蛇头
    SCNVector3 vector = SCNVector3Make(1.25, 2.25, 3.25);
    // 需要判定是否在场景内
    for (int i = 0; i < kSnakeInitialCount; i++) {

        MYSnakeItemBox *itemBox = [MYSnakeItemBox snakeItemBox];
        itemBox.position = vector;
        preItemBox.nextItemBox = itemBox;
        itemBox.preItemBox = preItemBox;
        preItemBox = itemBox;
        
        // 改变vector
        if (arc4random() % 2) {
            vector.x += kGridWidth;
        } else {
            vector.y += kGridWidth;
        }
        [self.snakeItems addObject:itemBox];
        if (i == kSnakeInitialCount - 1) {
            self.lastItemBox = itemBox;
        }
    }
    
}

#pragma mark - --------------------UITableViewDelegate--------------
#pragma mark - --------------------CustomDelegate--------------
#pragma mark - --------------------Event Response--------------

- (void)onDrag:(UIPanGestureRecognizer *)recognizer {
    CGPoint point = [recognizer translationInView:self.view];
    NSLog(@"%f,%f",point.x,point.y);
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.beginPoint = point;
    }
    [self commitTranslation:point];
}

/**
 *   判断手势方向
 *
 *  @param translation translation description
 */
- (void)commitTranslation:(CGPoint)translation {
    
    CGFloat absX = fabs(translation.x);
    CGFloat absY = fabs(translation.y);
    
    // 设置滑动有效距离
    if (MAX(absX, absY) < 10)
        return;
    if (translation.x<0) {
        //向左滑动
        NSLog(@"向左滑动");
        [self.snakeNode runAction:[SCNAction rotateByAngle:0.025 aroundAxis:SCNVector3Make(0, -1, 0) duration:0]];
    }else{
        //向右滑动
        NSLog(@"向右滑动");
        [self.snakeNode runAction:[SCNAction rotateByAngle:0.025 aroundAxis:SCNVector3Make(0, 1, 0) duration:0]];
    }
    if (translation.y<0) {
        //向上滑动
        NSLog(@"向上滑动");
        [self.snakeNode runAction:[SCNAction rotateByAngle:0.025 aroundAxis:SCNVector3Make(-1, 0, 0) duration:0]];
    }else{
        //向下滑动
        NSLog(@"向下滑动");
        [self.snakeNode runAction:[SCNAction rotateByAngle:0.025 aroundAxis:SCNVector3Make(1, 0, 0) duration:0]];
    }
}

- (void)onClickTap:(UIGestureRecognizer *)recognizer {
    if (!self.isPlaying) {
        self.isPlaying = YES;
    }
    if ([recognizer.view isEqual:self.threeDscnView]) {
         CGPoint point = [recognizer locationInView:self.threeDscnView];
        NSArray<SCNHitTestResult *> *results = [self.threeDscnView hitTest:point options:nil];
        SCNHitTestResult *result = results.firstObject;
        if (result) {
            SCNPlane *plane = (SCNPlane*)result.node.geometry;
            if ([plane isKindOfClass:[SCNPlane class]]) {
                if ([plane isEqual:self.bottomPlane]) {
                    self.currentDirection = MYCurrentDirectionBottom;
                }
                if ([plane isEqual:self.topPlane]) {
                    self.currentDirection = MYCurrentDirectionTop;
                }
                if ([plane isEqual:self.leftPlane]) {
                    self.currentDirection = MYCurrentDirectionLeft;
                }
                if ([plane isEqual:self.rightPlane]) {
                    self.currentDirection = MYCurrentDirectionRight;
                }
                if ([plane isEqual:self.forePlane]) {
                    self.currentDirection = MYCurrentDirectionFore;
                }
                if ([plane isEqual:self.backPlane]) {
                    self.currentDirection = MYCurrentDirectionBack;
                }
            }
        }
        [self onTimer];
    }
}

/**
 后移一格
 */
- (void)singleStepBack {
    [self actionfollowSnakeItem];
    [self moveSnakeHead:SCNVector3Make(0 , 0, - kGridWidth)];
}

- (void)moveSnakeHead:(SCNVector3)diffVector {
    MYSnakeItemBox *box = self.headItemBox;
    SCNVector3 vector = box.position;
    SCNVector3 newVector = SCNVector3Make(vector.x + diffVector.x , vector.y + diffVector.y, vector.z + diffVector.z);
    SCNNode *node = box.parentNode;
    SCNAction *action = [SCNAction moveTo:newVector duration:0.5];
    [node runAction:action];
    box.position = newVector;
    [box shadowWithDuration:kAnimationDuration byNodePosition:newVector andNodeLength:kBoxLength];
    BOOL isAlive = [self checkIsALive];
    if (!isAlive) {
        [self failGame];
    }
}

- (void)failGame {
    self.isPlaying = NO;
    //弹出页面
    [self pushRestartPage];
}

/**
 弹出重新开始页面
 */
- (void)pushRestartPage {
    //TODO: wmy
    self.pageView.alpha = 0;
    self.pageView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.pageView.alpha = 1;
    }];
}

- (void)restart {
    //TODO: wmy 重新开始
    
}

/**
 确认蛇是否存活
 */
- (BOOL)checkIsALive {
    //1. 蛇头是否在蛇身体内
    BOOL isInSnakeBody = [self checkHeadIsInSnakeBody];
    //2. 蛇头是否到了边界
    BOOL isExceedEdge = [self checkHeadIsExceedEdge];
    return !isInSnakeBody && !isExceedEdge;
}

/**
 是否越过边界
 */
- (BOOL)checkHeadIsExceedEdge {
    MYSnakeItemBox *firstBox = self.headItemBox;
    if (fabsf(firstBox.position.x) < kBoxLength / 2 &&
        (fabsf(firstBox.position.y) < kBoxLength / 2 )&&
        fabsf(firstBox.position.z) < kBoxLength / 2) {
        return NO;
    }
    return YES;
}

- (BOOL)checkHeadIsInSnakeBody {
    MYSnakeItemBox *firstBox = self.headItemBox;
    for (int i = 1; i < self.snakeItems.count; i++) {
        MYSnakeItemBox *box = [self.snakeItems objectAtIndex:i];
        if (SCNVector3EqualToVector3(firstBox.position, box.position)) {
            return YES;
        }
    }
    return NO;
}

/**
 是否吃到了
 */
- (BOOL)checkCanEat {
    MYSnakeItemBox *itemBox = self.headItemBox;
    if (SCNVector3EqualToVector3(itemBox.position, self.snakeFood.parentNode.position)) {
        return YES;
    }
    return NO;
}

/**
 前移一格
 */
- (void)singleStepFore {
    [self actionfollowSnakeItem];
    [self moveSnakeHead:SCNVector3Make(0, 0, kGridWidth)];
}

- (void)actionfollowSnakeItem {
    MYSnakeItemBox *lastItemBox = [self.snakeItems objectAtIndex:self.snakeItems.count - 1];
    self.lastVector = lastItemBox.position;
    for (int i = (int)self.snakeItems.count - 1; i >0 ; i--) {
        MYSnakeItemBox *followBox = [self.snakeItems objectAtIndex:i];
        SCNNode *node = followBox.parentNode;
        SCNAction *action = [SCNAction moveTo:followBox.preItemBox.position duration:0.5];
        [node runAction:action];
        followBox.position = followBox.preItemBox.position;
        // shadow
        [followBox shadowWithDuration:kAnimationDuration byNodePosition:followBox.position andNodeLength:kBoxLength];
    }
}

/**
 右移一格
 */
- (void)singleStepRight {
    [self actionfollowSnakeItem];
    [self moveSnakeHead:SCNVector3Make(kGridWidth, 0, 0)];
}

/**
 左移一格
 */
- (void)singleStepLeft {
    [self actionfollowSnakeItem];
    [self moveSnakeHead:SCNVector3Make(-kGridWidth, 0, 0)];
}


/**
 下降一格
 */
- (void)singleStepBottom {
    [self actionfollowSnakeItem];
    [self moveSnakeHead:SCNVector3Make(0, -kGridWidth, 0)];
}

/**
 上升一格
 */
- (void)singleStepTop {
    [self actionfollowSnakeItem];
    [self moveSnakeHead:SCNVector3Make(0, kGridWidth, 0)];
}

- (void)addNewSnakeItem {
 
    MYSnakeItemBox *itemBox = [MYSnakeItemBox snakeItemBox];
    self.lastItemBox.nextItemBox = itemBox;
    itemBox.preItemBox = self.lastItemBox;
    itemBox.position = self.lastVector;
    
    self.lastItemBox = itemBox;
    SCNNode *node = [SCNNode nodeWithGeometry:itemBox];
    node.position = itemBox.position;
    itemBox.parentNode = node;
    [self.snakeItems addObject:itemBox];
    [self.snakeNode addChildNode:node];
    [self getFoodPosition];
}

#pragma mark - --------------------private methods--------------
#pragma mark - --------------------getters & setters & init members ------------------

- (void)setIsPlaying:(BOOL)isPlaying {
    _isPlaying = isPlaying;
    if (isPlaying && !_timer) {
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.timeStep
                                                              target:self
                                                            selector:@selector(onTimer)
                                                            userInfo:nil
                                                             repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            self.timer = timer;
        });
    } else {
        [self.timer invalidate];
        _timer = nil;
    }
}

- (void)onTimer {
    switch (self.currentDirection) {
        case MYCurrentDirectionTop: {
            [self singleStepTop];
        }
            break;
        case MYCurrentDirectionBack: {
            [self singleStepBack];
        }
            break;
        case MYCurrentDirectionFore: {
            [self singleStepFore];
        }
            break;
        case MYCurrentDirectionBottom: {
            [self singleStepBottom];
        }
            break;
        case MYCurrentDirectionLeft: {
            [self singleStepLeft];
        }
            break;
        case MYCurrentDirectionRight: {
            [self singleStepRight];
        }
            break;
        default:
            break;
    }
    BOOL isEat = [self checkCanEat];
    if (isEat) {
        [self addNewSnakeItem];
        [self refreshFoodPosition];
    }
}

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
        SCNNode *bottomNode = [_threeScene.rootNode childNodeWithName:@"bottomPlane" recursively:YES];
        self.bottomNode = bottomNode;
        self.snakeNode = [_threeScene.rootNode childNodeWithName:@"snakeNode" recursively:YES];
        
        SCNNode *topNode = [_threeScene.rootNode childNodeWithName:@"topPlane" recursively:YES];
        self.topNode = topNode;
        
        SCNNode *backNode = [_threeScene.rootNode childNodeWithName:@"backPlane" recursively:YES];
        self.backNode = backNode;
        
        SCNNode *leftNode = [_threeScene.rootNode childNodeWithName:@"leftPlane" recursively:YES];
        self.leftNode = leftNode;
        
        SCNNode *foreNode = [_threeScene.rootNode childNodeWithName:@"forePlane" recursively:YES];
        self.foreNode = foreNode;
        
        SCNNode *rightNode = [_threeScene.rootNode childNodeWithName:@"rightPlane" recursively:YES];
        self.rightNode = rightNode;
        
        SCNNode *cameraNode = [_threeScene.rootNode childNodeWithName:@"camera" recursively:YES];
        self.cameraNode = cameraNode;
        
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
        UITapGestureRecognizer *sceneTap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                  action:@selector(onClickTap:)];
        sceneTap.numberOfTapsRequired = 1;
        sceneTap.numberOfTouchesRequired = 1;
        [_threeDscnView addGestureRecognizer:sceneTap];
        
//        UIPanGestureRecognizer *dragTap = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onDrag:)];
//        [_threeDscnView addGestureRecognizer:dragTap];
        
        _threeDscnView.scene = self.threeScene;
        _threeDscnView.backgroundColor = [UIColor grayColor];
        _threeDscnView.allowsCameraControl = YES;
        _threeDscnView.showsStatistics = YES;
        _threeDscnView.autoenablesDefaultLighting = YES;
        _threeDscnView.playing = YES;
        
    }
    return _threeDscnView;
}

- (MYRestartView *)pageView {
    //TODO: wmy
    if (_pageView) {
        _pageView = [[MYRestartView alloc] init];
        [_pageView setTextName:@"欢迎欢迎\n点击任意一个面开始游戏"];
        [_pageView setButtonName:@"进入游戏"];
        __block ViewController *weakSelf = self;
        _pageView.clickBlock = ^{
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.pageView.alpha = 0;
            } completion:^(BOOL finished) {
                weakSelf.pageView.hidden = YES;
            }];
        };
    }
    return _pageView;
}

@end
