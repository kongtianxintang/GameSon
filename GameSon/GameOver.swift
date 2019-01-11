/***********************************************************
 * 版权所有 liwei
 * Copyright(C),2019,liwei
 * project:
 * Author:
 * Date:  2019/01/11
 * QQ/Tel/Mail:
 * Description:飞机大战-结束界面
 * Others:
 * Modifier:
 * Reason:
 *************************************************************/

import UIKit
import SpriteKit

class GameOver: SKScene {
    
    private lazy var label = SKLabelNode()
    
    override func didMove(to view: SKView) {
        let subs = [label]
        subs.forEach { (item) in
            addChild(item)
        }
        label.text = "game over"
    }

}
