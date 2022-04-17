import jwt
import time
import requests
import json


class TokenGenerator:
    def __init__(self, github_app_key, github_app_id, github_app_install_id, duration=10):
        self.githubAppKey = github_app_key
        self.githubAppId = github_app_id
        self.githubAppInstallId = github_app_install_id
        self.duration = duration

    def fetch_token(self):
        response = requests.post(f'https://api.github.com/app/installations/{self.githubAppInstallId}/access_tokens',
                                 headers=self.get_header())
        if not response.ok:
            error = f"Error getting github app Token {response.json()['message']}"
            print(error)
            raise Exception(error)

        return json.loads(response.content.decode())["token"]

    def get_header(self):
        now = int(time.time())

        payload = {
            # JWT token issued at time
            'iat': now,
            # JWT expiration time (10 minute maximum)
            'exp': now + (self.duration * 60),
            # App ID
            'iss': self.githubAppId
        }
        jwt_token = jwt.encode(payload, self.githubAppKey, algorithm='RS256')
        headers = {
            "Authorization": f"Bearer {jwt_token}",
            "Accept": "application/vnd.github.machine-man-preview+json"}
        return headers
