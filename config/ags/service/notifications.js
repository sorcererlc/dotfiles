class NotificationSvc extends Service {
    static {
        Service.register(this, {}, {
            "notifications": ["gobject"],
        })
    }

    notifications = Variable({
        count: 0,
        dnd: false,
    }, {
        listen: ["swaync-client -s", (t) => {
            const n = JSON.parse(t)
            return {
                count: n.count,
                dnd: n.dnd,
            }
        }]
    })

    constructor() {
        super()
    }
}

export const Notifications = new NotificationSvc
