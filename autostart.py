#!/usr/bin/env python3

from subprocess import call


START_CMD = "./start_bot.sh"


class BotConfig:
    def __init__(self, name: str, psk: str, config: str):
        self.name = name
        self.psk = psk
        self.config = config

    def to_start_cmd(self):
        cmd = f"{START_CMD} -n {self.name} -f {self.config} -p {self.psk} --detach"
        return cmd


BOTS = [
    BotConfig(
        "PDEX-USDT-KC",
        "123",
        "conf_pure_mm_pdex-usdt-kc.yml"
    ),
    BotConfig(
        "FAR-USDT-GIO",
        "123",
        "conf_pure_mm_far-usdt-gio.yml"
    ),
    # BotConfig(
    #     "XCAD-USDT-KC",
    #     "123",
    #     "conf_pure_mm_xcad-usdt-kc.yml"
    # ),
    # BotConfig(
    #     "XDC-USDT-GIO",
    #     "123",
    #     "conf_pure_mm_xdc-usdt-gio.yml"
    # )
]


if __name__ == "__main__":
    for bot in BOTS:
        print(bot)
        call(bot.to_start_cmd(), shell=True)
