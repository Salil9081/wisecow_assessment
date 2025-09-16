#!/usr/bin/env bash
LOGFILE="/var/log/sys_health.log"
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80
PROC_THRESHOLD=400

timestamp() { date "+%Y-%m-%d %H:%M:%S"; }

CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print 100-$8}')
MEM=$(free | awk '/^Mem:/ {printf("%.0f", $3/$2 * 100)}')
DISK=$(df / | awk 'END{print +$5}')
PROCS=$(ps aux --no-heading | wc -l)

LINE="$(timestamp) CPU:${CPU}% MEM:${MEM}% DISK:${DISK}% PROCS:${PROCS}"
echo "$LINE" | tee -a "$LOGFILE"

if [ "$CPU" -ge "$CPU_THRESHOLD" ]; then
  echo "$(timestamp) ALERT: CPU ${CPU}% >= ${CPU_THRESHOLD}%" | tee -a "$LOGFILE"
fi
if [ "$MEM" -ge "$MEM_THRESHOLD" ]; then
  echo "$(timestamp) ALERT: MEM ${MEM}% >= ${MEM_THRESHOLD}%" | tee -a "$LOGFILE"
fi
if [ "$DISK" -ge "$DISK_THRESHOLD" ]; then
  echo "$(timestamp) ALERT: DISK ${DISK}% >= ${DISK_THRESHOLD}%" | tee -a "$LOGFILE"
fi
if [ "$PROCS" -ge "$PROC_THRESHOLD" ]; then
  echo "$(timestamp) ALERT: PROCESSES ${PROCS} >= ${PROC_THRESHOLD}" | tee -a "$LOGFILE"
fi
