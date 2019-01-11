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
    
    enum GameStatus {
        case play,over,stop//游戏中,游戏结束,游戏暂停
    }

    private lazy var label = SKLabelNode.init(text: "Game Over")
    private var oneself: SKSpriteNode?
    private var bgNode: SKSpriteNode?
    private lazy var atlas = SKTextureAtlas.init(named: "scene")
    private(set) lazy var gameStatus:GameStatus = .play
    
    private lazy var enemyFlag:UInt32 = 0x01 << 1
    private lazy var oneselfFlag: UInt32 = 0x01 << 2
    private lazy var bulletFlag: UInt32 =  0x01 << 3
    
    override func didMove(to view: SKView) {
        //
        oneself = SKSpriteNode.init(texture: atlas.textureNamed("airplane"))
        bgNode = SKSpriteNode.init(texture: atlas.textureNamed("bg"))
        let subs: [SKNode] = [bgNode!,oneself!]
        subs.forEach { (node) in
            addChild(node)
        }
        layoutSubs()
    }
    
    private func layoutSubs(){
        let midx = view!.bounds.size.width / 2
        let midBottom = CGPoint.init(x: midx, y: oneself!.size.height)
        oneself!.position = midBottom
        let body = SKPhysicsBody.init(rectangleOf: oneself!.size)
        body.isDynamic = false
        body.categoryBitMask = oneselfFlag
        body.contactTestBitMask = enemyFlag
        oneself!.physicsBody = body
        
        bgNode!.position = CGPoint.zero
        bgNode!.anchorPoint = CGPoint.zero
        bgNode!.size = view!.bounds.size

        let pword = SKPhysicsBody.init(edgeLoopFrom: view!.bounds)
        self.physicsBody = pword
        self.physicsWorld.contactDelegate = self
    }
    
    //创建敌方飞机
    private var enemyTimer: Timer?
    private func invade(){
        enemyTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    @objc func createEnemy(){
        guard gameStatus == .play else {
            return
        }
        let top = view!.bounds.size.height
        let enemy = SKSpriteNode.init(texture: atlas.textureNamed("enemy_low"))
        enemy.name = "enemy"
        addChild(enemy)
        let max = view!.bounds.size.width - enemy.size.width / 2
        let min = enemy.size.width / 2
        let random = arc4random() % UInt32((max - min) + min)
        
        let midTop = CGPoint.init(x: CGFloat(random), y: top - enemy.size.height)
        enemy.position = midTop
        let body = SKPhysicsBody.init(rectangleOf: enemy.size)
        body.affectedByGravity = false
        body.categoryBitMask = enemyFlag
        body.contactTestBitMask = oneselfFlag | bulletFlag
        enemy.physicsBody = body
        let bottom = CGPoint.init(x: CGFloat(random), y: 0)
        let move = SKAction.move(to: bottom, duration: 1)
        let remove = SKAction.removeFromParent()
        enemy.run(SKAction.sequence([move,remove]))
    }
    
    //创建子弹
    private var bulletTimer: Timer?
    private func fire(){
        bulletTimer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(createBullet), userInfo: nil, repeats: true)
    }
    @objc func createBullet(){
        guard gameStatus == .play else {
            return
        }
        let bullet = SKSpriteNode.init(texture: atlas.textureNamed("bullet"))
        bullet.name = "bullet"
        let max = view!.bounds.size.width - bullet.size.width / 2
        let min = bullet.size.width / 2
        let random = arc4random() % UInt32((max - min) + min)
        let top = CGPoint.init(x: CGFloat(random), y: view!.bounds.height)
        let x = oneself!.position.x
        let y = oneself!.position.y
        bullet.position = CGPoint.init(x: x, y: y)
        bullet.anchorPoint = CGPoint.init(x: 0.5, y: 0)
        bullet.size = CGSize.init(width: 20, height: 40)
        let move = SKAction.move(to: top, duration: 1)
        let remove = SKAction.removeFromParent()
        bullet.run(SKAction.sequence([move,remove]))
        
        let body = SKPhysicsBody.init(rectangleOf: bullet.size)
        body.categoryBitMask = bulletFlag
        body.contactTestBitMask = enemyFlag
        body.isDynamic = false
        bullet.physicsBody = body
        
        addChild(bullet)
    }
    
    //游戏结束
    private func gameOver(){
        gameStatus = .over
        if let feture = Calendar.current.date(byAdding: Calendar.Component.year, value: 1, to: Date()) {
            enemyTimer?.fireDate = feture
            bulletTimer?.fireDate = feture
        }
        children.forEach { (node) in
            if node.name == "bullet" ||  node.name == "enemy" {
                node.removeAllActions()
                node.removeFromParent()
            }
        }
        
        addChild(label)
        label.position = CGPoint.init(x: view!.bounds.width / 2, y: view!.bounds.height / 2)
        
//        let scene = GameOver()
//        let point = CGPoint.init(x: view!.bounds.width / 2, y: view!.bounds.height / 2)
//        scene.frame = CGRect.init(origin: point, size: CGSize.init(width: 128, height: 128))
//        view!.presentScene(scene)
        
    }
    private func gameStart(){
        let date = Date()
        if enemyTimer == nil {
            invade()
        }
        if bulletTimer == nil {
            fire()
        }
        enemyTimer?.fireDate = date
        bulletTimer?.fireDate = date
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        createEnemy()
    }
    
    //SKPhysicsContactDelegate  碰撞相关
    func didBegin(_ contact: SKPhysicsContact) {
        let flag = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch flag {
        case oneselfFlag | enemyFlag:
            //
            print("飞机撞到自己了 game over")
            gameOver()
        case bulletFlag | enemyFlag:
            print("子弹打到飞机了")
            clearNode(contact)
        default:
            print("默认")
            break
        }
    }
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
    //清楚node
    private func clearNode(_ contact: SKPhysicsContact){
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        nodeA?.removeAllActions()
        nodeA?.removeFromParent()
        nodeB?.removeAllActions()
        nodeB?.removeFromParent()
    }

    deinit {
        bulletTimer?.invalidate()
        bulletTimer = nil
        enemyTimer?.invalidate()
        enemyTimer = nil
    }
}
