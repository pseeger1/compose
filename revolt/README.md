# Revolt Self-Hosted Docker Setup

This Docker Compose configuration sets up a complete Revolt self-hosted instance with all necessary services.

## What's Included

- **MongoDB 6** - Database for storing user data, messages, and server information
- **Redis 7** - Caching layer for improved performance
- **Revolt API** - Backend API server
- **Revolt Web Client** - Web-based chat interface
- **Nginx** - Reverse proxy with SSL support and security headers

## Quick Start

### 1. Prerequisites

- Docker and Docker Compose installed
- At least 2GB RAM available
- Ports 80, 443, 3000, and 3001 available

### 2. Configuration

1. **Edit the environment file**:
   ```bash
   nano revolt.env
   ```

2. **Update the following variables**:
   - `MONGO_PASSWORD` - Set a secure database password
   - `REVOLT_JWT_SECRET` - Generate a secure JWT secret
   - `REVOLT_APP_URL` - Your domain or localhost URL
   - `REVOLT_API_URL` - Your API URL
   - `REVOLT_WEBSOCKET_URL` - Your WebSocket URL

3. **For production, update URLs to your domain**:
   ```bash
   REVOLT_APP_URL=https://yourdomain.com
   REVOLT_API_URL=https://yourdomain.com
   REVOLT_WEBSOCKET_URL=wss://yourdomain.com
   ```

### 3. Start the Services

```bash
# Start all services
docker-compose -f revolt.compose.yaml up -d

# View logs
docker-compose -f revolt.compose.yaml logs -f

# Stop services
docker-compose -f revolt.compose.yaml down
```

### 4. Access Your Revolt Instance

- **Web Client**: http://localhost (or your domain)
- **API**: http://localhost/api
- **Health Check**: http://localhost/health

## Configuration Options

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `MONGO_USERNAME` | MongoDB admin username | `admin` |
| `MONGO_PASSWORD` | MongoDB admin password | `password` |
| `REVOLT_APP_URL` | Main application URL | `http://localhost:3000` |
| `REVOLT_API_URL` | API server URL | `http://localhost:3000` |
| `REVOLT_WEBSOCKET_URL` | WebSocket URL | `ws://localhost:3000` |
| `REVOLT_JWT_SECRET` | JWT signing secret | `your-super-secret-jwt-key` |
| `REVOLT_EMAIL_VERIFICATION` | Enable email verification | `false` |
| `REVOLT_REGISTRATION_DISABLED` | Disable user registration | `false` |
| `REVOLT_INVITE_ONLY` | Require invites to register | `false` |
| `REVOLT_MAX_FILE_SIZE` | Maximum file upload size (bytes) | `16777216` (16MB) |

### Email Configuration (Optional)

To enable email verification and password reset:

```bash
REVOLT_SMTP_HOST=smtp.gmail.com
REVOLT_SMTP_USERNAME=your-email@gmail.com
REVOLT_SMTP_PASSWORD=your-app-password
REVOLT_SMTP_FROM=noreply@yourdomain.com
REVOLT_EMAIL_VERIFICATION=true
```

### Security Settings

```bash
# Disable registration (admin creates users)
REVOLT_REGISTRATION_DISABLED=true

# Require invites to register
REVOLT_INVITE_ONLY=true

# Enable rate limiting
REVOLT_RATE_LIMIT_ENABLED=true
```

## Production Deployment

### 1. SSL/HTTPS Setup

1. **Obtain SSL certificates** (Let's Encrypt recommended)
2. **Update nginx.conf** with your domain and certificate paths
3. **Uncomment the HTTPS server block** in nginx.conf
4. **Update environment variables** to use HTTPS URLs

### 2. Domain Configuration

Update your DNS to point to your server:
```
A     yourdomain.com     YOUR_SERVER_IP
A     api.yourdomain.com YOUR_SERVER_IP
```

### 3. Firewall Configuration

```bash
# Allow HTTP/HTTPS traffic
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Block direct access to API/Web ports
sudo ufw deny 3000/tcp
sudo ufw deny 3001/tcp
```

### 4. Backup Strategy

```bash
# Backup MongoDB
docker exec revolt-mongodb mongodump --out /data/backup

# Backup uploads
docker cp revolt-api:/app/uploads ./backups/uploads

# Backup configuration
cp revolt.env ./backups/
cp nginx.conf ./backups/
```

## Monitoring and Maintenance

### Health Checks

```bash
# Check service status
docker-compose -f revolt.compose.yaml ps

# Check logs
docker-compose -f revolt.compose.yaml logs api
docker-compose -f revolt.compose.yaml logs web
docker-compose -f revolt.compose.yaml logs nginx

# Monitor resource usage
docker stats revolt-api revolt-web revolt-mongodb revolt-redis
```

### Updates

```bash
# Pull latest images
docker-compose -f revolt.compose.yaml pull

# Restart services
docker-compose -f revolt.compose.yaml up -d
```

### Troubleshooting

#### Common Issues

1. **Port conflicts**: Ensure ports 80, 443, 3000, 3001 are available
2. **Database connection**: Check MongoDB credentials in revolt.env
3. **File permissions**: Ensure Docker has access to volumes
4. **Memory issues**: Increase Docker memory limit if needed

#### Log Analysis

```bash
# View API logs
docker logs revolt-api

# View web client logs
docker logs revolt-web

# View nginx logs
docker logs revolt-nginx

# Check MongoDB logs
docker logs revolt-mongodb
```

## Client Applications

### Desktop Client

Download the official Revolt desktop client and configure it to connect to your instance:
- **Server URL**: `https://yourdomain.com` (or `http://localhost` for local)

### Mobile Apps

Third-party mobile apps may support custom Revolt instances. Check their documentation for configuration options.

## Security Considerations

1. **Change default passwords** in revolt.env
2. **Use strong JWT secrets**
3. **Enable HTTPS in production**
4. **Configure firewall rules**
5. **Regular security updates**
6. **Monitor logs for suspicious activity**

## Support

- **Official Documentation**: https://developers.revolt.chat/
- **GitHub Repository**: https://github.com/revoltchat
- **Community Discord**: https://rvlt.gg

## License

This setup uses the official Revolt software which is licensed under the AGPL-3.0 license. 
