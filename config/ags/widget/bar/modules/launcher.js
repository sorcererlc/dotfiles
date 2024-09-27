export const Launcher = () => {
    return Widget.Box({
        child: Widget.Button({
            on_clicked: () => App.toggleWindow("launcher"),
            child: Widget.Label(""),
            // TODO find out how to change svg color
            //child: Widget.Icon({
            //    icon: `${App.configDir}/resources/icons/arch-symbolic.svg`,
            //}),
            class_name: "launcher",
        })
    })
}

