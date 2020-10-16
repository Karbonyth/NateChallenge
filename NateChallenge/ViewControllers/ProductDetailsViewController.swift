//
//  ProductDetailsViewController.swift
//  NateChallenge
//
//  Created by Stephen Sement on 12/10/2020.
//

import UIKit

class ProductDetailsViewController: UIViewController {

    private weak var coordinator: MainCoordinator?
    private var product: Product?

    private let pageView = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    private var pageControl = UIPageControl()
    private var imagesControllers = [UIViewController]()

    private var productDetailsView = ProductDetailsView()

    init(coordinator: Coordinator, product: Product) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator as? MainCoordinator
        self.product = product
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

}

// MARK: UI Setup
private extension ProductDetailsViewController {

    func setupViews() {
        configureSelf()
        configureImagesControllers()
        configurePageView()
        configurePageControl()
        configureProductDetailsView()

        layoutPageView()
        layoutPageControl()
        layoutProductDetailsView()
    }

    // MARK: Configurations
    func configureSelf() {
        view.backgroundColor = .white
        let item = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(tapEditButton))
        navigationItem.rightBarButtonItem = item
    }

    func configureImagesControllers() {
        if let images = product?.images {
            images.forEach { image in
                let vc = UIViewController()
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFit
                vc.view.prepareSubviewsForAutolayout(imageView)
                vc.view.applyFullConstraints(to: imageView)

                if let cachedVersion = ImageCache.shared.imageCache.object(forKey: image as NSString) {
                    imageView.image = cachedVersion
                } else {
                    if let url = URL(string: image) {
                        DispatchQueue.global().async {
                            imageView.load(url: url, completion: {
                                DispatchQueue.main.async {
                                    if imageView.image == nil {
                                        imageView.image = UIImage(named: "no-image")
                                    }
                                }
                            })?.resume()
                        }
                    }
                    imageView.image = UIImage(named: "no-image")
                }
                imagesControllers.append(vc)
            }
        }
    }

    func configurePageView() {
        view.prepareSubviewsForAutolayout(pageView.view)

        pageView.dataSource = self
        pageView.delegate = self

        if imagesControllers.isEmpty {
            let vc = UIViewController()
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            vc.view.prepareSubviewsForAutolayout(imageView)
            vc.view.applyFullConstraints(to: imageView)
            imageView.image = UIImage(named: "no-image")
            imagesControllers.append(vc)
        }

        pageView.setViewControllers([imagesControllers[0]], direction: .forward, animated: true)
    }

    func configurePageControl() {
        pageView.view.prepareSubviewsForAutolayout(pageControl)
        pageControl.addTarget(self, action: #selector(tapPageControl), for: .valueChanged)
        pageControl.numberOfPages = imagesControllers.count
        pageControl.currentPageIndicatorTintColor = UIColor.orange
        pageControl.pageIndicatorTintColor = UIColor.lightGray.withAlphaComponent(0.8)
    }

    func configureProductDetailsView() {
        view.prepareSubviewsForAutolayout(productDetailsView)
        productDetailsView.setProductTitle(with: product?.title)
        productDetailsView.setProductDescription(with: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?")
        productDetailsView.setProductVendor(with: product?.merchant.isEmpty == false ? product?.merchant : "Unknown Merchant")
    }

    // MARK: Layouts
    func layoutPageView() {
        NSLayoutConstraint.activate([
            pageView.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageView.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pageView.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pageView.view.heightAnchor.constraint(equalToConstant: 256)
        ])
    }

    func layoutPageControl() {
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: pageView.view.bottomAnchor),
            pageControl.leadingAnchor.constraint(equalTo: pageView.view.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: pageView.view.trailingAnchor)
        ])
    }

    func layoutProductDetailsView() {
        NSLayoutConstraint.activate([
            productDetailsView.topAnchor.constraint(equalTo: pageView.view.bottomAnchor),
            productDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productDetailsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: UIPageViewController DataSource
extension ProductDetailsViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = imagesControllers.firstIndex(of: viewController) {
            if index > 0 {
                return imagesControllers[index - 1]
            } else {
                return nil
            }
        }

        return nil
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = imagesControllers.firstIndex(of: viewController) {
            if index < imagesControllers.count - 1 {
                return imagesControllers[index + 1]
            } else {
                return nil
            }
        }

        return nil
    }

}

// MARK: UIPageViewController Delegate
extension ProductDetailsViewController: UIPageViewControllerDelegate {

    /// Won't work properly if there are duplicates of a ViewController in the array.
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, let currentViewController = pageViewController.viewControllers?.first,
              let index = imagesControllers.firstIndex(of: currentViewController) else {
            return
        }
        pageControl.currentPage = index
        pageControl.isUserInteractionEnabled = true
    }

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
            pageControl.isUserInteractionEnabled = false
    }
}

// MARK: Selectors
private extension ProductDetailsViewController {

    @objc func tapPageControl() {
        guard let vc = pageView.viewControllers?[0] else { return }
        guard let index = imagesControllers.firstIndex(of: vc) else { return }

        pageView.setViewControllers([imagesControllers[pageControl.currentPage]], direction: (index > pageControl.currentPage ? .reverse : .forward), animated: true)
    }

    @objc func tapEditButton() {
        productDetailsView.toggleEditMode()
    }

}
