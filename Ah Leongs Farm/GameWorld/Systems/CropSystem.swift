import GameplayKit

class CropSystem: GKComponentSystem<CropComponent> {

    override init() {
        super.init(componentClass: CropComponent.self)
    }
}
