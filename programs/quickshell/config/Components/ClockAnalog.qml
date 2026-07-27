import Quickshell
import QtQuick

Rectangle {
	id: clockFace

	implicitHeight: parent.height - 1
	implicitWidth:  parent.height + 1
	radius:         this.height / 2
	color:          Theme.clock.face
	border.color:   Theme.bar.border
	border.width:   2
	z:              2


	SystemClock {
		id:        sysClock
		precision: SystemClock.Seconds
	}

	Canvas {
		anchors.fill: parent
		antialiasing: true

		onPaint: {
			const ctx = getContext("2d")
			const cx  = parent.width / 2
			const cy  = parent.height / 2
			const r   = Math.min( parent.width, parent.height ) / 2 - 2
			ctx.reset()
			ctx.strokeStyle = Theme.clock.border
			ctx.globalAlpha = 0.5

			ctx.lineWidth = 1
			ctx.beginPath()
			ctx.arc(cx, cy, r, 0, 2 * Math.PI)
			ctx.stroke()

			for (let i = 0; i < 12; i++) {
				const isOrth    = i % 3 === 0
				const angle     = i * 30 * Math.PI / 180
				const inner     = r - (isOrth ? 5 : 3)
				const outer     = r
				ctx.globalAlpha = isOrth ? 1 : 0.5
				ctx.lineWidth   = 1
				ctx.beginPath()
				ctx.moveTo( cx + inner * Math.sin(angle), cy - inner * Math.cos(angle) )
				ctx.lineTo( cx + outer * Math.sin(angle), cy - outer * Math.cos(angle) )
				ctx.stroke()
			}
			ctx.globalAlpha = 1;
		}
	}

	Rectangle { // Minute Hand
		anchors.bottom:           clockFace.verticalCenter
		anchors.horizontalCenter: clockFace.horizontalCenter

		implicitHeight:  12
		implicitWidth:   1
		color:           Theme.clock.hands
		antialiasing:    true
		transformOrigin: Item.Bottom
		rotation: {
			const d = sysClock.date;
			return d.getMinutes() * 6;
		}

		Behavior on rotation { RotationAnimation { duration: 200; direction: RotationAnimation.Shortest } }
	}

	Rectangle { // Hour Hand
		anchors.bottom:           clockFace.verticalCenter
		anchors.horizontalCenter: clockFace.horizontalCenter

		implicitHeight:  7
		implicitWidth:   2
		color:           Theme.clock.hands
		antialiasing:    true
		transformOrigin: Item.Bottom
		rotation: {
			const d = sysClock.date;
			return ((d.getHours() % 12) + (d.getMinutes() / 60)) * 30;
		}

		Behavior on rotation { RotationAnimation { duration: 200; direction: RotationAnimation.Shortest } }
	}
}
