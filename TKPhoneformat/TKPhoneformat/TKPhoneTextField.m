//
//  TKPhoneTextField.m
//  TKPhoneTextFieldDemo
//  Created by Yang on 2017/9/18.
//  Copyright © 2017年 YangLaoshi. All rights reserved.
//

#import "TKPhoneTextField.h"

// 设置RGB颜色
#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

@implementation TKPhoneTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.leftViewMode = UITextFieldViewModeAlways;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.backgroundColor = [UIColor whiteColor];
        self.textColor = RGB(51,51,51);
        [self addTarget:self action:@selector(reformatAsPhoneNumber:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self addTarget:self action:@selector(reformatAsPhoneNumber:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}
#pragma mark --- Events
-(void)reformatAsPhoneNumber:(UITextField *)textField {
    /**
     *  判断正确的光标位置
     */
    NSUInteger targetCursorPostion = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
    
    NSString *phoneNumberWithoutSpaces = [self removeNonDigits:textField.text andPreserveCursorPosition:&targetCursorPostion];//返回去掉非数字的字符串 光标位置自适应变化
    if([phoneNumberWithoutSpaces length] == 11){
        _previousTextFieldContent = textField.text;//保存长度为11时候的字符串
        _previousSelection = textField.selectedTextRange;
    }
    if([phoneNumberWithoutSpaces length]>11) {
        /**
         *  避免超过11位的输入
         */
        [textField setText:_previousTextFieldContent];
        textField.selectedTextRange = _previousSelection;
        return;
    }
    //在第3个位置和第7个位置插入空格(" ")  光标位置自适应变化
    NSString *phoneNumberWithSpaces = [self insertSpacesEveryFourDigitsIntoString:phoneNumberWithoutSpaces andPreserveCursorPosition:&targetCursorPostion];
    //填充到textField中
    textField.text = phoneNumberWithSpaces;
    
    //经过删减重新从  文首计算出到光标的偏移数值。
    UITextPosition *targetPostion = [textField positionFromPosition:textField.beginningOfDocument offset:targetCursorPostion];
    [textField setSelectedTextRange:[textField textRangeFromPosition:targetPostion toPosition:targetPostion]];
}
/**
 *  除去非数字字符，重新确定光标正确位置
 *
 *  @param string         当前的string
 *  @param cursorPosition 光标位置 (传入的是指针变量   目的是可以修改外部变量)
 *
 *  @return 处理过后的string
 */
- (NSString *)removeNonDigits:(NSString *)string andPreserveCursorPosition:(NSUInteger *)cursorPosition {
    
    NSUInteger originalCursorPosition = *cursorPosition;
    NSMutableString *digitsOnlyString = [NSMutableString new];
    
    for (NSUInteger i=0; i<string.length; i++) {
        unichar characterToAdd = [string characterAtIndex:i];
        if(isdigit(characterToAdd)) {//判断是否为数字，拼接字符串
            NSString *stringToAdd = [NSString stringWithCharacters:&characterToAdd length:1];
            [digitsOnlyString appendString:stringToAdd];
        }
        else {//不为数字的话  光标位置减一
            if(i<originalCursorPosition) {
                (*cursorPosition)--;
            }
        }
    }
    return digitsOnlyString;
}

/**
 *  将空格插入我们现在的string 中，并确定我们光标的正确位置，防止在空格中
 *
 *  @param string         当前的string
 *  @param cursorPosition 光标位置(传入的是指针变量   目的是可以修改外部变量)
 *
 *  @return 处理后有空格的string
 */
- (NSString *)insertSpacesEveryFourDigitsIntoString:(NSString *)string andPreserveCursorPosition:(NSUInteger *)cursorPosition{
    NSMutableString *stringWithAddedSpaces = [NSMutableString new];
    NSUInteger cursorPositionInSpacelessString = *cursorPosition;// 光标位置
    for (NSUInteger i=0; i<string.length; i++) {
        if(i>0)
        {
            if(i==3 || i==7) {
                [stringWithAddedSpaces appendString:@" "];
                
                if(i<cursorPositionInSpacelessString) {//光标后移
                    (*cursorPosition)++;
                }
            }
        }
        
        unichar characterToAdd = [string characterAtIndex:i];
        NSString *stringToAdd = [NSString stringWithCharacters:&characterToAdd length:1];
        [stringWithAddedSpaces appendString:stringToAdd];
    }
    return stringWithAddedSpaces;
}

@end
