# Inception Of Things (42 School Project)

## Project Description

The *Inception Of Things* project was designed to help familiarize students with various network management and application deployment tools. Specifically, this project focuses on technologies like Vagrant, K3s, ArgoCD, and GitLab, which are essential for modern infrastructure management and automation in the context of DevOps practices.

---

## Project Breakdown

### P1: Vagrant Virtual Machine Setup and K3s Installation

In the first phase, we utilized **Vagrant** to provision two virtual machines. On these VMs, we installed **K3s**, a lightweight Kubernetes distribution, to set up a **K3s cluster** with one server node and one agent node. This setup simulates a minimal yet functional Kubernetes environment for containerized application management.

### P2: Vagrant VM Setup with K3s and Application Deployment

For the second phase, Vagrant was used again to create a VM with **K3s in server mode**. On this VM, we deployed three applications:

1. **Grafana** – for monitoring and visualization
2. **HTTPD** – a basic web server application
3. **Portainer** – for Docker container management

One of these applications was configured to have **3 replicas** in the K3s cluster to demonstrate **scalability** and **high availability** within the architecture. These applications were chosen for illustrative purposes, focusing on the architecture and Kubernetes management rather than the applications themselves.

### P3: K3s Cluster Creation with K3d and ArgoCD Integration

In the third phase, a **K3s cluster** was created using **K3d**, which enables running Kubernetes clusters in Docker containers. We then implemented **ArgoCD** to automate the deployment of applications. ArgoCD monitors GitHub repositories for changes to application tags and automatically deploys updates to the Kubernetes cluster based on versioning.

### Bonus: Local GitLab Integration

For the bonus phase, we extended the functionality of P3 by integrating a **local GitLab instance** into the workflow. This setup allows for a private Git repository, where version-controlled applications are pushed to the repository and then automatically deployed via ArgoCD. The use of a local GitLab instance adds another layer of customization and control over the CI/CD pipeline.

---

## Key Skills Acquired

Throughout the project, I gained hands-on experience with several industry-standard tools and concepts, including:

- **Vagrant**: Automating the provisioning of virtual machines and configuring environments.
- **K3s**: Setting up and managing lightweight Kubernetes clusters for container orchestration.
- **ArgoCD**: Implementing continuous deployment pipelines for automatic application updates based on Git versioning.
- **GitLab**: Using GitLab for source code management and integrating it with the deployment pipeline.
- **Containerization**: Understanding the principles of containerization and deploying applications in a Kubernetes environment.

---

## Acknowledgements

I would like to express my sincere gratitude to **42 School** for providing the resources and learning environment that made this project possible. 

---

## License

This project is licensed under the MIT License.
