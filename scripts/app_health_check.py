#!/usr/bin/env python3
import os, sys, requests, time

URL = os.getenv("APP_URL", "http://localhost:4499")
TIMEOUT = 5
RETRIES = int(os.getenv("RETRIES", "3"))

def check():
    for i in range(RETRIES):
        try:
            r = requests.get(URL, timeout=TIMEOUT)
            print(f"{time.strftime('%Y-%m-%d %H:%M:%S')} STATUS {r.status_code} for {URL}")
            if 200 <= r.status_code < 300:
                print("APP UP")
                return 0
            else:
                print("APP DOWN (non-2xx)")
                return 2
        except Exception as e:
            print(f"Attempt {i+1}/{RETRIES} - error: {e}")
            time.sleep(1)
    print("APP DOWN (no response)")
    return 2

if __name__ == '__main__':
    sys.exit(check())
