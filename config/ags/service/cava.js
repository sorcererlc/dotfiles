import { Environment } from "../service/env.js"

const CONFIG_FILE = `${Environment.home_dir}/.config/cava/bar_cava_config`

class CavaSvc extends Service {
    static {
        Service.register(this, {}, {
            "vals": ["gobject"],
        })
    }

    vals = Variable("", {
        listen: [`cava -p "${CONFIG_FILE}"`, (d) => d.replaceAll(";", "")]
    })

    constructor() {
        super()
    }
}

export const Cava = new CavaSvc
