import { Distro } from "../../../service/distro.js"

export const Launcher = () => {
    return Widget.Box({
        child: Widget.Button({
            class_name: "launcher",
            on_clicked: () => App.toggleWindow("launcher"),
            tooltip_text: "Applications",
            child: Widget.Icon({
                icon: `${App.configDir}/resources/icons/${Distro.id}.png`,
                size: 16,
            }),
        })
    })
}

