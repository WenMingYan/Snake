//
//  MYRestartView.h
//  Snake
//
//  Created by 明妍 on 2019/1/31.
//  Copyright © 2019 明妍. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock)(void);

@interface MYRestartView : UIView

@property(nonatomic, copy) ClickBlock clickBlock;

- (void)setTextName:(NSString *)textName;

- (void)setButtonName:(NSString *)buttonName;

@end

