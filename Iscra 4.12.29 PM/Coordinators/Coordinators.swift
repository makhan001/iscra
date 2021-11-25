//
//  Coordinators.swift
//  Clustry
//
//  Created by Mohd Ali Khan on 05/11/2019.
//  Copyright © 2021 m@k. All rights reserved.
//

import Foundation
import UIKit

public protocol Presentable {
    func toPresentable() -> UIViewController
}

extension UIViewController: Presentable {
    public func toPresentable() -> UIViewController {
        return self
    }
}

public protocol RouterType: AnyObject, Presentable {
    var navigationController: NavigationController { get }
    
    var rootViewController: UIViewController? { get }
    func present(_ module: Presentable, animated: Bool)
    func present(_ module: Presentable, animated: Bool,usingDefault: Bool)
    func presentOver(_ module: Presentable, animated: Bool,usingDefault: Bool)
    func presentUpsell(_ module: Presentable, animated: Bool)
    func dismissModule(animated: Bool, completion: (() -> Void)?)
    func push(_ module: Presentable, animated: Bool, completion: (() -> Void)?)
    func popModule(animated: Bool)
    func setRootModule(_ module: Presentable, hideBar: Bool)
    func popToRootModule(animated: Bool)
}

public final class Router: NSObject, RouterType, UINavigationControllerDelegate {
    
    private var completions: [UIViewController: () -> Void]
    
    public var rootViewController: UIViewController? {
        return navigationController.viewControllers.first
    }
    
    public var hasRootController: Bool {
        return rootViewController != nil
    }
    
    public var navigationController: NavigationController
    
    public init(navigationController: NavigationController = NavigationController()) {
        self.navigationController = navigationController
        completions = [:]
        super.init()
        self.navigationController.delegate = self
    }
    
    public func present(_ module: Presentable, animated: Bool = true) {
        let presentingModule = module.toPresentable()
        presentingModule.modalPresentationStyle = .overFullScreen
        navigationController.present(presentingModule, animated: animated, completion: nil)
    }
    
    public func present(_ module: Presentable, animated: Bool = true, usingDefault: Bool = false) {
        let presentingModule = module.toPresentable()
        if !usingDefault {
            presentingModule.modalPresentationStyle = .overFullScreen
        }
        navigationController.present(presentingModule, animated: animated, completion: nil)
    }
    
    public func presentUpsell(_ module: Presentable, animated: Bool = true) {
        
    }
    
    public func presentOver(_ module: Presentable, animated: Bool,usingDefault: Bool) {
        let presentingModule = module.toPresentable()
        presentingModule.modalPresentationStyle = .overCurrentContext
        navigationController.present(presentingModule, animated:animated, completion: nil)
    }
    public func dismissModule(animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController.dismiss(animated: animated, completion: completion)
    }
    
    public func push(_ module: Presentable, animated: Bool = true, completion: (() -> Void)? = nil) {
        let controller = module.toPresentable()
        // Avoid pushing UINavigationController onto stack
        guard controller is UINavigationController == false else {
            return
        }
        
        if let completion = completion {
            completions[controller] = completion
        }
        navigationController.pushViewController(controller, animated: animated)
    }
    
    public func popModule(animated: Bool = true) {
        if let controller = navigationController.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }
    
    public func setRootModule(_ module: Presentable, hideBar: Bool = false) {
        // Call all completions so all coordinators can be deallocated
        completions.forEach { $0.value() }
        navigationController.setViewControllers([module.toPresentable()], animated: false)
        navigationController.isNavigationBarHidden = hideBar
    }
    
    public func popToRootModule(animated: Bool) {
        if let controllers = navigationController.popToRootViewController(animated: animated) {
            controllers.forEach { runCompletion(for: $0) }
        }
    }
    
    fileprivate func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
    
    // MARK: Presentable
    
    public func toPresentable() -> UIViewController {
        return navigationController
    }
    
    // MARK: UINavigationControllerDelegate
    public func navigationController(_ navigationController: UINavigationController, didShow _: UIViewController, animated _: Bool) {
        // Ensure the view controller is popping
        guard let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(poppedViewController) else {
                return
        }
        runCompletion(for: poppedViewController)
    }
}

public protocol BaseCoordinatorType: AnyObject {
    associatedtype DeepLinkType
    func start()
    func start(with link: DeepLinkType?)
}

public protocol PresentableCoordinatorType: BaseCoordinatorType, Presentable {}

open class PresentableCoordinator<DeepLinkType>: NSObject, PresentableCoordinatorType {
    public override init() {
        super.init()
    }
    
    open func start() { start(with: nil) }
    open func start(with scene: DeepLinkType?) {}
    
    open func toPresentable() -> UIViewController {
        fatalError("Must override toPresentable()")
    }
}

public protocol CoordinatorType: PresentableCoordinatorType {
    var router: RouterType { get }
}

class Coordinator<Link>: PresentableCoordinator<Link>, CoordinatorType {
    var router: RouterType
    var childCoordinators: [Coordinator<Link>] = []
    
    init(router: Router) {
        self.router = router
    }
    
    func add(_ child: Coordinator<Link>) {
        if !childCoordinators.contains(child) {
            childCoordinators.append(child)
        }
    }
    
    func remove(child: Coordinator<Link>?) {
        if let child = child, let index = childCoordinators.firstIndex(of: child) {
            childCoordinators.remove(at: index)
        }
    }
    
    override func toPresentable() -> UIViewController {
        return router.toPresentable()
    }
}

public class NavigationController: UINavigationController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
