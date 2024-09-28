import { Environment } from "../service/env.js"

class CavaSvc extends Service {
    static {
        Service.register(this, {}, {
            "vals": ["gobject"],
        })
    }

    vals = Variable("", {
        listen: [`${Environment.home_dir}/.scripts/cava.sh`, (d) => d],
    })

    constructor() {
        super()
    }
}

export const Cava = new CavaSvc
