# Palworld Server Docker Compose

This Docker Compose configuration sets up a Palworld dedicated server with custom settings.

## Features

- **Reduced Egg Hatch Time**: Eggs hatch at 10% of normal time (0.1x multiplier)
- **Disabled Raids**: Raids are completely disabled
- **Disabled Weapon Drops on Death**: Players keep their weapons when they die
- **PvP Disabled**: Player vs Player damage is disabled for a more cooperative experience

## Quick Start

1. Navigate to the palworld directory:
   ```bash
   cd palworld
   ```

2. Start the server:
   ```bash
   docker-compose -f palworld.compose.yaml up -d
   ```

3. Stop the server:
   ```bash
   docker-compose -f palworld.compose.yaml down
   ```

## Server Details

- **Game Port**: 8211 (UDP)
- **Steam Query Port**: 27015 (UDP)
- **Max Players**: 32
- **Admin Password**: admin123 (change this in production!)

## Customization

You can modify the environment variables in `palworld.compose.yaml` to adjust:

- `EGG_HATCH_TIME`: Egg hatch time multiplier (0.1 = 10% of normal time)
- `ENABLE_RAID`: Set to "False" to disable raids
- `ENABLE_WEAPON_DROP_ON_DEATH`: Set to "False" to keep weapons on death
- `SERVER_NAME`: Your server name
- `ADMIN_PASSWORD`: Admin password for server management

## Data Persistence

The server data is stored in Docker volumes:
- `palworld-data`: Game saves and player data
- `palworld-config`: Server configuration files

## Connecting to the Server

Players can connect to your server using:
- **Direct IP**: Your server's IP address
- **Port**: 8211

## Important Notes

- Make sure ports 8211 and 27015 are open in your firewall
- The server may take a few minutes to fully start up
- Check logs with: `docker-compose -f palworld.compose.yaml logs -f` 
