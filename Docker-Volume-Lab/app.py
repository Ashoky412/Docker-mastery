
import os
import time

log_path = os.getenv("LOG_PATH", "/app/logs")
os.makedirs(log_path, exist_ok=True)
log_file = os.path.join(log_path, "log.txt")

for i in range(5):
    with open(log_file, "a") as f:
        f.write(f"Log entry {i+1}\n")
    time.sleep(1)

print(f"Logs written to {log_file}")
