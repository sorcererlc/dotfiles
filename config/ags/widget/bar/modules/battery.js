const battery = await Service.import("battery")

export const Battery = () => {
    const icon = battery.bind("percent").as(p => `battery-level-${Math.floor(p / 10) * 10}-symbolic`)

    return Widget.Box({
        class_name: "battery",
        visible: battery.bind("available"),
        children: [
            Widget.Icon({
                icon,
                size: 16,
                setup: self => self.hook(battery, () => {
                    self.class_name = battery.percent <= 20 ? "warn" : ""
                })
            }),
            Widget.Label({
                setup: self => self.hook(battery, () => {
                    self.label = ` ${battery.percent}%`
                    self.class_name = battery.percent <= 20 ? "warn" : ""
                }),
            }),
        ],
    })
}

