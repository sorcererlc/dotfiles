class EnvSvc extends Service {
    static {
        Service.register(this)
    }

    home_dir = ""

    constructor() {
        super()

        this.home_dir = Utils.exec(["bash", "-c", "echo $HOME"])
    }

    var(/** @type String */ v) {
        return Utils.exec(["bash", "-c", `echo $${v}`])
    }
}

export const Environment = new EnvSvc
