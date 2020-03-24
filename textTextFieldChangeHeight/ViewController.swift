//
//  ViewController.swift
//
//  Created by 宏輝 on 03/01/2020.
//  Copyright © 2020 宏輝. All rights reserved.
//




//TextFieldがキーボードの高さに応じて変更するコード
//しかし、文字を入力した途端にTextFieldが隠れてしまう。
//サンプルアプリからの差分はAutoLayOut
import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    
    let communicationTextField = QSTextField()
    let postCommentButton = UIButton()
    
    //ツールバーの設定
    let toolbar = UIToolbar()
    
    let screenSize = UIScreen.main.bounds.size
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureToolbar()
        communicationTextField.delegate = self
        configureTextFieldAndPostCommunicationButton()
        
        
        
        // MARK: - キーボードの可変コード    //キーボードが出てきたときに、textField、送信ボタンが同時に上にスライドするコード
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        //キーボードが閉じる時に、textFieldの高さが可変になるもの。
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        
    }
    
    func configureTextFieldAndPostCommunicationButton() {
        
        view.addSubview(communicationTextField)
        view.addSubview(postCommentButton)
        communicationTextField.delegate = self
        
        communicationTextField.translatesAutoresizingMaskIntoConstraints = false
        postCommentButton.translatesAutoresizingMaskIntoConstraints = false
        
        postCommentButton.addTarget(self, action: #selector(postComment), for: .touchUpInside)
        
        let padding:CGFloat = 10
        
        NSLayoutConstraint.activate([
            communicationTextField.bottomAnchor.constraint(equalTo: toolbar.topAnchor,constant: -padding),
            communicationTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            communicationTextField.trailingAnchor.constraint(equalTo: postCommentButton.leadingAnchor, constant: -padding),
            communicationTextField.heightAnchor.constraint(equalToConstant: 50),
            
            postCommentButton.bottomAnchor.constraint(equalTo: toolbar.topAnchor,constant: -padding),
            postCommentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            postCommentButton.widthAnchor.constraint(equalToConstant: 50),
            postCommentButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureToolbar() {
        view.addSubview(toolbar)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        //戻るボタンの実装
        let backButton = UIButton(frame: CGRect(x: 0, y:0, width: 100, height: 100))
        backButton.setTitle("Close", for: .normal)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        let backButtonItem = UIBarButtonItem(customView: backButton)
        
        //ボタンを左右に分けるためのスペースの実装
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // ツールバーにアイテムを追加する.
        toolbar.items = [backButtonItem,flexibleItem]
        
        
        NSLayoutConstraint.activate([
            toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolbar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    // 戻るボタンをクリックした時の処理
    @objc func back() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    //postCommentButton(投稿ボタンをクリックした時の処理)
    @objc func postComment() {
        guard let communicationTextFieldText = communicationTextField.text else { return }
        print(communicationTextFieldText)
    }
    
    
    
    
    
    // MARK: - キーボードの可変コード
    @objc func keyboardWillShow(_ notification:NSNotification){
        //キーボードの高さを取得
        let keyboardHeight = ((notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as Any) as AnyObject).cgRectValue.height
        
        
        //上にスライドした後の高さを決めたい。
        // フレームの高さ - キーボードの高さ - messageTextFieldの高さ
        communicationTextField.frame.origin.y = screenSize.height - keyboardHeight - communicationTextField.frame.height
        postCommentButton.frame.origin.y = screenSize.height - keyboardHeight - postCommentButton.frame.height
    }
    
    @objc func keyboardWillHide(_ notifiation:NSNotification){
        
        //下へスライドした後の高さを決めたい。
        //今回はキーボードが消えるので、キーボードの高さは考慮しない。
        //スクリーンの高さ - messageTextFieldの高さ
        communicationTextField.frame.origin.y = screenSize.height - communicationTextField.frame.height
        
        guard let rect = (notifiation.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            
            
            //キーボードが下がる時間をdurationとして取得
            let duration = notifiation.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {return}
        
        UIView.animate(withDuration: duration) {
            let transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.transform = transform
        }
        
    }
    
    
    //画面をタッチした時にキーボードが下がる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        communicationTextField.resignFirstResponder()
    }
    
    //画面をタッチした時にキーボードが下がる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    
    
    
}

