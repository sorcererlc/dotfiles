import { Notifications as NotifSvc } from "../../../service/notifications.js"

export const Notifications = () => Widget.Button({
    child: Widget.Label({
        label: NotifSvc.notifications.bind().as(n => {
            return `${n.dnd ? "" : ""}  ${n.count}`
        }),
    }),
    on_clicked: () => Utils.execAsync("swaync-client -t -sw"),
    on_secondary_click: () => Utils.execAsync(`swaync-client ${NotifSvc.notifications.value.dnd ? "-df" : "-dn"}`),
    class_name: NotifSvc.notifications.bind().as(n => `notifications${n.dnd ? " dnd" : ""}`),
    tooltip_text: "Click to open notifications\nRight-click to toggle Do Not Disturb",
})
