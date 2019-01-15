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
    private lazy var score = SKLabelNode()
    
    override func didMove(to view: SKView) {
        let bg = SKSpriteNode.init(imageNamed: "bg")
        let subs = [bg,label,score]
        subs.forEach { (item) in
            addChild(item)
        }
        
        bg.anchorPoint = CGPoint.zero
        bg.size = view.bounds.size
        label.text = "Game Over"
        score.text = "得分:100"
        score.name = "score"
        
        label.position = CGPoint.init(x: view.bounds.midX, y: view.bounds.midY + 64)
        score.position = view.center
        score.color = SKColor.brown
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: self)
            if let node = nodes(at: point).first {
                if node.name == "score" {
                    let scene = MainScene.init(size: view!.bounds.size)
                    view?.presentScene(scene)
                }
            }
        }
    }
    
    deinit {
        print("测试:销毁不？")
    }
}
