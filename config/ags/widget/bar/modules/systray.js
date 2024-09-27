const systemtray = await Service.import("systemtray")

export const SysTray = () => {
    const items = systemtray.bind("items").as(items => {
        items = items.sort((a, b) => a.title !== null && b.title !== null ? a.title.localeCompare(b.title) : 1)
        return items.map(item =>
            Widget.Button({
                class_name: "tray-item",
                child: Widget.Icon({
                    icon: item.bind("icon"),
                    size: 16,
                }),
                on_primary_click: (_, event) => item.activate(event),
                on_secondary_click: (_, event) => item.openMenu(event),
                tooltip_markup: item.bind("tooltip_markup"),
            })
        )
    })

    return Widget.Box({
        child: Widget.Box({
            class_name: "systray",
            children: items,
        })
    })
}

