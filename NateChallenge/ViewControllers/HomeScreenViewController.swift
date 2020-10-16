//
//  HomeScreenViewController.swift
//  NateChallenge
//
//  Created by Stephen Sement on 10/10/2020.
//

import UIKit
import CocoaLumberjack

final class HomeScreenViewController: UIViewController {

    private weak var coordinator: MainCoordinator?
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let productListView = UITableView()
    private let searchBar = UISearchBar()
    private let refreshControl = UIRefreshControl()
    private var errorView = ErrorView()
    private var productListDataSource: ProductListDataSource?

    private var isSearching = false
    private var currentSkip = 0
    private var defaultTake = 20

    init(coordinator: Coordinator, productListDataSource: ProductListDataSource) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator as? MainCoordinator
        self.productListDataSource = productListDataSource
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        refreshControl.beginRefreshing()
        requestNextProductBatch(skip: currentSkip, take: defaultTake) {
            DispatchQueue.main.async { [weak self] in
                self?.productListView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        DispatchQueue.main.async { [weak self] in
            self?.productListView.reloadData()
        }
    }

}

// MARK: UI Setup
private extension HomeScreenViewController {

    func setupViews() {
        configureSelf()
        configureLoadingIndicator()
        configureSearchBar()
        configureProductListView()
        configureRefreshControl()
        configureErrorView()

        layoutLoadingIndicator()
        layoutSearchBar()
        layoutProductListView()
        layoutErrorView()
    }

    // MARK: Configurations
    func configureSelf() {
        view.backgroundColor = .white
    }

    func configureLoadingIndicator() {
        view.prepareSubviewsForAutolayout(loadingIndicator)
        loadingIndicator.startAnimating()
    }

    func configureSearchBar() {
        view.prepareSubviewsForAutolayout(searchBar)
        searchBar.delegate = self
        searchBar.showsCancelButton = true
    }

    func configureErrorView() {
        view.prepareSubviewsForAutolayout(errorView)
        errorView.setRefreshButtonTarget(target: self, action: #selector(tapRefreshButton), for: .touchUpInside)
        errorView.isHidden = true
    }

    func configureProductListView() {
        view.prepareSubviewsForAutolayout(productListView)
        productListView.delegate = self
        productListView.dataSource = productListDataSource
        productListView.register(ProductCell.self, forCellReuseIdentifier: "ProductCell")
        productListView.refreshControl = refreshControl
        productListView.isHidden = true
    }

    func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshProductList), for: .valueChanged)
    }

    // MARK: Layouts
    func layoutLoadingIndicator() {
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func layoutSearchBar() {
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }

    func layoutErrorView() {
        view.applyFullConstraints(to: errorView, withSafeAreas: true)
    }

    func layoutProductListView() {
        NSLayoutConstraint.activate([
            productListView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            productListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: Internal Methods
extension HomeScreenViewController {

    func requestNextProductBatch(skip: Int, take: Int, completion: @escaping () -> Void) {
        productListDataSource?.loadProductBatch(skip: skip, take: take) { success in
            switch success {
            case true:
                DispatchQueue.main.async { [weak self] in                    self?.errorView.isHidden = true
                    self?.productListView.isHidden = false
                    self?.currentSkip += take
                }
            case false:
                self.errorView.isHidden = false
                self.productListView.isHidden = true
            }
            completion()
        }
    }

}

// MARK: UITableView Delegate
extension HomeScreenViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath) as? ProductCell
        if let product = cell?.getProduct() {
            DDLogDebug("Selected cell with title: \(product.title)")
            coordinator?.showProductDetails(for: product)
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let dataSource = productListDataSource else { return }
        guard !isSearching else { return }
        if indexPath.row == currentSkip - defaultTake,
           dataSource.getCurrentProductCount() - currentSkip == 0 {
            requestNextProductBatch(skip: currentSkip, take: defaultTake) {
                DispatchQueue.main.async { [weak self] in
                    self?.productListView.reloadData()
                }
            }
        }
    }

}

// MARK: UISearchBar Delegate
extension HomeScreenViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        productListDataSource?.unfilterProducts()
        productListDataSource?.filterProductsWith(text: searchBar.text ?? "")
        self.productListView.reloadData()
        isSearching = false
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        productListDataSource?.unfilterProducts()
        productListDataSource?.filterProductsWith(text: searchText)
        self.productListView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        productListDataSource?.unfilterProducts()
        self.productListView.reloadData()
        isSearching = false
    }

}

// MARK: Selectors
private extension HomeScreenViewController {

    @objc func refreshProductList() {
        currentSkip = 0
        productListDataSource?.clearProductsList()
        requestNextProductBatch(skip: currentSkip, take: defaultTake) {
            DispatchQueue.main.async { [weak self] in
                self?.productListView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
    }

    @objc func tapRefreshButton() {
        errorView.isHidden = true
        productListView.isHidden = true
        requestNextProductBatch(skip: currentSkip, take: defaultTake) {
            DispatchQueue.main.async { [weak self] in
                self?.productListView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }

    }

}
