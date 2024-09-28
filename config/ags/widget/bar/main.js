import { Separator } from "../../lib/misc.js"
import { Launcher } from "./modules/launcher.js"
import { Clock } from "./modules/clock.js"
import { Workspaces } from "./modules/workspaces.js"
import { Volume } from "./modules/volume.js"
import { Battery } from "./modules/battery.js"
import { SysTray } from "./modules/systray.js"
import { Media } from "./modules/media.js"
import { System } from "./modules/system.js"
import { Weather } from "./modules/weather.js"
import { Power } from "./modules/power.js"
import { Notifications } from "./modules/notifications.js"
import { Cava } from "./modules/cava.js"

const Left = (/** @type number */ monitor = 0) => {
    return Widget.Box({
        class_name: "box left",
        hpack: "start",
        children: [
            Launcher(),
            Separator(),
            System(),
            Separator(),
            Weather(),
            Separator(),
            Media,
            Cava(),
        ],
    })
}

const Center = (/** @type number */ monitor = 0) => {
    return Widget.Box({
        class_name: "box center",
        hpack: "center",
        children: [
            Notifications(),
            Separator(),
            Clock(),
            Separator(),
            Workspaces(monitor),
        ]
    })
}

const Right = (/** @type number */ monitor = 0) => {
    return Widget.Box({
        class_name: "box right",
        hpack: "end",
        children: [
            SysTray(),
            Separator(),
            Volume("speaker"),
            Volume("microphone"),
            Separator(),
            Battery(),
            Separator(),
            Power(),
        ],
    })
}

const Bar = (/** @type number */ monitor = 0) => Widget.Window({
    monitor,
    name: `bar${monitor}`,
    anchor: ["top", "left", "right"],
    exclusivity: "exclusive",
    class_name: "bar",
    child: Widget.CenterBox({
        start_widget: Left(monitor),
        center_widget: Center(monitor),
        end_widget: Right(monitor),
    }),
})

export default Bar
