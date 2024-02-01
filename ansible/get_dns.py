#!/usr/bin/python3

import subprocess
import json

def run_terraform():
    result = subprocess.run(["terraform",  "output", "-json"], capture_output=True, text=True, cwd="../terraform")
    result = json.loads(result.stdout)

    return result

def generate_ansible_inventory():
    terraform_outputs = run_terraform()
    instance_ips = terraform_outputs.get("instance_public_ips", {}).get("value", [])
    instance_names = terraform_outputs.get("instance_name", {}).get("value", [])

    items = zip(instance_ips, instance_names)
    inventory = {"master": {"hosts": [],}, "worker": {"hosts": [],}, "_meta": {"hostvars": {},}}

    for item in items:
      if "master" in item[1]:
        inventory["master"]["hosts"].append(item[0])
        inventory["_meta"]["hostvars"][item[0]] = {"ansible_ssh_host": item[0], "ansible_ssh_user": "ubuntu", "ansible_ssh_private_key_file": "kanban.pem"}
      else:
        inventory["worker"]["hosts"].append(item[0])
        inventory["_meta"]["hostvars"][item[0]] = {"ansible_ssh_host": item[0], "ansible_ssh_user": "ubuntu", "ansible_ssh_private_key_file": "kanban.pem"}
    
    return print(json.dumps(inventory, indent=2))

if __name__== "__main__":
   generate_ansible_inventory() 
