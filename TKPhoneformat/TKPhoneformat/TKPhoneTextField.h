//
//  TKPhoneTextField.h
//  TKPhoneTextFieldDemo
//  Created by Yang on 2017/9/18.
//  Copyright © 2017年 YangLaoshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKPhoneTextField : UITextField<UITextFieldDelegate>
{
    NSString    *_previousTextFieldContent;
    UITextRange *_previousSelection;
}
@end
