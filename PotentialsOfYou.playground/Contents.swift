// This playground creates an interacting environment illustrating the different electric potentials of human bodies, from which the app gets its name.
// When you performs different activities, your body responds to the outside world by giving out electric potentials.
// Therefore, by analysing these signals, it is possible to capture your reponse.
// It will be educational to help ordinary people to know more about their bodies.
// Details of nameandDescription.json are cited from Wikipedia. Respect their effort.
  
import UIKit
import PlaygroundSupport

// ----- The front page to show main UI -----
class FrontViewController: UIViewController {
    
    // Elements:
    // 1. titleLabel: The header label on main screen
    // 2: introductionTextView: A brief introduction on this playground
    // 3. four CellView(s): Four customized views, each representing a kind of biological electric potential.
    
    var cellInfoArray: [String?:(String?, String?, String?, String?)] = [:]
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        // read titleAndIntroduction.json
        var titleString: String?
        var introductionString: String?
        if let path = Bundle.main.path(forResource: "titleAndIntroduction", ofType: "json") {
            if let stringData = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                if let jsonParser = try? JSONSerialization.jsonObject(with: stringData, options: .allowFragments) as? [String:String] {
                    titleString = jsonParser["title"]
                    introductionString = jsonParser["introduction"]
                }
            }
        }
        
        // create title label
        let titleLabel = UILabel(frame: CGRect(x: 75, y: 0, width: 300, height: 100))
        titleLabel.text = titleString
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.textColor = UIColor(red: 179/255.0, green: 153/255.0, blue: 255/255.0, alpha: 1)
        view.addSubview(titleLabel)
        
        // create introduction text view
        let introductionTextView = UITextView(frame: CGRect(x: 10, y: 80, width: 347, height: 140))
        introductionTextView.text = introductionString
        introductionTextView.font = UIFont.systemFont(ofSize: 14)
        introductionTextView.textColor = .black
        introductionTextView.isEditable = false
        introductionTextView.isSelectable = false
        introductionTextView.isScrollEnabled = false
        view.addSubview(introductionTextView)
        
        // create hint label
        let hintLabel = UILabel(frame: CGRect(x: 10, y: 220, width: 347, height: 20))
        hintLabel.text = "Click to learn more about your potentials."
        hintLabel.textColor = UIColor(red: 255/255.0, green: 125/255.0, blue: 50/255.0, alpha: 1)
        hintLabel.textAlignment = .center
        hintLabel.numberOfLines = 1
        hintLabel.font = UIFont(name: "Chalkduster", size: 14)
        view.addSubview(hintLabel)
        
        // read nameAndDescription.json
        if let path = Bundle.main.path(forResource: "nameAndDescription", ofType: "json") {
            if let stringData = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                if let jsonParser = try? JSONSerialization.jsonObject(with: stringData, options: .allowFragments) as? [String:[Any]] {
                    for item in (jsonParser["items"])! {
                        if let member = item as? [String:String] {
                            cellInfoArray[member["name"]] = (member["brief_intro"], member["detail_1"], member["detail_2"], member["detail_3"])
                        }
                    }
                }
            }
        }
        
        // create ECG cell
        let ecgCell = CellView(frame: CGRect(x: 30, y: 260, width: 150, height: 170))
        ecgCell.introLabel.text = cellInfoArray["ECG"]?.0
        ecgCell.icon.image = UIImage(named: "ECG.jpeg")
        let ecgTapGesture = UITapGestureRecognizer(target: self, action: #selector(cellClicked(_:)))
        ecgCell.addGestureRecognizer(ecgTapGesture)
        view.addSubview(ecgCell)
        
        // create EEG cell
        let eegCell = CellView(frame: CGRect(x: 200, y: 260, width: 150, height: 170))
        eegCell.introLabel.text = cellInfoArray["EEG"]?.0
        eegCell.icon.image = UIImage(named: "EEG.jpeg")
        let eegTapGesture = UITapGestureRecognizer(target: self, action: #selector(cellClicked(_:)))
        eegCell.addGestureRecognizer(eegTapGesture)
        view.addSubview(eegCell)
        
        // create EMG cell
        let emgCell = CellView(frame: CGRect(x: 30, y: 450, width: 150, height: 170))
        emgCell.introLabel.text = cellInfoArray["EMG"]?.0
        emgCell.icon.image = UIImage(named: "EMG.jpeg")
        let emgTapGesture = UITapGestureRecognizer(target: self, action: #selector(cellClicked(_:)))
        emgCell.addGestureRecognizer(emgTapGesture)
        view.addSubview(emgCell)
        
        // create EOG cell
        let eogCell = CellView(frame: CGRect(x: 200, y: 450, width: 150, height: 170))
        eogCell.introLabel.text = cellInfoArray["EOG"]?.0
        eogCell.icon.image = UIImage(named: "EOG.jpeg")
        let eogTapGesture = UITapGestureRecognizer(target: self, action: #selector(cellClicked(_:)))
        eogCell.addGestureRecognizer(eogTapGesture)
        view.addSubview(eogCell)
        
        self.view = view
    }
    
    // Selector methods
    @objc private func cellClicked(_ sender: UITapGestureRecognizer) {
        var currentCellName = ""
        if let currentBriefIntro = (sender.view as? CellView)?.introLabel.text {
            switch currentBriefIntro {
            case "Potential when your heart beats": currentCellName = "ECG"
            case "Potential when you think": currentCellName = "EEG"
            case "Potential when you use your muscles": currentCellName = "EMG"
            case "Potential when you use your eyes": currentCellName = "EOG"
            default: break
            }
        }
        let destination = DetailViewController()
        destination.objectName = currentCellName
        destination.objectDetailOne = cellInfoArray[currentCellName]?.1
        destination.objectDetailTwo = cellInfoArray[currentCellName]?.2
        destination.objectDetailThree = cellInfoArray[currentCellName]?.3
        self.present(destination, animated: true, completion: nil)
    }
    
}

// ----- Customized view to show name and brief introduction -----
class CellView: UIView {
    
    var introLabel: UILabel!
    var icon: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // set CALayer properties
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor(displayP3Red: 47/255.0, green: 47/255.0, blue: 59/255.0, alpha: 0.18).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0.3)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 15
        self.layer.cornerRadius = 20
        
        // add brief introduction label
        introLabel = UILabel(frame: CGRect(x: 5, y: 95, width: 140, height: 70))
        introLabel.textColor = UIColor(red: 65/255.0, green: 105/255.0, blue: 255/255.0, alpha: 1)
        introLabel.textAlignment = .center
        introLabel.numberOfLines = 3
        
        // add icon image
        icon = UIImageView(frame: CGRect(x: 20, y: 0, width: 110, height: 110))
        icon.contentMode = .scaleAspectFit
        
        self.addSubview(introLabel)
        self.addSubview(icon)
    }
    
}

