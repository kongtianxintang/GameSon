/***********************************************************
 * 版权所有 liwei
 * Copyright(C),2019,liwei
 * project:
 * Author:
 * Date:  2019/01/04
 * QQ/Tel/Mail:
 * Description:飞机大战
 * Others:
 * Modifier:
 * Reason:
 *************************************************************/

import UIKit
import SpriteKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    private func setupView(){
        guard let sk = view as? SKView else { return }
        sk.showsFPS = true
        sk.showsNodeCount = true
        sk.showsFields = true
        
        let scene = MainScene(size:sk.bounds.size)
        sk.presentScene(scene)
    }

}

