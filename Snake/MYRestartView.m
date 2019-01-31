//
//  MYRestartView.m
//  Snake
//
//  Created by 明妍 on 2019/1/31.
//  Copyright © 2019 明妍. All rights reserved.
//

#import "MYRestartView.h"
#import <Masonry/Masonry.h>

@interface MYRestartView ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIButton *clickButton;

@property (nonatomic, strong) UIView *backgroundView; /**< 背景颜色  */

@end

@implementation MYRestartView

#pragma mark - --------------------dealloc ------------------
#pragma mark - --------------------life cycle--------------------

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    [self addSubview:self.backgroundView];
    self.backgroundView.backgroundColor = [UIColor lightGrayColor];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.height.equalTo(self).offset(-100);
        make.center.equalTo(self);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initView];
}
#pragma mark - --------------------UITableViewDelegate--------------
#pragma mark - --------------------CustomDelegate--------------
#pragma mark - --------------------Event Response--------------

- (void)setTextName:(NSString *)textName {
    self.textLabel.text = textName;
}

- (void)setButtonName:(NSString *)buttonName {
    [self.clickButton setTitle:buttonName forState:UIControlStateNormal];
}

#pragma mark - --------------------private methods--------------

- (void)onClickButton {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

#pragma mark - --------------------getters & setters & init members ------------------


- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        [_backgroundView addSubview:self.textLabel];
        [_backgroundView addSubview:self.clickButton];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(100);
            make.centerX.mas_equalTo(self.backgroundView);
        }];
        [self.clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-100);
            make.centerX.mas_equalTo(self.backgroundView);
        }];
        
    }
    return _backgroundView;
}

- (UIButton *)clickButton {
    if (!_clickButton) {
        _clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _clickButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
        [_clickButton addTarget:self action:@selector(onClickButton) forControlEvents:UIControlEventTouchUpInside];
#if DEBUG
        _clickButton.layer.borderWidth = 1;
        _clickButton.layer.borderColor = [UIColor redColor].CGColor;
#endif
    }
    return _clickButton;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.numberOfLines = 0;
#if DEBUG
        _textLabel.layer.borderWidth = 1;
        _textLabel.layer.borderColor = [UIColor redColor].CGColor;
#endif
    }
    return _textLabel;
}

@end
