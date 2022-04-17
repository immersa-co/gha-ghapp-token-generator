import os
from gha_token_generator import TokenGenerator


def main():

    key = os.environ["INPUT_PRIVATEKEY"]
    app_id = os.environ["INPUT_APPID"]
    install_id = os.environ["INPUT_INSTALLID"]
    duration = int(os.environ["INPUT_DURATION"])

    tm = TokenGenerator(key, app_id, install_id, duration)
    token = tm.fetch_token()
    print(f"::set-output name=ghaToken::{token}")


if __name__ == "__main__":
    main()