// ----- Customized view controller to show further detail -----
class DetailViewController: UIViewController {
    
    // Elements:
    // 1. titleLabel: shows the title of this view controller
    // 2. backButton: dismisses this view controller and goes back
    // 3. three text views: shows details of given potential signal
    // 4. drawingView: draws a real-time sample of given potential signal
    // 5. imageView: shows a sample image of given potential signal
    
    // model
    // use store property to keep the detail information
    var objectName: String?
    var objectDetailOne: String?
    var objectDetailTwo: String?
    var objectDetailThree: String?
    // timer to control the drawing process
    var timer: Timer?
    var currentEpoch = 1
    var pointsToBeDrawn: [CGPoint] = []
    
    // view
    var drawingView: DrawingView?
    
    override func loadView() {
        // scroll view to show more content
        let scroll = UIScrollView(frame: CGRect(x: 0, y: 50, width: 375, height: 627))
        scroll.backgroundColor = UIColor(red: 120/255.0, green: 125/255.0, blue: 123/255.0, alpha: 1)
        scroll.contentSize = CGSize(width: 367, height: 1000)
        
        // background view
        let view = UIView()
        view.backgroundColor = UIColor(red: 120/255.0, green: 125/255.0, blue: 123/255.0, alpha: 1)
        
        // content view of scroll view
        let contentView = UIView()
        contentView.backgroundColor = UIColor(red: 120/255.0, green: 125/255.0, blue: 123/255.0, alpha: 1)
        scroll.addSubview(contentView)
        view.addSubview(scroll)
        
        // create back button
        let backButton = UIButton(type: .system)
        backButton.frame = CGRect(x: 10, y: 10, width: 100, height: 30)
        backButton.setTitle("Back", for: .normal)
        backButton.tintColor = .white
        backButton.addTarget(self, action: #selector(backButtonClicked(_:)), for: .touchUpInside)
        view.addSubview(backButton)
        
        // create title label
        let titleLabel = UILabel(frame: CGRect(x: 30, y: 16, width: 307, height: 35))
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        titleLabel.text = objectName
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        contentView.addSubview(titleLabel)
        
        // create paragraph #1
        let paraOneTextView = UITextView(frame: CGRect(x: 10, y: 50, width: 355, height: 220))
        paraOneTextView.text = objectDetailOne
        paraOneTextView.backgroundColor = UIColor(red: 120/255.0, green: 125/255.0, blue: 123/255.0, alpha: 1)
        paraOneTextView.textColor = .white
        paraOneTextView.isUserInteractionEnabled = false
        paraOneTextView.isScrollEnabled = false
        paraOneTextView.font = UIFont.systemFont(ofSize: 18)
        contentView.addSubview(paraOneTextView)
        
        // create drawing view
        let drawingView = DrawingView(frame: CGRect(x: 10, y: 270, width: 355, height: 140))
        drawingView.backgroundColor = .white
        contentView.addSubview(drawingView)
        // timer that controls the drawing process
        if let currentName = objectName {
            switch currentName {
            case "ECG": pointsToBeDrawn = Points.ecgPoints
            case "EEG": pointsToBeDrawn = Points.eegPoints
            case "EMG": pointsToBeDrawn = Points.emgPoints
            case "EOG": pointsToBeDrawn = Points.eogPoints
            default: pointsToBeDrawn = []
            }
        }
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {
            [weak self] timer in
            if (self?.pointsToBeDrawn[(self?.currentEpoch)! - 1].x)! > 375 {
                drawingView.points = []
                self?.currentEpoch = 1
            } else {
                drawingView.points.append((self?.pointsToBeDrawn[(self?.currentEpoch)! - 1])!)
            }
            self?.currentEpoch += 1
            drawingView.setNeedsDisplay()
        }
        
        // create paragraph #2
        let paraTwoTextView = UITextView(frame: CGRect(x: 10, y: 420, width: 355, height: 160))
        paraTwoTextView.text = objectDetailTwo
        paraTwoTextView.backgroundColor = UIColor(red: 120/255.0, green: 125/255.0, blue: 123/255.0, alpha: 1)
        paraTwoTextView.textColor = .white
        paraTwoTextView.isUserInteractionEnabled = false
        paraTwoTextView.isScrollEnabled = false
        paraTwoTextView.font = UIFont.systemFont(ofSize: 18)
        contentView.addSubview(paraTwoTextView)
        
        // create image view
        let imageView = UIImageView(image: UIImage(named: "\(objectName!).jpeg")!)
        imageView.frame = CGRect(x: 10, y: 630, width: 355, height: 140)
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
        
        // create paragraph #3
        let paraThreeTextView = UITextView(frame: CGRect(x: 10, y: 740, width: 355, height: 180))
        paraThreeTextView.text = objectDetailThree
        paraThreeTextView.backgroundColor = UIColor(red: 120/255.0, green: 125/255.0, blue: 123/255.0, alpha: 1)
        paraThreeTextView.textColor = .white
        paraThreeTextView.isUserInteractionEnabled = false
        paraThreeTextView.isScrollEnabled = false
        paraThreeTextView.font = UIFont.systemFont(ofSize: 18)
        contentView.addSubview(paraThreeTextView)
        
        self.view = view
    }
    
    // when the view controller is going to show, start the timer
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timer?.fire()
    }
    
