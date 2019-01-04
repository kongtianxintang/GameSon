/***********************************************************
 * 版权所有 liwei
 * Copyright(C),2019,liwei
 * project:
 * Author:
 * Date:  2019/01/04
 * QQ/Tel/Mail:
 * Description:飞机大战-主界面
 * Others:
 * Modifier:
 * Reason:
 *************************************************************/
import UIKit
import SpriteKit

class MainScene: SKScene,SKPhysicsContactDelegate{

    private var oneself: SKSpriteNode?
    private var bullet: SKSpriteNode?
    private var enemyLow: SKSpriteNode?
    private var enemyMid: SKSpriteNode?
    private lazy var atlas = SKTextureAtlas.init(named: "scene")
    
    override func didMove(to view: SKView) {
        //
        oneself = SKSpriteNode.init(texture: atlas.textureNamed("airplane"))
        bullet = SKSpriteNode.init(texture: atlas.textureNamed("bullet"))
        enemyLow = SKSpriteNode.init(texture: atlas.textureNamed("enemy_low"))
        enemyMid = SKSpriteNode.init(texture: atlas.textureNamed("enemy_mid"))
        let subs: [SKNode] = [oneself!,bullet!,enemyMid!,enemyLow!]
        subs.forEach { (node) in
            addChild(node)
        }
        layoutSubs()
    }
    
    private func layoutSubs(){
        let midx = view!.bounds.size.width / 2
        let top = view!.bounds.size.height
        
        let midBottom = CGPoint.init(x: midx, y: oneself!.size.height)
        oneself!.position = midBottom
        
        
        let midTop = CGPoint.init(x: midx, y: top)
        enemyLow!.position = midTop
        let rotate = SKAction.rotate(byAngle: .pi, duration: 0)
        enemyLow!.run(rotate)
        
        
        self.physicsBody = SKPhysicsBody.init(edgeLoopFrom: view!.bounds)
        self.physicsWorld.contactDelegate = self
    }
    
    private func actions(){
        let midx = view!.bounds.size.width / 2
        let top = view!.bounds.size.height
        let enemy = SKSpriteNode.init(texture: atlas.textureNamed("enemy_low"))
        addChild(enemy)
        let midTop = CGPoint.init(x: midx, y: top - enemy.size.height)
        enemy.position = midTop
        let body = SKPhysicsBody.init(rectangleOf: enemy.size)
        
        enemy.physicsBody = body
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        actions()
    }
    
    //SKPhysicsContactDelegate  碰撞相关
    func didBegin(_ contact: SKPhysicsContact) {
        
    }
    func didEnd(_ contact: SKPhysicsContact) {
        contact.bodyA.node?.removeFromParent()
        contact.bodyB.node?.removeFromParent()
    }
    
}
