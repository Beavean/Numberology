//
//  DicesView.swift
//  Numberology
//
//  Created by Beavean on 08.04.2023.
//

import UIKit

final class DicesView: UIView {
    // MARK: - Properties

    private enum PositionX {
        case left, center, right
    }

    private enum PositionY {
        case top, center, bottom
    }

    private let mainColor: UIColor?
    private let backgroundFillColor: UIColor?
    private let cornerRadius: CGFloat = 15
    private let backgroundDiceNumber = 1
    private let foregroundDiceNumber = 5

    // MARK: - Initialization

    init(mainColor: UIColor?, backgroundFillColor: UIColor?) {
        self.mainColor = mainColor
        self.backgroundFillColor = backgroundFillColor
        super.init(frame: .zero)
        backgroundColor = .clear
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let backgroundDiceRect = CGRect(x: rect.midX, y: rect.midY, width: rect.width / 2, height: rect.height / 2)
        let foregroundDiceRect = CGRect(x: rect.minX, y: rect.minY, width: rect.width / 2, height: rect.height / 2)

        let backgroundDicePath = getDicePath(in: backgroundDiceRect, number: backgroundDiceNumber)
        var backgroundTransform: CGAffineTransform = .identity
        backgroundTransform = backgroundTransform.translatedBy(x: -rect.width / 60, y: -rect.height / 10)
        backgroundDicePath.apply(backgroundTransform)
        backgroundFillColor?.setFill()
        backgroundDicePath.fill()
        mainColor?.setStroke()
        backgroundDicePath.stroke()

        let foregroundDicePath = getDicePath(in: foregroundDiceRect, number: foregroundDiceNumber)
        var foregroundTransform: CGAffineTransform = .identity
        foregroundTransform = foregroundTransform.translatedBy(x: rect.width / 2.7, y: rect.height / 5)
        foregroundTransform = foregroundTransform.rotated(by: .pi / 4)
        foregroundDicePath.apply(foregroundTransform)
        backgroundFillColor?.setFill()
        foregroundDicePath.fill()
        mainColor?.setStroke()
        foregroundDicePath.stroke()
    }

    // MARK: - Helpers

    private func getDicePath(in rect: CGRect, number: Int) -> UIBezierPath {
        let dicePath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        dicePath.append(getDiceDotPath(in: rect, with: number))
        dicePath.lineWidth = rect.width / 15
        return dicePath
    }

    private func getDiceDotPath(in rect: CGRect, with number: Int) -> UIBezierPath {
        assert(1 ... 6 ~= number, "Dice with such number is not implemented")
        let dotsPath = UIBezierPath()
        switch number {
        case 1:
            dotsPath.append(getDotPath(in: rect, positionX: .center, positionY: .center))
        case 2:
            dotsPath.append(getDotPath(in: rect, positionX: .right, positionY: .top))
            dotsPath.append(getDotPath(in: rect, positionX: .left, positionY: .bottom))
        case 3:
            dotsPath.append(getDotPath(in: rect, positionX: .right, positionY: .top))
            dotsPath.append(getDotPath(in: rect, positionX: .center, positionY: .center))
            dotsPath.append(getDotPath(in: rect, positionX: .left, positionY: .bottom))
        case 4:
            dotsPath.append(getDotPath(in: rect, positionX: .left, positionY: .top))
            dotsPath.append(getDotPath(in: rect, positionX: .right, positionY: .top))
            dotsPath.append(getDotPath(in: rect, positionX: .left, positionY: .bottom))
            dotsPath.append(getDotPath(in: rect, positionX: .right, positionY: .bottom))
        case 5:
            dotsPath.append(getDotPath(in: rect, positionX: .left, positionY: .top))
            dotsPath.append(getDotPath(in: rect, positionX: .right, positionY: .top))
            dotsPath.append(getDotPath(in: rect, positionX: .center, positionY: .center))
            dotsPath.append(getDotPath(in: rect, positionX: .left, positionY: .bottom))
            dotsPath.append(getDotPath(in: rect, positionX: .right, positionY: .bottom))
        default:
            dotsPath.append(getDotPath(in: rect, positionX: .left, positionY: .top))
            dotsPath.append(getDotPath(in: rect, positionX: .right, positionY: .top))
            dotsPath.append(getDotPath(in: rect, positionX: .left, positionY: .center))
            dotsPath.append(getDotPath(in: rect, positionX: .right, positionY: .center))
            dotsPath.append(getDotPath(in: rect, positionX: .left, positionY: .bottom))
            dotsPath.append(getDotPath(in: rect, positionX: .right, positionY: .bottom))
        }
        return dotsPath
    }

    private func getDotPath(in rect: CGRect, positionX: PositionX, positionY: PositionY) -> UIBezierPath {
        var xPosition = CGFloat()
        var yPosition = CGFloat()

        switch positionX {
        case .left: xPosition = rect.midX - rect.width / 4
        case .center: xPosition = rect.midX
        case .right: xPosition = rect.midX + rect.width / 4
        }

        switch positionY {
        case .top: yPosition = rect.midY - rect.height / 4
        case .center: yPosition = rect.midY
        case .bottom: yPosition = rect.midY + rect.height / 4
        }

        return getCirclePath(arcCenter: CGPoint(x: xPosition, y: yPosition), radius: rect.width / 30)
    }

    private func getCirclePath(arcCenter: CGPoint, radius: CGFloat) -> UIBezierPath {
        UIBezierPath(
            arcCenter: arcCenter,
            radius: radius,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: true
        )
    }
}