    // when dismissed, stop and reset the timer
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    // dismiss this view controller when clicking bachButton
    @objc private func backButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

// ----- Customized view that draws the real-time potential signal -----
class DrawingView: UIView {
    
    var points: [CGPoint] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clearsContextBeforeDrawing = true
    }
    
    override func draw(_ rect: CGRect) {
        drawGrid()
        drawCurve()
    }
    
    private func drawGrid() {
        let context = UIGraphicsGetCurrentContext()
        let height = self.frame.size.height
        let width = self.frame.size.width
        var cellSquareWidth: CGFloat = 30
        
        context?.setLineWidth(1)
        context?.setStrokeColor(UIColor.red.cgColor)
        
        // draw big grids
        // draw horizontal grid lines
        var pos_x: CGFloat = 1
        while(pos_x <= width) {
            context?.setLineWidth(0.2)
            context?.move(to: CGPoint(x: pos_x, y: 1))
            context?.addLine(to: CGPoint(x: pos_x, y: height))
            pos_x += cellSquareWidth
            context?.strokePath()
        }
        // draw vertical grid lines
        var pos_y: CGFloat = 1
        while(pos_y <= height) {
            context?.move(to: CGPoint(x: 1, y: pos_y))
            context?.addLine(to: CGPoint(x: width, y: pos_y))
            pos_y += cellSquareWidth
            context?.strokePath()
        }
        
        // draw small grids
        cellSquareWidth = cellSquareWidth / 5
        // draw horizontal grid lines
        pos_x = 1
        while(pos_x <= width) {
            context?.setLineWidth(0.2)
            context?.move(to: CGPoint(x: pos_x, y: 1))
            context?.addLine(to: CGPoint(x: pos_x, y: height))
            pos_x += cellSquareWidth
            context?.strokePath()
        }
        // draw vertical grid lines
        pos_y = 1
        while(pos_y <= height) {
            context?.move(to: CGPoint(x: 1, y: pos_y))
            context?.addLine(to: CGPoint(x: width, y: pos_y))
            pos_y += cellSquareWidth
            context?.strokePath()
        }
    }
    
