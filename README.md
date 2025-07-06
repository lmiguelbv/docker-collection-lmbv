# 🐳 Docker Collection by LMBV  
  

A curated Docker Compose which includes media servers, VPNs, DNS filtering, monitoring tools, and more ideal for cloud solutions and self-hosted scenarios like Raspberry Pi or on-premises based servers.  
  
  
  

---  
  

## 📑 Table of Contents  
  

- [⚠️ Disclaimers](#️-disclaimer)  
- [🛠️ Prerequisites](#️-prerequisites)  
- [📂 Folder Structure & Permissions](#-folder-structure--permissions)  
- [🔧 Services Overview](#-services-overview)  
- [🚀 Getting Started](#-getting-started)  
- - [🔐 Security Tips](#-security-tips)  
- - [⚙️ Environment Variables](#-enviroment-variables)  
- - [📝 Git Ignore Suggestions](#-git-ignore-suggestions)  
- [🧠 Visual Overview (Conceptual)](#-visual-overview)  
- [📰 Additional Resources](#-additional-resources)  
  
  
  

---  
  

## ⚠️ Disclaimers  
  

> This repository is tested and configured primarily for **Ubuntu on ARM architecture** (e.g., Raspberry Pi or systems based on ARM CPU). While most services have x86_64 image variants, always validate compatibility with your architecture if using a different system.  

---  

> For cloud-based setups, extra security measures have to be taken into  
> account.  Some hints below, but ensure to check individual needs.   

---  
  

## 🛠️ Prerequisites  
  

To deploy the services, install the following:  
  

- [Docker Engine](https://docs.docker.com/engine/install/ubuntu/)  
- [Docker Compose](https://docs.docker.com/compose/install/)  
  

✅ Compatible with both **ARM** and **x86_64** systems, depending on image support.  
  

---  
  

## 📂 Folder Structure & Permissions  
  

Below is the structure of expected bind mount directories and files. Ensure directories exist before starting containers and have the appropriate permissions.  
  

Some services include bind-mounted directories, subfolders, files, and scripts required for proper function, such as:  
  

>Examples ⬇️  
>- `backups/`  
>- `cache/`  
>- `logs/`  
>- `exports/`  
>- `data/`  
  

These directories are:  
  

- Created automatically by containers at runtime  
- Often system-specific or contain volatile data  
- Frequently **empty by default**, especially on first launch  
  

### **Expected bind mount structure**  
  

**These are excluded from the actual version control**  to reduce repository size and ensure cleaner commits. Config based on your needs.   
  

> ```bash  
>path/to/desired/bind_mount/directory/  
>├── emby/ # Emby media server files  
>├── jellyfin/ # Jellyfin media server files  
>├── nginx/ # NPM - reverse proxy configs  
>├── openvpn/ # OpenVPN configs and credentials  
>├── pihole/ #Pihole config files and subfolders  
>├── plex/ # Plex media server configs and media  
>├── portainer/ # Portainer data  
>├── tautulli/ #Tautulli config files  
>├── unbound/ #Unbound config files  
>├── wireguard/ # WireGuard VPN configs  
>├──docker-compose.yml #Main Docker Compose file  
  

 Apply basic permissions with:  

>  
> ```bash  
> sudo mkdir -p /docker/{emby,jellyfin,nginx,openvpn,pihole,plex,portainer,tautulli,unbound,wireguard}  
> sudo chmod -R 755 /docker  
> sudo chown -R 1000:1000 /docker  
> ```  
  

Replace `1000:1000` with the correct UID:GID if your containers use custom users.  
  

---  
  

**This repository tracked structure**  
  

The following bind mount directories that **contain configuration files or scripts** (e.g., ⁣`/unbound/` → `Subfolders and files`) **are tracked**; representing crucial operational settings that may be replicated to ensure proper functionality as they are not auto-mounted or created at the moment of container initialization.  

For other services out of Unbound, follow the mount guidelines above.   

>/docker/  
>├──docker-compose.yml  
├── unbound/  
│ ├──unbound.conf  
│ ├── config/  
│ ├── conf.d/  
│ ------└──access-control.conf   
│ ------└──forward-zone.conf   
│ ------└──interfaces.conf   
│ ------└──logging.conf   
│ ------└──security.conf  
│ ------└──trust-anchor.conf  
│ ├── iana.d/  ⛔ Excluded  
│ ------└──root.key  ⛔ Excluded  (Auto-generated with the proper config of trust-anchor.conf file)
│ ------└──root.zone  ⛔ Excluded  
│ ├── zones.d/  
│ ------└──auth-zone.conf  
│ ├── log.d/ # ⛔ Excluded  
│ ------└── unbound.log # ⛔ Excluded (log file only: could generate a large size)  
  
  
root.zone is excluded as it can be obtained → 
`wget https://www.internic.net/domain/root.zone` to get into **/home/pi/unbound/iana.d/**

## 🔧 Services Overview  
  

A summary of the services in this setup, with links to official websites:  
  

| Service      | Description                                                            |  
|--------------|------------------------------------------------------------------------|  
| [NGINX Proxy Manager](https://nginxproxymanager.com/)         | Web server and reverse proxy for routing internal services through web UI           |                    
| [WireGuard](https://www.wireguard.com/) | Fast, modern VPN tunnel                                                 |  
| [OpenVPN](https://openvpn.net/)     | Traditional VPN with support for multiple clients                      |  
| [Pi-hole](https://pi-hole.net/)     | Network-wide ad and tracker blocking via DNS filtering                 |  
| [Unbound](https://nlnetlabs.nl/projects/unbound/about/) | Validating, recursive DNS resolver often paired with Pi-hole         |  
| [Portainer](https://www.portainer.io/) | Docker container and volume management through a web UI             |  
| [Plex](https://www.plex.tv/)        | Media server with remote access and streaming                          |  
| [Tautulli](https://tautulli.com/)   | Plex usage analytics, notifications, and monitoring  
| [Jellyfin](https://jellyfin.org/)   | Free software media system alternative to Plex                         |  
| [Emby](https://emby.media/)         | Media server focused on organization and metadata                       |  

---  
  

## 🚀 Getting Started  
  

1. Clone the repository:  
   ```bash  
   git clone https://github.com/lmiguelbv/docker-collection-lmbv.git  
   cd docker-collection-lmbv  
   ```  
  
2. Ensure Docker and Docker Compose are installed ([see prerequisites](#️-prerequisites)).  
  
3. Review and adjust `docker-compose.yml` and mount paths if needed.  
  
4. Launch all services:  
   ```bash  
   docker compose up -d  
   ```  
   To initiate a specific service (replace accordingly)  
   ```bash  
   docker compose up -d #name_of_the_service_container_stated_on_the_compose_file  
   ```  
  

---  
  

## 🔐 Security Tips  
  

- Change default credentials on first login for all services.  
- Use strong firewall rules to limit access to services like Portainer, OpenVPN, and NGINX UI.  
- Always keep your images up to date:  
  ```bash  
  docker compose pull  
  docker compose up -d  
  ```  
- Use `.env` files to avoid hardcoding sensitive variables in `docker-compose.yml`.  
- **Use Fail2Ban** or similar on your host to block repeated failed login attempts to public-facing services.
- **Restrict NGINX UI access** to a trusted IP range using `nginx` or Docker network configuration.
- **Run containers as non-root** whenever possible by setting user IDs explicitly.
- **Enable auto-renewal of SSL certificates** in reverse proxies like NGINX Proxy Manager (NPM).
- **Separate Docker networks** for public and internal services to minimize unnecessary exposure.
- **Use Secrets Management**: For highly sensitive data, consider Docker Secrets or mounting config from encrypted files.
  

---  
  

## ⚙️ Environment Variables  
  

You can optionally create a `.env` file to store common variables:  
  

```env  
PUID=1000  
PGID=1000  
TZ=Europe/Madrid  
```  
  

Make sure to reference these in your `docker-compose.yml`:  
  

```yaml  
    environment:  
      - PUID=${PUID}  
      - PGID=${PGID}  
      - TZ=${TZ}  
```  
  

---  
  

## 📝 Git Ignore Suggestions  
  

Here’s a sample `.gitignore` to avoid pushing temporary files or runtime content:  
  

```  
*.log  
*.db  
*.pid  
log.d/  
cache/  
backups/  
exports/  
.env  
```  
  

---  
  

## 🧠 Visual Overview (Conceptual)  
  

```text  
[ Internet ]  
     ↓  
  [NGINX Proxy Manager]  
     ↓          ↘  
 [Pihole]     [Plex]  
                ↓  
           [Tautulli]  
```  
  

This simplified flow illustrates how traffic may move between your DNS, reverse proxy, and media services.  
  

---  
  

## 📰 Additional Resources  
  

Useful and additional resources to better understand the proper configuration of some services present in this repository   
  
- [Pihole + unbound docker setup on Raspberry Pi](https://www.xfelix.com/2020/09/pihole-unbound-docker-setup-on-raspberry-pi/)   
- [Unbound Docker Image documentation](https://github.com/madnuttah/unbound-docker/blob/main/README.md)
- [Best Practices for Writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [OWASP Docker Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html)
- [Hardening Docker and Docker Compose](https://blog.gitguardian.com/20-docker-security-best-practices/)
- [Watchtower](https://containrrr.dev/watchtower/) — automatic Docker container update tool
