#!/bin/sh

wait_for_dpkg() {
  while sudo lsof /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
      echo "Waiting for other software managers to finish..."
      sleep 2
  done

}

wait_for_dpkg
sudo apt update
wait_for_dpkg
sudo apt install -y python3-pip
wait_for_dpkg

pip3 install locust
pip3 install charset-normalizer

touch locustfile.py

echo "from locust import HttpUser, task, between" > locustfile.py
echo "" >> locustfile.py
echo "class QuickstartUser(HttpUser):" >> locustfile.py
echo "" >> locustfile.py
echo "    @task" >> locustfile.py
echo "    def index_page(self):" >> locustfile.py
echo "        self.client.get(\"/\")" >> locustfile.py

nohup locust --worker --master-host=${MASTER_IP} 2>&1 &