    private func drawCurve() {
        let numberOfPoints = points.count
        if numberOfPoints == 0 { return }
        
        let curveWidth: CGFloat = 1.2
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(curveWidth)
        context?.setStrokeColor(UIColor.black.cgColor)
        
        // if there is a point on the right, link to there, otherwise move to there.
        context?.move(to: points[0])
        for i in 0 ..< numberOfPoints-1 {
            if (points[i].x < points[i+1].x) {
                context?.addLine(to: points[i+1])
            } else {
                context?.move(to: points[i+1])
            }
        }
        
        context?.strokePath()
    }
}

// ------------------ Model -----------------------
// ----- Points constants for drawing diagram -----
struct Points {
    // points for ecg
    static let ecgPoints: [CGPoint] = [
        CGPoint(x: 0, y: 60),
        CGPoint(x: 10, y: 50),
        CGPoint(x: 20, y: 60),
        CGPoint(x: 30, y: 60),
        CGPoint(x: 40, y: 50),
        CGPoint(x: 50, y: 60),
        CGPoint(x: 60, y: 30),
        CGPoint(x: 70, y: 110),
        CGPoint(x: 80, y: 70),
        CGPoint(x: 90, y: 60),
        CGPoint(x: 100, y: 40),
        CGPoint(x: 110, y: 60),
        CGPoint(x: 120, y: 50),
        CGPoint(x: 130, y: 60),
        CGPoint(x: 140, y: 50),
        CGPoint(x: 150, y: 60),
        CGPoint(x: 160, y: 60),
        CGPoint(x: 170, y: 50),
        CGPoint(x: 180, y: 60),
        CGPoint(x: 190, y: 30),
        CGPoint(x: 200, y: 110),
        CGPoint(x: 210, y: 70),
        CGPoint(x: 220, y: 60),
        CGPoint(x: 230, y: 40),
        CGPoint(x: 240, y: 60),
        CGPoint(x: 250, y: 50),
        CGPoint(x: 260, y: 60),
        CGPoint(x: 270, y: 50),
        CGPoint(x: 280, y: 60),
        CGPoint(x: 290, y: 60),
        CGPoint(x: 300, y: 50),
        CGPoint(x: 310, y: 60),
        CGPoint(x: 320, y: 30),
        CGPoint(x: 330, y: 110),
        CGPoint(x: 340, y: 70),
        CGPoint(x: 350, y: 60),
        CGPoint(x: 360, y: 40),
        CGPoint(x: 370, y: 60),
        CGPoint(x: 380, y: 50)
    ]
    
    // points for eeg
    static let eegPoints: [CGPoint] = [
        CGPoint(x: 0, y: 80),
        CGPoint(x: 10, y: 70),
        CGPoint(x: 20, y: 80),
        CGPoint(x: 30, y: 70),
        CGPoint(x: 40, y: 80),
        CGPoint(x: 50, y: 70),
        CGPoint(x: 60, y: 40),
        CGPoint(x: 70, y: 60),
        CGPoint(x: 80, y: 20),
        CGPoint(x: 90, y: 30),
        CGPoint(x: 100, y: 50),
        CGPoint(x: 110, y: 40),
        CGPoint(x: 120, y: 30),
        CGPoint(x: 130, y: 50),
        CGPoint(x: 140, y: 30),
        CGPoint(x: 150, y: 40),
        CGPoint(x: 160, y: 50),
        CGPoint(x: 170, y: 90),
        CGPoint(x: 180, y: 60),
        CGPoint(x: 190, y: 70),
        CGPoint(x: 200, y: 50),
        CGPoint(x: 210, y: 90),
        CGPoint(x: 220, y: 70),
        CGPoint(x: 230, y: 110),
        CGPoint(x: 240, y: 100),
        CGPoint(x: 250, y: 140),
        CGPoint(x: 260, y: 120),
        CGPoint(x: 270, y: 80),
        CGPoint(x: 280, y: 60),
        CGPoint(x: 290, y: 70),
        CGPoint(x: 300, y: 40),
        CGPoint(x: 310, y: 50),
        CGPoint(x: 320, y: 30),
        CGPoint(x: 330, y: 40),
        CGPoint(x: 340, y: 80),
        CGPoint(x: 350, y: 70),
        CGPoint(x: 360, y: 90),
        CGPoint(x: 370, y: 80),
        CGPoint(x: 380, y: 80)
    ]
    
