//
//  ViewController.swift
//  CoreDataTask
//
//  Created by Лада on 22/11/2019.
//  Copyright © 2019 Лада. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let tableView = UITableView()
    var images: [ImageViewModel] = []
    var data: [OneImage] = []
    let reuseId = "UITableViewCellreuseId"
    let interactor: InteractorInput
    var coreDataManager = CoreDataManager()
    let loadButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.setTitle("Load images", for: .normal)
        button.addTarget(self, action: #selector(search), for: .touchDown)
        return button
    }()
    
    init(interactor: InteractorInput) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("Метод не реализован")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coreDataManager.context = coreDataManager.persistentContainer.viewContext
        data = coreDataManager.fetchData()

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        tableView.dataSource = self
        tableView.delegate = self

        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        loadButton.frame = CGRect(x: view.frame.width/3, y: 0, width: view.frame.width/3, height: tableView.tableHeaderView!.frame.height)
        tableView.tableHeaderView?.addSubview(loadButton)

    }
    
    @objc private func search() {
        let searchString = "cat"
        interactor.loadImageList(by: searchString) { [weak self] models in
            self?.loadImages(with: models)
        }
    }
    
    private func convertDara(index: Int)-> ImageViewModel {
        
        let dataModel = data[index]
        let image = UIImage(data: dataModel.image as Data, scale: 0.01)
        let imageModel = ImageViewModel(descrip: dataModel.name ?? "", image: image!)
        
        return imageModel
    }
    
    private func loadImages(with models: [ImageModel]) {

        let group = DispatchGroup()
        for model in models {
            group.enter()
            interactor.loadImage(at: model.path) { [weak self] image in
                guard let image = image else {
                    group.leave()
                    return
                }
                let viewModel = ImageViewModel(descrip: model.description,
                                               image: image)
                self?.images.append(viewModel)
                group.leave()
            }
            
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.tableView.reloadData()
            self.saveImages(images: self.images)
            
        }
    }
    
    func saveImages(images: [ImageViewModel]) {
        for image in images {
            self.coreDataManager.saveContext(image: image)
        }
        print("данные загружены")
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let count = try coreDataManager.context.count(for: coreDataManager.request)
            return count
        } catch {
            print("Error for loading context.count")
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        cell.imageView?.image = UIImage(named: "load")
        cell.textLabel?.text = "Изображение загружается"
        DispatchQueue.main.async {
            let data = self.convertDara(index: indexPath.row)
            cell.imageView?.image = data.image
            cell.textLabel?.text = data.descrip
        }
  
        return cell
    }
}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let newView = PictureView()
        newView.data = data[indexPath.row]
        navigationController?.pushViewController(newView, animated: true)

    }
}
