
import UIKit
//import EasyTipView

extension UIView {
    
    // Bottom corner
    func applyTopViewStyle(radius:CGFloat = 20.0){
        self.backgroundColor = .primaryColor()
        self.roundCorners(corners: [.bottomLeft,.bottomRight], radius: radius)
    }
    
    //Round corner
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        self.clipsToBounds = false
        self.layer.cornerRadius = radius
        var masked = CACornerMask()
        if corners.contains(.topLeft) { masked.insert(.layerMinXMinYCorner) }
        if corners.contains(.topRight) { masked.insert(.layerMaxXMinYCorner) }
        if corners.contains(.bottomLeft) { masked.insert(.layerMinXMaxYCorner) }
        if corners.contains(.bottomRight) { masked.insert(.layerMaxXMaxYCorner) }
        self.layer.maskedCorners = masked
    }
  
    func addBottomBorderWithColor(name: String, color: UIColor, height: CGFloat) {
        self.removeBottomBorder(withName: name)
        
        let border = CALayer()
        border.name = name
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - height, width: self.frame.size.width, height: height)
        self.layer.addSublayer(border)
    }
    
    func removeBottomBorder(withName: String){
        for layer in self.layer.sublayers ?? []{
            if layer.name == withName{
                layer.removeFromSuperlayer()
            }
        }
    }
   
    func addBottomShadow() {
        layer.masksToBounds = false
        layer.shadowRadius = 4
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0 , height: 2)
        layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                     y: bounds.maxY - layer.shadowRadius,
                                                     width: bounds.width,
                                                     height: layer.shadowRadius)).cgPath
    }
    
    func applyLightShadow()  {
        self.backgroundColor = .white
        self.layer.cornerRadius = 10.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.layer.shadowRadius = 1.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
    }
    
    func addshadow(top: Bool = true,
                   left: Bool = true,
                   bottom: Bool = true,
                   right: Bool = true,
                   shadowRadius: CGFloat = 2.0,
                   shadowOpacity: Float = 1.0) {
        
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
        
        let path = UIBezierPath()
        var x: CGFloat = 0
        var y: CGFloat = 0
        var viewWidth = self.frame.width
        var viewHeight = self.frame.height
        
        if (!top) {
            y+=(shadowRadius+1)
        }
        if (!bottom) {
            viewHeight-=(shadowRadius+1)
        }
        if (!left) {
            x+=(shadowRadius+1)
        }
        if (!right) {
            viewWidth-=(shadowRadius+1)
        }
        path.move(to: CGPoint(x: x, y: y))
        
        path.addLine(to: CGPoint(x: x, y: viewHeight))
        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        path.addLine(to: CGPoint(x: viewWidth, y: y))
        
        path.close()
        self.layer.shadowPath = path.cgPath
    }
    
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0)
        defer { UIGraphicsEndImageContext() }
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    func getThumbName(name:String) -> String {
        var str = ""
        let hasNames = name.components(separatedBy: " ")
        if hasNames.count > 1{
            str = "\(String(hasNames[0].prefix(1)))\(String(hasNames[hasNames.count - 1].prefix(1)))"
        }else{
            str = String(name.prefix(1))
        }
        return str.uppercased()
    }

}

class DashedView: UIView {
    
    let shapeLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() -> Void {
        
        let color = UIColor(displayP3Red: 178.0/255.0, green: 181.0/255.0, blue: 200.0/255.0, alpha: 1.0).cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        
        layer.addSublayer(shapeLayer)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
       shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath // self.frame.size.width/2
        
    }

}