    // points for emg
    static let emgPoints: [CGPoint] = [
        CGPoint(x: 0, y: 60),
        CGPoint(x: 10, y: 60),
        CGPoint(x: 20, y: 60),
        CGPoint(x: 30, y: 60),
        CGPoint(x: 40, y: 70),
        CGPoint(x: 50, y: 80),
        CGPoint(x: 60, y: 95),
        CGPoint(x: 70, y: 80),
        CGPoint(x: 80, y: 70),
        CGPoint(x: 90, y: 60),
        CGPoint(x: 100, y: 60),
        CGPoint(x: 110, y: 70),
        CGPoint(x: 120, y: 70),
        CGPoint(x: 130, y: 60),
        CGPoint(x: 140, y: 50),
        CGPoint(x: 150, y: 40),
        CGPoint(x: 160, y: 30),
        CGPoint(x: 170, y: 20),
        CGPoint(x: 180, y: 30),
        CGPoint(x: 190, y: 40),
        CGPoint(x: 200, y: 50),
        CGPoint(x: 210, y: 60),
        CGPoint(x: 220, y: 70),
        CGPoint(x: 230, y: 80),
        CGPoint(x: 240, y: 95),
        CGPoint(x: 250, y: 80),
        CGPoint(x: 260, y: 70),
        CGPoint(x: 270, y: 60),
        CGPoint(x: 280, y: 50),
        CGPoint(x: 290, y: 50),
        CGPoint(x: 300, y: 50),
        CGPoint(x: 310, y: 40),
        CGPoint(x: 320, y: 30),
        CGPoint(x: 330, y: 40),
        CGPoint(x: 340, y: 50),
        CGPoint(x: 350, y: 60),
        CGPoint(x: 360, y: 60),
        CGPoint(x: 370, y: 60),
        CGPoint(x: 380, y: 60)
    ]
    
    // points for eog
    static let eogPoints: [CGPoint] = [
        CGPoint(x: 0, y: 60),
        CGPoint(x: 10, y: 50),
        CGPoint(x: 20, y: 60),
        CGPoint(x: 30, y: 50),
        CGPoint(x: 40, y: 60),
        CGPoint(x: 50, y: 20),
        CGPoint(x: 60, y: 45),
        CGPoint(x: 70, y: 10),
        CGPoint(x: 80, y: 40),
        CGPoint(x: 90, y: 35),
        CGPoint(x: 100, y: 45),
        CGPoint(x: 110, y: 35),
        CGPoint(x: 120, y: 45),
        CGPoint(x: 130, y: 75),
        CGPoint(x: 140, y: 80),
        CGPoint(x: 150, y: 85),
        CGPoint(x: 160, y: 80),
        CGPoint(x: 170, y: 85),
        CGPoint(x: 180, y: 80),
        CGPoint(x: 190, y: 85),
        CGPoint(x: 200, y: 70),
        CGPoint(x: 210, y: 60),
        CGPoint(x: 220, y: 55),
        CGPoint(x: 230, y: 65),
        CGPoint(x: 240, y: 55),
        CGPoint(x: 250, y: 75),
        CGPoint(x: 260, y: 70),
        CGPoint(x: 270, y: 60),
        CGPoint(x: 280, y: 70),
        CGPoint(x: 290, y: 60),
        CGPoint(x: 300, y: 70),
        CGPoint(x: 310, y: 40),
        CGPoint(x: 320, y: 30),
        CGPoint(x: 330, y: 40),
        CGPoint(x: 340, y: 30),
        CGPoint(x: 350, y: 35),
        CGPoint(x: 360, y: 30),
        CGPoint(x: 370, y: 45),
        CGPoint(x: 380, y: 60)
    ]
}

// ----- Present the view controller in the Live View window -----
PlaygroundPage.current.liveView = FrontViewController()
