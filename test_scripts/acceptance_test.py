import requests
from requests.auth import HTTPBasicAuth
import argparse

def validate_jenkins(url, username, password):
    api_url = f"{url.strip('"')}/api/json"  # Jenkins API endpoint
    
    try:
        # Send GET request with Basic Auth
        response = requests.get(api_url, auth=HTTPBasicAuth(username, password), timeout=10)
        
        if response.status_code == 200:
            print(f"[✅] Jenkins URL is reachable and credentials are valid: {url}")
            info = response.json()
            print(f"Jenkins version: {response.headers.get('X-Jenkins', 'Unknown')}")
            print(f"Number of jobs: {len(info.get('jobs', []))}")
        elif response.status_code == 401:
            print(f"[❌] Unauthorized: Invalid username or password")
        else:
            print(f"[❌] Jenkins returned status code {response.status_code}")
    
    except requests.exceptions.RequestException as e:
        print(f"[❌] Failed to reach Jenkins URL: {url}")
        print(f"Error: {e}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Validate Jenkins URL and admin credentials")
    parser.add_argument("--url", required=True, help="Jenkins server URL, e.g., http://127.0.0.1:8080")
    parser.add_argument("--username", default="admin", help="Admin username (default: admin)")
    parser.add_argument("--password", required=True, help="Admin password or API token")
    
    args = parser.parse_args()
    
    validate_jenkins(args.url, args.username, args.password)
