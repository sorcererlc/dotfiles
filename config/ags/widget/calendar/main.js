import { clock, uptime } from "../../lib/misc.js"

function up(/** @type number */ up) {
    const h = Math.floor(up / 60)
    const m = Math.floor(up % 60)
    return `uptime: ${h}:${m < 10 ? "0" + m : m}`
}

const Cal = Widget.Box({
    vertical: true,
    class_name: "calendar-box",
    children: [
        Widget.Box({
            class_name: "clock",
            vertical: true,
            children: [
                Widget.Label({
                    class_name: "clock",
                    label: clock.bind().as(t => t.format("%H:%M")),
                }),
                Widget.Label({
                    class_name: "uptime",
                    label: uptime.bind().as(up),
                }),
            ],
        }),
        Widget.Box({
            class_name: "calendar",
            children: [
                Widget.Calendar({
                    hexpand: true,
                    hpack: "center",
                }),
            ],
        }),
    ],
})

export const Calendar = () => Widget.Window({
    name: "calendar",
    anchor: ["top"],
    visible: false,
    keymode: "exclusive",
    child: Cal,
    setup: self => self.keybind("Escape", () => {
        App.closeWindow("calendar")
    }),
})
