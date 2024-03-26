//
//  DetailView.swift
//
//  Created by Claudio Marciello on 23/03/24.
//

import UIKit

class DetailView: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @objc func handleCellTap(_ gestureRecognizer: UITapGestureRecognizer) {
        
        guard let cell = gestureRecognizer.view as? ColorCell,
              let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        
        
        // Perform necessary actions when a cell is tapped
        print("Selected cell at indexPath: \(indexPath)")
        newColor = cell.color
        
        print("old: \(noteView.backgroundColor)")
        print(newColor)
        noteView.backgroundColor = UIColor(named: newColor!)
        print("new: \(noteView.backgroundColor)")


        view.setNeedsDisplay()
        view.layoutIfNeeded()
        overlayView.isHidden=true

    }
    
    @IBAction func closeButton(_ sender: Any) {
        overlayView.isHidden = true
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ColorCell
        
        cell.color = "green"

        
        // Add the tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCellTap(_:)))
        cell.addGestureRecognizer(tapGesture)
                
        
        return cell
        
    }
    

    var note: Note?
    
    @IBOutlet weak var overlayView: UIVisualEffectView!
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var colorButton: UIButton!

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var Save: UIBarButtonItem!
    var newSize: Float?
    var newColor: String?
    required init?(coder: NSCoder, note: Note?) {
        self.note = note
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        newColor = note?.color
        textView.text = note?.name
        textView.textColor = note?.fontColor
        textView.font = UIFont.systemFont(ofSize: CGFloat(note!.fontSize))
        textView.backgroundColor = UIColor(named: note!.color)
        
        

        noteView.backgroundColor = UIColor(named: note!.color)
        // Do any additional setup after loading the view.
        noteView.layer.cornerRadius = 12
        noteView.layer.masksToBounds = true

        collectionView.delegate = self
           collectionView.dataSource = self
    }
    
    @IBOutlet weak var backButton: UINavigationItem!
    
    @IBAction func changeColorButton(_ sender: Any) {
        overlayView.isHidden = false
        
    }
    
    @IBAction func fontButtonAction(_ sender: Any) {
        if newSize == nil{
            note?.fontSize = 32
        }
        if newSize == 32{
            newSize = 18}
        else {
            newSize = 32}
        // Update textView font size
        textView.font = UIFont.systemFont(ofSize: CGFloat(newSize!))
          
          // Refresh textView display
          textView.setNeedsDisplay()

    }
    
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, sender: Any?) -> Bool {
        true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare")
        note?.name = textView.text!
        note?.fontSize = Float((newSize ?? note?.fontSize)!)
        print(note?.color)
        note?.color = newColor!
        print(note?.color)

        guard segue.identifier == "backSegue" else { return }

    }
    override func didMove(toParent parent: UIViewController?) {
        if !(parent?.isEqual(self.parent) ?? false) {
            print("Parent view loaded")
        }
        super.didMove(toParent: parent)
    }
    


}
