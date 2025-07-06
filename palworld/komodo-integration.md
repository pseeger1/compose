# Komodo Integration Guide for Palworld

This guide explains how to integrate your Palworld server with your existing Komodo instance.

## Option 1: Direct Compose Management (Recommended)

Komodo can directly manage your Palworld compose file. Here's how to set it up:

### 1. Add Palworld as a Resource in Komodo

1. Log into your Komodo web interface (usually at `http://localhost:9120`)
2. Go to **Resources** → **Create Resource**
3. Choose **Docker Compose** as the resource type
4. Configure the resource:
   - **Name**: `Palworld Server`
   - **Description**: `Custom Palworld server with reduced egg hatch time and disabled raids`
   - **Compose File Path**: `/path/to/your/compose/palworld/palworld.compose.yaml`
   - **Environment File**: Leave empty (or specify if you create one)
   - **Working Directory**: `/path/to/your/compose/palworld`

### 2. Git Integration

To use the compose file from git:

1. **Clone your repository** (if not already done):
   ```bash
   git clone <your-repo-url> /path/to/your/compose
   ```

2. **Set up automatic updates**:
   - In Komodo, go to the Palworld resource settings
   - Enable **Auto Sync** if you want Komodo to automatically pull updates
   - Set **Sync Interval** to your preferred frequency (e.g., 5 minutes)

3. **Configure Git credentials** (if using private repo):
   - Add your git credentials to Komodo's environment
   - Or use SSH keys for authentication

### 3. Start the Server

1. In Komodo, go to your Palworld resource
2. Click **Start** to deploy the server
3. Monitor the logs and status through Komodo's interface

## Option 2: External Compose with Komodo Monitoring

If you prefer to run the compose file separately but still monitor it with Komodo:

### 1. Run the Compose File Manually

```bash
cd palworld
docker-compose -f palworld.compose.yaml up -d
```

### 2. Add as External Container in Komodo

1. In Komodo, go to **Resources** → **Create Resource**
2. Choose **External Container**
3. Configure:
   - **Name**: `Palworld Server`
   - **Container Name**: `palworld-server`
   - **Description**: `Palworld game server`

## Option 3: Komodo Periphery Integration

Since your Komodo setup includes Periphery, you can also manage the Palworld server through Periphery:

### 1. Ensure Periphery is Running

Your existing `mongo.compose.yaml` already includes Periphery, so it should be running.

### 2. Use Periphery Commands

Through Komodo's interface, you can use Periphery commands to manage the Palworld container:

- **Start**: `docker-compose -f /path/to/palworld/palworld.compose.yaml up -d`
- **Stop**: `docker-compose -f /path/to/palworld/palworld.compose.yaml down`
- **Restart**: `docker-compose -f /path/to/palworld/palworld.compose.yaml restart`
- **Logs**: `docker-compose -f /path/to/palworld/palworld.compose.yaml logs -f`

## Environment Variables (Optional)

If you want to make the Palworld configuration more flexible, create a `palworld.env` file:

```bash
# palworld/palworld.env
SERVER_NAME="My Palworld Server"
ADMIN_PASSWORD="your-secure-password"
EGG_HATCH_TIME=0.1
ENABLE_RAID=False
ENABLE_WEAPON_DROP_ON_DEATH=False
```

Then reference it in your compose file by adding:
```yaml
env_file: ./palworld.env
```

## Monitoring and Alerts

Once integrated with Komodo, you can:

1. **Monitor server status** in real-time
2. **Set up alerts** for when the server goes down
3. **View logs** through Komodo's interface
4. **Automatically restart** the server if it crashes
5. **Track resource usage** (CPU, memory, disk)

## Troubleshooting

### Common Issues:

1. **Port conflicts**: Ensure ports 8211 and 27015 are available
2. **Permission issues**: Make sure Komodo has access to the compose file directory
3. **Git authentication**: Configure proper git credentials for private repositories
4. **Container naming**: The `komodo.managed: "true"` label helps Komodo identify the container

### Useful Commands:

```bash
# Check if container is running
docker ps | grep palworld

# View logs
docker logs palworld-server

# Check Komodo logs
docker logs komodo-core
```

## Next Steps

1. Choose your preferred integration method
2. Set up the resource in Komodo
3. Test the deployment
4. Configure monitoring and alerts
5. Set up automatic updates from git 
