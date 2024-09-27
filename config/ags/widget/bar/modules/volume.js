const audio = await Service.import("audio")

/**
 * @dev - speaker || microphone
 */
export const Volume = (dev = "speaker") => {
    const icons = {
        101: "overamplified",
        67: "high",
        34: "medium",
        1: "low",
        0: "muted",
    }

    function getIcon() {
        const icon = audio[dev].is_muted ? 0 : [101, 67, 34, 1, 0].find(
            threshold => threshold <= audio[dev].volume * 100
        )

        switch (dev) {
            case "microphone":
                return `audio-input-microphone-symbolic` //audio[dev].is_muted ? `audio-input-microphone-muted-symbolic` : `audio-input-microphone-symbolic`
            default:
                return `audio-volume-${icons[icon]}-symbolic`
        }
    }

    const icon = Widget.Icon({
        icon: Utils.watch(getIcon(), audio[dev], getIcon),
        size: 16,
        setup: self => self.hook(audio[dev], () => {
            self.class_name = audio[dev].is_muted ? "muted" : ""
        })
    })

    const val = Widget.Label({
        setup: self => self.hook(audio[dev], () => {
            self.label = ` ${Math.round(audio[dev].volume * 100) || 0}%`
            self.class_name = audio[dev].is_muted ? "muted" : ""
        })
    })

    const box = Widget.Box({
        class_name: "volume",
        children: [
            icon,
            val,
        ],
    })

    return Widget.Button({
        child: box,
        on_clicked: () => audio[dev].is_muted = !audio[dev].is_muted,
    })
}

