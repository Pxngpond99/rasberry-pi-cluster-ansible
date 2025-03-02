# Ansible Raspberry Pi Cluster

## Overview
This repository provides an automated method to set up a **Raspberry Pi 3 Model B Cluster** using **Ansible** with **Slurm** as the job scheduler. The cluster is designed for small-scale High-Performance Computing (HPC) applications, making it an excellent solution for learning, research, and lightweight parallel computing tasks.

## Features
- Automated setup using **Ansible**
- Slurm workload manager installation and configuration
- Secure SSH key-based authentication
- NFS shared storage setup
- System performance optimizations
- Easy scalability with new nodes

## Prerequisites
- Raspberry Pi 3 Model B (at least 2 nodes)
- Raspbian OS installed on all nodes
- Network connectivity between nodes
- Ansible installed on the master node
- Basic understanding of Ansible and Linux administration

## Cluster Architecture
- **Head Node:** Controls job scheduling and resource management
- **Compute Nodes:** Execute jobs assigned by the master node
- **NFS Server:** Provides shared storage for all nodes

## Installation
1. Clone this repository on the master node:
   ```bash
   git clone https://github.com/your-username/ansible-rpi-cluster.git
   cd ansible-rpi-cluster
   ```
2. Configure inventory file (Edit hosts to define your cluster nodes)
   ```bash
    [head_node]
    node1 ansible_ssh_host=<your_head_node_ip>
    
    [compute_node]
    node2 ansible_ssh_host=<your_compute_node_ip>
    node3 ansible_ssh_host=<your_compute_node_ip>
    node4 ansible_ssh_host=<your_compute_node_ip>
   
    [slurm_cluster:children]
    head_node
    compute_node
   ```
3. Also edit information about yoour node in ./vars/main.yml
   ```INI
    [head_node]
    node1 ansible_ssh_host=<your_head_node_ip>
    
    [compute_node]
    node2 ansible_ssh_host=<your_compute_node_ip>
    node3 ansible_ssh_host=<your_compute_node_ip>
    node4 ansible_ssh_host=<your_compute_node_ip>
   
    [slurm_cluster:children]
    head_node
    compute_node
   ```
4. run ./secure_ssh_setup.sh
   ```yaml
    system_setup_hosts_mapping:
      head_node:
      - ip: "<your_head_node_ip>"
        hostname: "<new_head_node_hostname>"
      compute_node:
      - ip: "<your_compute_node_ip>"
        hostname: "<new_compute_node_hostname>"
   
    nfs_setup_network: "<ypur_network_CIDR>"
    nfs_setup_server_ip: "<NFS_server_IP>"
   
    slurm_setup_hosts_mapping:
      head_node:
      - ip: "<your_head_node_ip>"
        hostname: "<new_host_node_hostname>"
        CPUs: 4
        Sockets: 1
        CoresPerSocket: 4
        ThreadsPerCore: 1
        RealMemory: 907
      compute_node:
      - ip: "<your_compute_node_ip>"
        hostname: "<new_compute_node_hostname>"
        CPUs: 4
        Sockets: 1
        CoresPerSocket: 4
        ThreadsPerCore: 1
        RealMemory: 907
   ```
6. run ansible-playbook (-vv for select the amount of logging details)
   ```bash
    ansible-playbook site.yml -vv
   ```
