const hyprland = await Service.import("hyprland")

const wsIcons = {
    "1": "",
    "2": "",
    "3": "",
    "4": "",
    "5": "",
    "6": "",
    "7": "",
    "8": "",
    "9": "",
    "10": "",
}

export const Workspaces = (/** @type number */ monitor) => {
    const activeWs = hyprland.active.workspace.bind("id")

    const workspaces = hyprland.bind("workspaces")
        .as(ws => {
            ws = ws.filter((w) => {
                return w.monitorID === monitor && w.id >= 0
            })

            ws = ws.sort((a, b) => {
                return a.id > b.id ? 1 : -1
            })

            return ws.map(
                ({ id }) => {
                    return Widget.Button({
                        on_clicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
                        child: Widget.Label(`${id} ${wsIcons[id]}`),
                        class_name: activeWs.as(i => `${i === id ? "focused" : ""}`),
                    })
                }
            )
        })

    return Widget.Box({
        class_name: "workspaces",
        children: workspaces,
    })
}

