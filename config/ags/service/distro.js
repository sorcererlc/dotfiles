class DistroSvc extends Service {
    static {
        Service.register(this)
    }

    name = "Linux"
    pretty_name = "Linux"
    id = "linux"
    ansi_color = "0;0;0;0;0"

    constructor() {
        super()
        let lines

        try {
            lines = Utils.readFile("/etc/os-release").split("\n")
        } catch (e) {
            return
        }

        for (let i = 0; i < lines.length; i++) {
            const l = lines[i]

            if (l.match(/^NAME/)) {
                this.name = l.split("=")[1]
            }
            if (l.match(/^PRETTY_NAME/)) {
                this.pretty_name = l.split("=")[1]
            }
            if (l.match(/^ID/)) {
                this.id = l.split("=")[1]
            }
            if (l.match(/^ANSI_COLOR/)) {
                this.ansi_color = l.split("=")[1]
            }
        }
    }
}

export const Distro = new DistroSvc
